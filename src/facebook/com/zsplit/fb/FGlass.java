package com.zsplit.fb;

import android.content.res.Configuration;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.LinearGradient;
import android.graphics.Outline;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PixelFormat;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.RenderEffect;
import android.graphics.RenderNode;
import android.graphics.RuntimeShader;
import android.graphics.Shader;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.RippleDrawable;
import android.os.Build;
import android.os.SystemClock;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.view.ViewParent;
import android.widget.LinearLayout;
import java.util.WeakHashMap;

final class FGlass extends Drawable {
    // Zalo Android Duo droplet shader (brand-tinted icons inside the droplet, prism meniscus, SDF clip)
    private static final String SHADER_SRC =
            "uniform shader content;\n" +
            "uniform float2 size;\n" +
            "uniform float radius;\n" +
            "uniform float edge;\n" +
            "uniform float strength;\n" +
            "uniform float mag;\n" +
            "uniform float pad;\n" +
            "uniform float4 tintBg;\n" +
            "uniform float4 selColor;\n" +
            "float sd(float2 p, float2 b, float r){ float2 q=abs(p)-b+float2(r); return length(max(q,float2(0.0)))+min(max(q.x,q.y),0.0)-r; }\n" +
            "half4 main(float2 xy){\n" +
            " float2 c=size*0.5;\n" +
            " float2 p=xy-float2(pad)-c;\n" +
            " float d=sd(p,c,radius);\n" +
            " if(d>0.5) return half4(0.0);\n" +
            " float aa=clamp(0.5-d,0.0,1.0);\n" +
            " float2 g=float2(sd(p+float2(1.0,0.0),c,radius)-sd(p-float2(1.0,0.0),c,radius), sd(p+float2(0.0,1.0),c,radius)-sd(p-float2(0.0,1.0),c,radius));\n" +
            " float gl=length(g);\n" +
            " float2 n=gl>0.0001 ? g/gl : float2(0.0);\n" +
            " float k=clamp(1.0+d/edge,0.0,1.0);\n" +
            " k=k*k*k;\n" +
            " float2 base=float2(pad)+c+p/mag;\n" +
            " float o=k*strength;\n" +
            " half4 r=content.eval(base+n*o);\n" +
            " half4 gg=content.eval(base+n*o*1.22);\n" +
            " half4 b=content.eval(base+n*o*1.44);\n" +
            " half4 fg=half4(r.r,gg.g,b.b,max(r.a,max(gg.a,b.a)));\n" +
            " float sat=max(fg.r,max(fg.g,fg.b))-min(fg.r,min(fg.g,fg.b));\n" +
            " float mono=clamp(1.0-sat*3.0,0.0,1.0);\n" +
            " half3 selRgb=mix(fg.rgb, half3(selColor.rgb)*fg.a, half(mono*0.98));\n" +
            " half3 prism=half3(r.a-gg.a, 0.0, b.a-gg.a)*half(k*0.75);\n" +
            " half3 outRgb=clamp(selRgb + prism, half3(0.0), half3(1.0)) + half3(tintBg.rgb)*(1.0-fg.a);\n" +
            " half outA=max(fg.a, half(tintBg.a));\n" +
            " return half4(outRgb, outA)*aa;\n" +
            "}";

    private static final String BAR_SHADER_SRC =
            "uniform shader content;\n" +
            "uniform float2 size;\n" +
            "uniform float radius;\n" +
            "uniform float edge;\n" +
            "uniform float strength;\n" +
            "uniform float mag;\n" +
            "uniform float pad;\n" +
            "float sd(float2 p, float2 b, float r){ float2 q=abs(p)-b+float2(r); return length(max(q,float2(0.0)))+min(max(q.x,q.y),0.0)-r; }\n" +
            "half4 main(float2 xy){\n" +
            " float2 c=size*0.5;\n" +
            " float2 p=xy-float2(pad)-c;\n" +
            " float d=sd(p,c,radius);\n" +
            " if(d>0.0) return content.eval(xy);\n" +
            " float2 g=float2(sd(p+float2(1.0,0.0),c,radius)-sd(p-float2(1.0,0.0),c,radius), sd(p+float2(0.0,1.0),c,radius)-sd(p-float2(0.0,1.0),c,radius));\n" +
            " float gl=length(g);\n" +
            " float2 n=gl>0.0001 ? g/gl : float2(0.0);\n" +
            " float k=clamp(1.0+d/edge,0.0,1.0);\n" +
            " k=k*k*k;\n" +
            " float2 base=float2(pad)+c+p/mag;\n" +
            " float o=k*strength;\n" +
            " half4 r=content.eval(base+n*o);\n" +
            " half4 gg=content.eval(base+n*o*1.04);\n" +
            " half4 b=content.eval(base+n*o*1.08);\n" +
            " return half4(r.r,gg.g,b.b,gg.a);\n" +
            "}";

    private static final WeakHashMap<View, FDrag> sDragMap = new WeakHashMap<>();
    static final ViewOutlineProvider sPillOutline = new ViewOutlineProvider() {
        @Override
        public void getOutline(View view, Outline outline) {
            int w = view.getWidth();
            int h = view.getHeight();
            if (w > 0 && h > 0) {
                float r = Math.min(w, h) * 0.5f;
                outline.setRoundRect(0, 0, w, h, r);
            }
        }
    };

    final LinearLayout host;
    View backdrop;
    float cur = Float.NaN;
    float drag = Float.NaN;
    float vel = 0f;
    float hold = Float.NaN;
    long holdT = 0L;
    boolean lens = false;
    float lensA = 0f;
    boolean capturing = false;
    final TabFx fx = new TabFx();
    boolean forceDark = false;
    private boolean scrollHooked = false;
    private long lastTickMs = 0L;

    final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    final RectF rect = new RectF();
    private final RectF barRect = new RectF();
    private Path path;
    private Path barPath;
    private RenderNode node;
    private RenderNode barBlurNode;
    private RuntimeShader rs;
    private RuntimeShader barRs;
    private boolean vivoActive;
    private int vivoStyle = -1;
    private float vivoRadius = -1f;
    private static boolean sVivoProbed;
    private static java.lang.reflect.Method sSetMaterial;
    private static java.lang.reflect.Method sSetCornerRadius;
    private static java.lang.reflect.Method sSetForceUpdateBg;
    private static java.lang.reflect.Method sSetDamageHwLayer;

    private static void probeVivo() {
        if (sVivoProbed) return;
        sVivoProbed = true;
        try {
            sSetMaterial = View.class.getMethod("setMaterial", int.class, int.class);
            sSetCornerRadius = View.class.getMethod("setMaterialCornerRadius", float.class);
            try {
                sSetForceUpdateBg = View.class.getMethod("setMaterialForceUpdateBg", boolean.class);
            } catch (Throwable ignored) {}
            try {
                sSetDamageHwLayer = View.class.getMethod("setMaterialDamageHardwareLayer", boolean.class);
            } catch (Throwable ignored) {}
        } catch (Throwable t) {
            android.util.Log.i("FGlass", "Vivo native glass unavailable: " + t);
            sSetMaterial = null;
        }
    }

    private boolean ensureVivoGlass(float r, boolean dark) {
        probeVivo();
        if (sSetMaterial == null) return false;
        int wantStyle = dark ? 411 : 409;
        if (vivoActive && vivoStyle == wantStyle && Math.abs(vivoRadius - r) < 1f) {
            return true;
        }
        try {
            Object res = sSetMaterial.invoke(host, wantStyle, 1);
            boolean ok = (res instanceof Boolean) && ((Boolean) res).booleanValue();
            if (ok) {
                if (sSetCornerRadius != null) sSetCornerRadius.invoke(host, r);
                if (sSetForceUpdateBg != null) sSetForceUpdateBg.invoke(host, Boolean.FALSE);
                if (sSetDamageHwLayer != null) sSetDamageHwLayer.invoke(host, Boolean.TRUE);
                vivoActive = true;
                vivoStyle = wantStyle;
                vivoRadius = r;
                android.util.Log.i("FGlass", "Vivo native Liquid Glass ENABLED style=" + wantStyle + " r=" + r);
                return true;
            } else {
                android.util.Log.i("FGlass", "Vivo setMaterial returned false for style=" + wantStyle);
            }
        } catch (Throwable t) {
            android.util.Log.i("FGlass", "Vivo setMaterial error: " + t);
            sSetMaterial = null;
        }
        vivoActive = false;
        return false;
    }

    FGlass(LinearLayout host) {
        this.host = host;
    }

    static FGlass attach(LinearLayout tabBar, View pager) {
        Drawable bg = tabBar.getBackground();
        FGlass glass;
        if (!(bg instanceof FGlass)) {
            glass = new FGlass(tabBar);
            tabBar.setWillNotDraw(false);
            tabBar.setBackground(glass);
            tabBar.setForeground(new FFore(glass));
            ViewParent p = tabBar.getParent();
            for (int i = 0; i < 4 && p instanceof ViewGroup; i++) {
                ViewGroup vg = (ViewGroup) p;
                vg.setClipChildren(false);
                vg.setClipToPadding(false);
                p = vg.getParent();
            }
        } else {
            glass = (FGlass) bg;
        }
        glass.backdrop = pager;

        float d = tabBar.getResources().getDisplayMetrics().density;
        if (tabBar.getOutlineProvider() != sPillOutline) {
            tabBar.setOutlineProvider(sPillOutline);
            tabBar.invalidateOutline();
        }
        float wantElev = glass.isVertical() ? (5f * d) : (8f * d);
        if (tabBar.getElevation() != wantElev) {
            tabBar.setElevation(wantElev);
        }

        // Strip Facebook's square gray press/selection backgrounds & attach drag listeners to tab items
        int n = tabBar.getChildCount();
        for (int i = 0; i < n; i++) {
            View child = tabBar.getChildAt(i);
            if (child.getBackground() != null) child.setBackground(null);
            if (child.getForeground() != null) child.setForeground(null);
            noRipple(child);
            if (!sDragMap.containsKey(child)) {
                FDrag drag = new FDrag(glass);
                child.setOnTouchListener(drag);
                sDragMap.put(child, drag);
            }
        }
        glass.tick();
        return glass;
    }

    private static void noRipple(View v) {
        Drawable bg = v.getBackground();
        if (bg instanceof RippleDrawable || bg instanceof android.graphics.drawable.StateListDrawable) {
            v.setBackground(null);
        }
        Drawable fg = v.getForeground();
        if (fg instanceof RippleDrawable || fg instanceof android.graphics.drawable.StateListDrawable) {
            v.setForeground(null);
        }
        if (v instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) v;
            for (int i = 0; i < vg.getChildCount(); i++) {
                noRipple(vg.getChildAt(i));
            }
        }
    }

    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    @Override public void setAlpha(int alpha) {}
    @Override public void setColorFilter(ColorFilter cf) {}

    private static boolean isDark(View v) {
        return TabFx.themeDark(v);
    }

    private boolean isDarkMode() {
        return forceDark || isDark(host);
    }

    boolean isVertical() {
        return host.getOrientation() == LinearLayout.VERTICAL;
    }

    int visCount() {
        int c = 0;
        for (int i = 0; i < host.getChildCount(); i++) {
            if (host.getChildAt(i).getVisibility() == View.VISIBLE) c++;
        }
        return c;
    }

    View visKid(int idx) {
        int c = 0;
        for (int i = 0; i < host.getChildCount(); i++) {
            View v = host.getChildAt(i);
            if (v.getVisibility() == View.VISIBLE) {
                if (c == idx) return v;
                c++;
            }
        }
        return null;
    }

    float centerAxis(View v) {
        return isVertical()
                ? (v.getTop() + v.getHeight() * 0.5f)
                : (v.getLeft() + v.getWidth() * 0.5f);
    }

    float sizeAxis(View v) {
        return isVertical() ? v.getHeight() : v.getWidth();
    }

    float posFromCoord(float coord) {
        int n = visCount();
        for (int i = 0; i < n - 1; i++) {
            View a = visKid(i);
            View b = visKid(i + 1);
            if (a == null || b == null) continue;
            float ac = centerAxis(a);
            float bc = centerAxis(b);
            if (coord <= bc) {
                float t = (bc != ac) ? (coord - ac) / (bc - ac) : 0f;
                if (t < 0f) t = 0f;
                return i + t;
            }
        }
        return Math.max(0, n - 1);
    }

    float activePos() {
        int n = visCount();
        for (int i = 0; i < n; i++) {
            View v = visKid(i);
            if (v != null && v.isSelected()) return (float) i;
        }
        return Float.NaN;
    }

    void tick() {
        if (!scrollHooked && backdrop != null) {
            scrollHooked = true;
            try {
                backdrop.getViewTreeObserver().addOnScrollChangedListener(new android.view.ViewTreeObserver.OnScrollChangedListener() {
                    @Override
                    public void onScrollChanged() {
                        if (host != null && !vivoActive) host.invalidate();
                    }
                });
            } catch (Throwable ignored) {
            }
        }
        long now = SystemClock.uptimeMillis();
        float dt = (lastTickMs > 0L) ? Math.min(32f, Math.max(4f, now - lastTickMs)) : 16.67f;
        lastTickMs = now;
        float step = dt / 16.67f;

        tickSpring(step);
        float targetA = lens ? 1f : 0f;
        float diff = targetA - lensA;
        if (Math.abs(diff) < 0.01f) {
            if (lensA != targetA) {
                lensA = targetA;
                host.invalidate();
            }
        } else {
            lensA += diff * (1f - (float) Math.pow(0.88, step));
            host.invalidate();
        }
        fx.refresh(host, isDarkMode(), lensA == 0f && Float.isNaN(drag));
        fx.grayActive(host, lensA);
        boolean wantClip = lensA < 0.05f;
        if (host.getClipToOutline() != wantClip) {
            host.setClipToOutline(wantClip);
            host.invalidateOutline();
        }
    }

    private void tickSpring(float step) {
        float target = activePos();
        if (!Float.isNaN(hold)) {
            if (target == hold || SystemClock.uptimeMillis() > holdT) {
                hold = Float.NaN;
            } else {
                target = hold;
            }
        }
        if (!Float.isNaN(drag)) {
            vel = Float.isNaN(cur) ? 0f : (drag - cur);
            cur = drag;
            lens = true;
            host.invalidate();
            return;
        }
        if (Float.isNaN(target)) return;
        if (Float.isNaN(cur)) {
            cur = target;
            vel = 0f;
            lens = false;
            host.invalidate();
            return;
        }
        // Frame-rate independent lush liquid spring (smooth & deliberate at 60Hz and 120Hz)
        float damp = (float) Math.pow(0.84, step);
        float nv = vel * damp + (target - cur) * (0.026f * step);
        float np = cur + nv * step;
        if (Math.abs(target - np) < 0.002f && Math.abs(nv) < 0.002f) {
            if (target == cur && vel == 0f) {
                if (lens) {
                    lens = false;
                    host.invalidate();
                }
                return;
            }
            np = target;
            nv = 0f;
        }
        cur = np;
        vel = nv;
        lens = !Float.isNaN(hold) || Math.abs(nv) > 0.035f || Math.abs(target - np) > 0.12f;
        host.invalidate();
    }

    private static void grad(Paint p, float y0, float y1, int c0, int c1) {
        p.setShader(new LinearGradient(0f, y0, 0f, y1, c0, c1, Shader.TileMode.CLAMP));
    }

    @Override
    public void draw(Canvas canvas) {
        if (capturing) return;
        try {
            float d = host.getResources().getDisplayMetrics().density;
            boolean dark = isDarkMode();
            Rect b = getBounds();
            float w = b.width();
            float h = b.height();
            if (w <= 0 || h <= 0) return;

            barRect.set(0f, 0f, w, h);
            float r = Math.min(w, h) * 0.5f;
            if (ensureVivoGlass(r, dark)) {
                if (host.getElevation() != 0f) host.setElevation(0f);
                // Balanced translucent glass tint + crisp concentric 1dp rim
                paint.setShader(null);
                paint.clearShadowLayer();
                paint.setStyle(Paint.Style.FILL);
                paint.setColor(dark ? 0x5818191C : 0x58FFFFFF);
                canvas.drawRoundRect(barRect, r, r, paint);
                paint.setStyle(Paint.Style.STROKE);
                paint.setStrokeWidth(d);
                paint.setColor(dark ? 0x38FFFFFF : 0x78FFFFFF);
                float half = 0.5f * d;
                barRect.inset(half, half);
                float rRim = Math.max(0f, r - half);
                canvas.drawRoundRect(barRect, rRim, rRim, paint);
                paint.setStyle(Paint.Style.FILL);
                drawRestingActivePill(canvas, d, dark);
                return;
            }
            if (barPath == null) barPath = new Path();
            barPath.reset();
            barPath.addRoundRect(barRect, r, r, Path.Direction.CW);

            // Real-time iOS 26/27 Liquid Glass outer capsule: Blur + AGSL Refraction of feed behind dock
            boolean blurred = false;
            if (backdrop != null && Build.VERSION.SDK_INT >= 31 && canvas.isHardwareAccelerated()) {
                try {
                    if (barBlurNode == null) barBlurNode = new RenderNode("fbarblur");
                    int pad = (int) (32f * d);
                    int nw = (int) w + pad * 2;
                    int nh = (int) h + pad * 2;
                    if (nw > 0 && nh > 0) {
                        int[] hLoc = new int[2];
                        int[] bLoc = new int[2];
                        host.getLocationOnScreen(hLoc);
                        backdrop.getLocationOnScreen(bLoc);
                        float dx = (bLoc[0] - hLoc[0]) + pad - backdrop.getScrollX();
                        float dy = (bLoc[1] - hLoc[1]) + pad - backdrop.getScrollY();

                        barBlurNode.setPosition(0, 0, nw, nh);
                        Canvas rc = barBlurNode.beginRecording(nw, nh);
                        try {
                            rc.drawColor(dark ? 0xFF101014 : 0xFFF5F6FA);
                            rc.translate(dx, dy);
                            backdrop.draw(rc);
                        } finally {
                            barBlurNode.endRecording();
                        }

                        // True iOS 26/27 Liquid Glass: crystal-clear optical glass (4dp blur + clean edge meniscus refraction)
                        float blurR = 4.0f * d;
                        RenderEffect blurEff = RenderEffect.createBlurEffect(blurR, blurR, Shader.TileMode.CLAMP);
                        if (Build.VERSION.SDK_INT >= 33) {
                            if (barRs == null) barRs = new RuntimeShader(BAR_SHADER_SRC);
                            barRs.setFloatUniform("size", w, h);
                            barRs.setFloatUniform("radius", r);
                            barRs.setFloatUniform("pad", pad);
                            barRs.setFloatUniform("edge", Math.min(14f * d, r));
                            barRs.setFloatUniform("strength", 10f * d);
                            barRs.setFloatUniform("mag", 1.04f);
                            RenderEffect refEff = RenderEffect.createRuntimeShaderEffect(barRs, "content");
                            barBlurNode.setRenderEffect(RenderEffect.createChainEffect(refEff, blurEff));
                        } else {
                            barBlurNode.setRenderEffect(blurEff);
                        }

                        canvas.save();
                        canvas.clipPath(barPath);
                        canvas.translate(-pad, -pad);
                        canvas.drawRenderNode(barBlurNode);
                        canvas.restore();
                        blurred = true;
                    }
                } catch (Throwable ignored) {
                }
            }

            paint.setShader(null);
            paint.clearShadowLayer();
            paint.setStyle(Paint.Style.FILL);
            if (blurred) {
                paint.setColor(dark ? 0x33141418 : 0x28FFFFFF);
            } else {
                paint.setColor(dark ? 0xCC202024 : 0xCCFFFFFF);
            }
            canvas.drawRoundRect(barRect, r, r, paint);

            // Crisp liquid top glaze + subtle bottom bounce
            grad(paint, 0f, h * 0.42f, dark ? 0x26FFFFFF : 0x55FFFFFF, 0x00FFFFFF);
            canvas.drawRoundRect(barRect, r, r, paint);
            grad(paint, h * 0.78f, h, 0x00FFFFFF, dark ? 0x18FFFFFF : 0x28FFFFFF);
            canvas.drawRoundRect(barRect, r, r, paint);
            paint.setShader(null);

            // Diagonal Apple specular catchlight rim
            paint.setStyle(Paint.Style.STROKE);
            paint.setStrokeWidth(1.0f * d);
            paint.setColor(dark ? 0x33FFFFFF : 0x1F000000);
            float half = 0.5f * d;
            barRect.inset(half, half);
            canvas.drawRoundRect(barRect, r, r, paint);

            paint.setStrokeWidth(1.5f * d);
            barRect.inset(1.0f * d, 1.0f * d);
            paint.setShader(new LinearGradient(
                    0f, 0f, w * 0.4f, h,
                    dark ? new int[]{0x99FFFFFF, 0x1AFFFFFF, 0x55FFFFFF}
                         : new int[]{0xFFFFFFFF, 0x38FFFFFF, 0xCCFFFFFF},
                    new float[]{0f, 0.52f, 1f},
                    Shader.TileMode.CLAMP));
            canvas.drawRoundRect(barRect, Math.max(0f, r - d), Math.max(0f, r - d), paint);
            paint.setShader(null);
            paint.setStyle(Paint.Style.FILL);
            drawRestingActivePill(canvas, d, dark);
        } catch (Throwable ignored) {
        }
    }

    // Zalo resting pill: clear glass behind the selected icon (icons/badges stay crisp on top),
    // cross-fades into the droplet while gliding/dragging.
    private void drawRestingActivePill(Canvas canvas, float d, boolean dark) {
        if (lensA >= 0.95f) return;
        float pr = geom(d);
        if (pr < 0f) return;
        float restAlpha = 1f - lensA;
        paint.setShader(null);
        paint.clearShadowLayer();
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(dark ? 0x40FFFFFF : 0x62FFFFFF);
        paint.setAlpha((int) ((dark ? 0x40 : 0x62) * restAlpha));
        canvas.drawRoundRect(rect, pr, pr, paint);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(1.0f * d);
        paint.setColor(dark ? 0x66FFFFFF : 0xCCFFFFFF);
        paint.setAlpha((int) ((dark ? 0x66 : 0xCC) * restAlpha));
        rect.inset(0.5f * d, 0.5f * d);
        float pr2 = Math.max(0f, pr - 0.5f * d);
        canvas.drawRoundRect(rect, pr2, pr2, paint);
        paint.setStyle(Paint.Style.FILL);
        paint.setAlpha(255);
    }

    private float geom(float d) {
        int n = visCount();
        if (n <= 0 || Float.isNaN(cur)) return -1f;

        float pos = Math.max(0f, Math.min(cur, n - 1));
        int i0 = Math.max(0, Math.min((int) pos, n - 2));
        float f = pos - i0;
        View v0 = visKid(i0);
        View v1 = visKid(Math.min(i0 + 1, n - 1));
        if (v0 == null || v1 == null) return -1f;

        float c0 = centerAxis(v0);
        float c1 = centerAxis(v1);
        float center = c0 + (c1 - c0) * f;
        float s0 = sizeAxis(v0);
        float s1 = sizeAxis(v1);
        float cell = s0 + (s1 - s0) * f;

        float w = getBounds().width();
        float h = getBounds().height();
        float pad = 4f * d;
        float stretch = 1f + Math.min(Math.abs(vel) * 6f, 0.22f);

        if (isVertical()) {
            float restW = w - 2f * pad;
            float restH = Math.max(restW, cell - 2f * pad);
            float lensW = restW + 16f * d;
            float lensH = Math.max(lensW * 1.22f, cell * 1.50f) * stretch;
            float pillW = restW + (lensW - restW) * lensA;
            float pillH = restH + (lensH - restH) * lensA;
            float left = (w - pillW) * 0.5f;
            float top = center - pillH * 0.5f;
            float bot = center + pillH * 0.5f;
            if (lensA < 0.05f) {
                if (top < pad) { top = pad; bot = Math.min(h - pad, top + pillH); }
                else if (bot > h - pad) { bot = h - pad; top = Math.max(pad, bot - pillH); }
            }
            rect.set(left, top, left + pillW, bot);
            return Math.min(pillW, bot - top) * 0.5f;
        } else {
            float restH = h - 2f * pad;
            float restW = Math.max(restH, cell);
            float lensH = restH + 16f * d;
            float lensW = Math.max(lensH * 1.22f, cell * 1.45f) * stretch;
            float pillH = restH + (lensH - restH) * lensA;
            float pillW = restW + (lensW - restW) * lensA;
            float top = (h - pillH) * 0.5f;
            float left = center - pillW * 0.5f;
            float right = center + pillW * 0.5f;
            if (lensA < 0.05f) {
                if (left < pad) { left = pad; right = Math.min(w - pad, left + pillW); }
                else if (right > w - pad) { right = w - pad; left = Math.max(pad, right - pillW); }
            }
            rect.set(left, top, right, top + pillH);
            return Math.min(right - left, pillH) * 0.5f;
        }
    }

    void fore(Canvas canvas) {
        if (capturing) return;
        try {
            // Rest: pill is drawn in draw() behind the icons. Here only the Zalo-style droplet while moving.
            if (lensA <= 0.02f) return;
            float d = host.getResources().getDisplayMetrics().density;
            boolean dark = isDarkMode();
            float r = geom(d);
            if (r < 0f) return;

            if (!refract(canvas, rect, r, dark)) {
                if (path == null) path = new Path();
                path.reset();
                path.addRoundRect(rect, r, r, Path.Direction.CW);
                canvas.save();
                canvas.clipPath(path);
                paint.setShader(null);
                paint.setStyle(Paint.Style.FILL);
                paint.setColor(dark ? 0xD4222228 : 0xE6F8FAFF);
                paint.setAlpha((int) ((dark ? 0xD4 : 0xE6) * lensA));
                canvas.drawRoundRect(rect, r, r, paint);
                float sc = 1f + 0.12f * lensA;
                canvas.scale(sc, sc, rect.centerX(), rect.centerY());
                capturing = true;
                try { host.draw(canvas); } finally { capturing = false; }
                canvas.restore();
            }

            paint.setStyle(Paint.Style.STROKE);
            paint.setStrokeWidth(1.1f * d);
            paint.setShader(new LinearGradient(
                    rect.left, rect.top, rect.left + rect.width() * 0.4f, rect.bottom,
                    dark ? new int[]{0xAAFFFFFF, 0x20FFFFFF, 0x60FFFFFF}
                         : new int[]{0xFFFFFFFF, 0x40FFFFFF, 0xBBFFFFFF},
                    new float[]{0f, 0.5f, 1f},
                    Shader.TileMode.CLAMP));
            paint.setAlpha((int) (255 * lensA));
            float inset = 0.55f * d;
            rect.inset(inset, inset);
            float rStroke = Math.max(0f, r - inset);
            canvas.drawRoundRect(rect, rStroke, rStroke, paint);
            paint.setShader(null);
            paint.setStyle(Paint.Style.FILL);
            paint.setAlpha(255);
        } catch (Throwable ignored) {
        }
    }

    private static final int[] STATE_SELECTED = new int[]{android.R.attr.state_activated, android.R.attr.state_selected, android.R.attr.state_checked, android.R.attr.state_enabled};

    private static void forceSelected(View v, java.util.ArrayList<Object[]> saved) {
        if (v instanceof android.widget.ImageView) {
            Drawable dr = ((android.widget.ImageView) v).getDrawable();
            if (dr != null && dr.isStateful()) {
                int[] prev = dr.getState();
                saved.add(new Object[]{dr, dr.getCallback(), prev != null ? prev.clone() : new int[0]});
                dr.setCallback(null);
                dr.setState(STATE_SELECTED);
            }
        } else if (v instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) v;
            for (int i = 0; i < vg.getChildCount(); i++) forceSelected(vg.getChildAt(i), saved);
        }
    }

    private static void restoreSelected(java.util.ArrayList<Object[]> saved) {
        for (int i = saved.size() - 1; i >= 0; i--) {
            Object[] o = saved.get(i);
            Drawable dr = (Drawable) o[0];
            dr.setState((int[]) o[2]);
            dr.setCallback((Drawable.Callback) o[1]);
        }
    }

    private boolean refract(Canvas canvas, RectF box, float radius, boolean dark) {
        try {
            if (!canvas.isHardwareAccelerated() || Build.VERSION.SDK_INT < 33) return false;
            if (node == null) node = new RenderNode("flens");
            if (rs == null) rs = new RuntimeShader(SHADER_SRC);

            float d = host.getResources().getDisplayMetrics().density;
            float fx = lensA * lensA;
            float pad = 12f * d;
            float bw = box.width();
            float bh = box.height();
            int nw = (int) (bw + 2f * pad);
            int nh = (int) (bh + 2f * pad);
            if (nw <= 0 || nh <= 0) return false;

            java.util.ArrayList<Object[]> saved = new java.util.ArrayList<>();
            node.setPosition(0, 0, nw, nh);
            Canvas rc = node.beginRecording(nw, nh);
            try {
                forceSelected(host, saved);
                rc.translate(pad - box.left, pad - box.top);
                capturing = true;
                try { this.fx.drawSelected(host, rc); } finally { capturing = false; }
            } finally {
                restoreSelected(saved);
                node.endRecording();
            }

            float dm = dark ? 1f : 0f;
            rs.setFloatUniform("size", bw, bh);
            rs.setFloatUniform("radius", radius);
            rs.setFloatUniform("pad", pad);
            rs.setFloatUniform("edge", Math.min(13f * d, radius));
            rs.setFloatUniform("strength", 13f * d * fx);
            rs.setFloatUniform("mag", 1f + 0.10f * fx);
            float bgR = 0.97f * (1f - dm) + 0.21f * dm;
            float bgG = 0.98f * (1f - dm) + 0.21f * dm;
            float bgB = 1.00f * (1f - dm) + 0.24f * dm;
            float bgA = (0.90f * (1f - dm) + 0.90f * dm) * lensA;
            rs.setFloatUniform("tintBg", bgR, bgG, bgB, bgA);
            // Facebook blue #0866FF (brighter in dark mode)
            rs.setFloatUniform("selColor", 0.03f + 0.24f * dm, 0.40f + 0.18f * dm, 1.0f, 1.0f);

            node.setRenderEffect(RenderEffect.createRuntimeShaderEffect(rs, "content"));
            canvas.save();
            canvas.translate(box.left - pad, box.top - pad);
            canvas.drawRenderNode(node);
            canvas.restore();
            return true;
        } catch (Throwable ignored) {
            capturing = false;
            return false;
        }
    }
}

final class FFore extends Drawable {
    final FGlass g;
    FFore(FGlass g) { this.g = g; }
    @Override public void draw(Canvas canvas) { g.fore(canvas); }
    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    @Override public void setAlpha(int alpha) {}
    @Override public void setColorFilter(ColorFilter cf) {}
}

final class FDrag implements View.OnTouchListener {
    private final FGlass g;
    private float downAxis;
    private boolean dragging;

    FDrag(FGlass g) { this.g = g; }

    @Override
    public boolean onTouch(View v, MotionEvent ev) {
        try {
            LinearLayout host = g.host;
            boolean vert = g.isVertical();
            int act = ev.getActionMasked();
            float raw = vert ? ev.getRawY() : ev.getRawX();
            int[] loc = new int[2];
            host.getLocationOnScreen(loc);
            float local = raw - (vert ? loc[1] : loc[0]);

            if (act == MotionEvent.ACTION_DOWN) {
                downAxis = raw;
                dragging = false;
                return false;
            }
            if (act == MotionEvent.ACTION_MOVE) {
                if (!dragging) {
                    float slop = 10f * host.getResources().getDisplayMetrics().density;
                    if (Math.abs(raw - downAxis) <= slop) return false;
                    dragging = true;
                    ViewParent p = host.getParent();
                    if (p != null) p.requestDisallowInterceptTouchEvent(true);
                    MotionEvent cancel = MotionEvent.obtain(ev);
                    cancel.setAction(MotionEvent.ACTION_CANCEL);
                    v.onTouchEvent(cancel);
                    cancel.recycle();
                    v.setPressed(false);
                }
                g.drag = g.posFromCoord(local);
                host.invalidate();
                return true;
            }
            if (dragging) {
                dragging = false;
                float last = g.drag;
                g.drag = Float.NaN;
                if (act == MotionEvent.ACTION_UP) {
                    int idx = Math.round(last);
                    g.hold = idx;
                    g.holdT = SystemClock.uptimeMillis() + 700L;
                    int curIdx = Math.round(g.activePos());
                    if (curIdx != idx) {
                        View target = g.visKid(idx);
                        if (target != null) target.performClick();
                    }
                }
                host.invalidate();
                return true;
            }
        } catch (Throwable ignored) {
        }
        return false;
    }
}
