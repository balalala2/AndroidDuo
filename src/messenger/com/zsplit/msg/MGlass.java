package com.zsplit.msg;

import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.LinearGradient;
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
import android.os.Build;
import android.os.SystemClock;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;

final class MGlass {
    private static final float CONTENT_SCALE = 0.88f;

    // AGSL Liquid Glass refraction + chromatic dispersion shader (used on both outer capsule & active lens)
    private static final String SHADER_SRC =
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
            " half4 gg=content.eval(base+n*o*1.18);\n" +
            " half4 b=content.eval(base+n*o*1.36);\n" +
            " return half4(r.r,gg.g,b.b,gg.a);\n" +
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

    final View host;
    final ViewGroup tabGroup;
    ViewGroup backdrop;
    float cur = Float.NaN;
    float drag = Float.NaN;
    float vel = 0f;
    float hold = Float.NaN;
    long holdT = 0L;
    boolean lens = false;
    float lensA = 0f;
    boolean capturing = false;
    private long lastTickMs = 0L;

    final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    final RectF rect = new RectF();
    final RectF barRect = new RectF();
    Path path;
    Path barPath;
    RenderNode node;
    RenderNode barBlurNode;
    RuntimeShader rs;
    RuntimeShader barRs;
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
            android.util.Log.i("MGlass", "Vivo native glass unavailable: " + t);
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
                android.util.Log.i("MGlass", "Vivo native Liquid Glass ENABLED style=" + wantStyle + " r=" + r);
                return true;
            } else {
                android.util.Log.i("MGlass", "Vivo setMaterial returned false for style=" + wantStyle);
            }
        } catch (Throwable t) {
            android.util.Log.i("MGlass", "Vivo setMaterial error: " + t);
            sSetMaterial = null;
        }
        vivoActive = false;
        return false;
    }

    MGlass(View host, ViewGroup tabGroup) {
        this.host = host;
        this.tabGroup = tabGroup;
    }

    ViewGroup tabs() {
        return tabGroup != null ? tabGroup : ((host instanceof ViewGroup) ? (ViewGroup) host : null);
    }

    static int count(ViewGroup vg) {
        int c = 0;
        for (int i = 0; i < vg.getChildCount(); i++) {
            if (vg.getChildAt(i).getVisibility() == View.VISIBLE) c++;
        }
        return c;
    }

    static View kid(ViewGroup vg, int idx) {
        int c = 0;
        for (int i = 0; i < vg.getChildCount(); i++) {
            View v = vg.getChildAt(i);
            if (v.getVisibility() == View.VISIBLE) {
                if (c == idx) return v;
                c++;
            }
        }
        return null;
    }

    float scaledCx(View v) {
        float hw = host.getWidth() * 0.5f;
        float rawCx = v.getLeft() + v.getWidth() * 0.5f;
        return hw + (rawCx - hw) * CONTENT_SCALE;
    }

    float posFromX(float x) {
        ViewGroup vg = tabs();
        if (vg == null) return 0f;
        int n = count(vg);
        for (int i = 0; i < n - 1; i++) {
            View a = kid(vg, i);
            View b = kid(vg, i + 1);
            if (a == null || b == null) continue;
            float ax = scaledCx(a);
            float bx = scaledCx(b);
            if (x <= bx) {
                float t = (bx != ax) ? (x - ax) / (bx - ax) : 0f;
                if (t < 0f) t = 0f;
                return i + t;
            }
        }
        return Math.max(0, n - 1);
    }

    float activePos() {
        ViewGroup vg = tabs();
        if (vg == null) return Float.NaN;
        int n = count(vg);
        for (int i = 0; i < n; i++) {
            View v = kid(vg, i);
            if (v != null && v.isSelected()) return (float) i;
        }
        return Float.NaN;
    }

    void tick() {
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
        // Frame-rate independent lush liquid spring (smooth at 60Hz & 120Hz)
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
        // Swell slightly during fast tab transitions (tap or drag release) like iOS Liquid Glass
        lens = !Float.isNaN(hold) || Math.abs(nv) > 0.035f || Math.abs(target - np) > 0.12f;
        host.invalidate();
    }

    private void drawOuterGlassPill(Canvas canvas, float w, float h, boolean dark, float d) {
        barRect.set(0f, 0f, w, h);
        float r = h * 0.5f;
        if (ensureVivoGlass(r, dark)) {
            return;
        }
        if (barPath == null) barPath = new Path();
        barPath.reset();
        barPath.addRoundRect(barRect, r, r, Path.Direction.CW);

        // True Liquid Glass optical backdrop: soft blur + subtle curved-edge refraction!
        boolean blurred = false;
        if (backdrop != null && Build.VERSION.SDK_INT >= 31 && canvas.isHardwareAccelerated()) {
            try {
                if (barBlurNode == null) barBlurNode = new RenderNode("mbarblur");
                int pad = (int) (32f * d);
                int nw = (int) w + pad * 2;
                int nh = (int) h + pad * 2;
                if (nw > 0 && nh > 0) {
                    int[] hLoc = new int[2];
                    int[] bLoc = new int[2];
                    host.getLocationOnScreen(hLoc);
                    backdrop.getLocationOnScreen(bLoc);
                    float dx = (bLoc[0] - hLoc[0]) + pad;
                    float dy = (bLoc[1] - hLoc[1]) + pad;

                    barBlurNode.setPosition(0, 0, nw, nh);
                    Canvas rc = barBlurNode.beginRecording(nw, nh);
                    try {
                        rc.drawColor(dark ? 0xFF101014 : 0xFFF5F6FA);
                        rc.translate(dx, dy);
                        int cnt = backdrop.getChildCount();
                        for (int i = 0; i < cnt; i++) {
                            View sib = backdrop.getChildAt(i);
                            if (sib.getVisibility() != View.VISIBLE) continue;
                            if (Integer.valueOf(MDock.TAG_SCRIM_ID).equals(sib.getTag())) continue;
                            rc.save();
                            rc.translate(sib.getLeft(), sib.getTop());
                            sib.draw(rc);
                            rc.restore();
                        }
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
                        RenderEffect refractEff = RenderEffect.createRuntimeShaderEffect(barRs, "content");
                        barBlurNode.setRenderEffect(RenderEffect.createChainEffect(refractEff, blurEff));
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
            // Crystal-clear Liquid Glass glaze (16% tint, NOT milky frosted)
            paint.setColor(dark ? 0x33141418 : 0x28FFFFFF);
        } else {
            paint.setColor(dark ? 0xCC1E1E24 : 0xCCFFFFFF);
        }
        canvas.drawRoundRect(barRect, r, r, paint);

        // Crisp liquid top glaze + subtle bottom bounce
        grad(paint, 0f, h * 0.42f, dark ? 0x26FFFFFF : 0x55FFFFFF, 0x00FFFFFF);
        canvas.drawRoundRect(barRect, r, r, paint);

        grad(paint, h * 0.78f, h, 0x00FFFFFF, dark ? 0x18FFFFFF : 0x28FFFFFF);
        canvas.drawRoundRect(barRect, r, r, paint);
        paint.setShader(null);

        // Signature iOS 26/27 diagonal specular catchlight rim (bright top-left & bottom-right)
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(1.0f * d);
        paint.setColor(dark ? 0x33FFFFFF : 0x1F000000);
        float half = 0.5f * d;
        barRect.inset(half, half);
        canvas.drawRoundRect(barRect, r, r, paint);

        paint.setStrokeWidth(1.5f * d);
        barRect.inset(1.0f * d, 1.0f * d);
        paint.setShader(new LinearGradient(
                0f, 0f, w * 0.35f, h,
                dark ? new int[]{0x99FFFFFF, 0x1AFFFFFF, 0x55FFFFFF}
                     : new int[]{0xFFFFFFFF, 0x38FFFFFF, 0xCCFFFFFF},
                new float[]{0f, 0.52f, 1f},
                Shader.TileMode.CLAMP));
        canvas.drawRoundRect(barRect, r - d, r - d, paint);
        paint.setShader(null);
        paint.setStyle(Paint.Style.FILL);
    }

    private void drawScaledTabs(Canvas canvas, float w, float h) {
        capturing = true;
        try {
            host.draw(canvas);
        } finally {
            capturing = false;
        }
    }

    private float geom(float w, float h, float d) {
        ViewGroup vg = tabs();
        if (vg == null) return -1f;
        int n = count(vg);
        if (n <= 0 || Float.isNaN(cur)) return -1f;

        float pos = Math.max(0f, Math.min(cur, n - 1));
        int i0 = Math.max(0, Math.min((int) pos, n - 2));
        float f = pos - i0;
        View v0 = kid(vg, i0);
        View v1 = kid(vg, Math.min(i0 + 1, n - 1));
        if (v0 == null || v1 == null) return -1f;

        float c0 = scaledCx(v0);
        float c1 = scaledCx(v1);
        float centerX = c0 + (c1 - c0) * f;
        float w0 = v0.getWidth() * CONTENT_SCALE;
        float w1 = v1.getWidth() * CONTENT_SCALE;
        float cellW = w0 + (w1 - w0) * f;

        float stretch = 1f + Math.min(Math.abs(vel) * 6f, 0.22f);
        // True 4dp concentric full-capsule pill wrapping the uniformly 0.88x-scaled icon + label with generous breathing room!
        float pad = 4f * d;
        float restW = cellW + 10f * d;
        float lensW = cellW * 1.44f * stretch;
        float pillW = restW + (lensW - restW) * lensA;

        float insetY = (2f * pad) - 18f * d * lensA;
        float pillH = h - insetY;
        float top = (h - pillH) * 0.5f;
        float halfW = pillW * 0.5f;

        float left = centerX - halfW;
        float right = centerX + halfW;
        if (lensA < 0.05f) {
            if (left < pad) {
                left = pad;
                right = Math.min(w - pad, left + pillW);
            } else if (right > w - pad) {
                right = w - pad;
                left = Math.max(pad, right - pillW);
            }
        }
        rect.set(left, top, right, top + pillH);
        return pillH * 0.5f;
    }

    private static void grad(Paint p, float y0, float y1, int c0, int c1) {
        p.setShader(new LinearGradient(0f, y0, 0f, y1, c0, c1, Shader.TileMode.CLAMP));
    }

    void back(Canvas canvas, Rect bounds) {
        if (capturing) return;
        try {
            float w = bounds.width();
            float h = bounds.height();
            if (w <= 0 || h <= 0) return;
            float d = host.getResources().getDisplayMetrics().density;
            boolean dark = MSplit.isDark(host);

            // 1. Native OriginOS Liquid Glass outer capsule (or AGSL fallback on non-vivo)
            drawOuterGlassPill(canvas, w, h, dark, d);

            // 2. Resting active pill drawn BEHIND tab icons & red badges so blue selection + red badges stay 100% vivid!
            if (lensA < 0.95f) {
                float r = geom(w, h, d);
                if (r >= 0f) {
                    if (path == null) path = new Path();
                    path.reset();
                    path.addRoundRect(rect, r, r, Path.Direction.CW);
                    float restAlpha = 1f - lensA;

                    paint.setShader(null);
                    paint.setStyle(Paint.Style.FILL);
                    canvas.save();
                    canvas.clipOutPath(path);
                    paint.setColor(dark ? 0xFF202026 : 0xFFFFFFFF);
                    paint.setAlpha(255);
                    paint.setShadowLayer(6f * d, 0f, 1.5f * d, ((int) (18f * restAlpha)) << 24);
                    canvas.drawRoundRect(rect, r, r, paint);
                    paint.clearShadowLayer();
                    canvas.restore();

                    paint.setColor(dark ? 0x2EFFFFFF : 0x62FFFFFF);
                    paint.setAlpha((int) ((dark ? 0x2E : 0x62) * restAlpha));
                    canvas.drawRoundRect(rect, r, r, paint);

                    paint.setStyle(Paint.Style.STROKE);
                    paint.setStrokeWidth(1.0f * d);
                    paint.setColor(dark ? 0x44FFFFFF : 0xCCFFFFFF);
                    paint.setAlpha((int) ((dark ? 0x44 : 0xCC) * restAlpha));
                    rect.inset(0.5f * d, 0.5f * d);
                    canvas.drawRoundRect(rect, Math.max(0f, r - 0.5f * d), Math.max(0f, r - 0.5f * d), paint);
                    paint.setStyle(Paint.Style.FILL);
                    paint.setAlpha(255);
                }
            }
        } catch (Throwable ignored) {
        }
    }

    void fore(Canvas canvas, Rect bounds) {
        if (capturing) return;
        try {
            // At rest, MBack already drew both the outer glass capsule & active pill BEHIND icons/badges.
            // MFore ONLY draws the magnifying liquid lens while actively dragging or gliding!
            if (lensA < 0.03f) return;
            float w = bounds.width();
            float h = bounds.height();
            if (w <= 0 || h <= 0) return;
            float d = host.getResources().getDisplayMetrics().density;
            boolean dark = MSplit.isDark(host);

            // Active magnifying liquid lens during drag/glide
            float r = geom(w, h, d);
            if (r < 0f) return;

            if (path == null) path = new Path();
            path.reset();
            path.addRoundRect(rect, r, r, Path.Direction.CW);

            paint.setShader(null);
            paint.setStyle(Paint.Style.FILL);

            // Outer diffused glass shadow (clipped outside the pill)
            canvas.save();
            canvas.clipOutPath(path);
            paint.setColor(dark ? 0xFF202026 : 0xFFFFFFFF);
            paint.setAlpha(255);
            int shadowA = (int) (14f + 38f * lensA);
            paint.setShadowLayer((8f + 6f * lensA) * d, 0f, (1.5f + 2f * lensA) * d, shadowA << 24);
            canvas.drawRoundRect(rect, r, r, paint);
            paint.clearShadowLayer();
            canvas.restore();

            // Interior of active Liquid Glass pill
            canvas.saveLayerAlpha(rect, 255);
            canvas.clipPath(path);

            // When resting (lensA ~ 0), stay translucent over the frosted capsule so it feels like pure glass!
            // When dragging/gliding (lensA > 0), run full AGSL optical refraction + chromatic dispersion!
            if (lensA > 0.03f) {
                int lensBg = dark ? 0xD8222228 : 0xD8F8F9FC;
                if (!refract(canvas, rect, r, lensBg, w, h)) {
                    canvas.save();
                    float sc = 1f + 0.14f * lensA;
                    canvas.scale(sc, sc, rect.centerX(), rect.centerY());
                    drawScaledTabs(canvas, w, h);
                    canvas.restore();
                }
            }

            // Luminous translucent glass fill (subtle tinted crystal pill like iOS 26/27)
            paint.setColor(dark ? 0x2EFFFFFF : 0x45FFFFFF);
            canvas.drawRoundRect(rect, r, r, paint);

            // Top specular dome sheen
            grad(paint, rect.top, rect.centerY(),
                    dark ? 0x2CFFFFFF : 0x80FFFFFF,
                    0x00FFFFFF);
            canvas.drawRoundRect(rect, r, r, paint);
            paint.setShader(null);

            // Outer subtle edge + bright diagonal iOS specular rim
            paint.setStyle(Paint.Style.STROKE);
            paint.setStrokeWidth(0.85f * d);
            paint.setColor(dark ? 0x38FFFFFF : 0x1A000000);
            canvas.drawRoundRect(rect, r, r, paint);

            float rim = 1.4f * d;
            paint.setStrokeWidth(rim);
            rect.inset(rim, rim);
            float r2 = Math.max(0f, r - rim);
            paint.setShader(new LinearGradient(
                    rect.left, rect.top, rect.left + rect.width() * 0.4f, rect.bottom,
                    dark ? new int[]{0x99FFFFFF, 0x1AFFFFFF, 0x44FFFFFF}
                         : new int[]{0xFFFFFFFF, 0x33FFFFFF, 0xB8FFFFFF},
                    new float[]{0f, 0.5f, 1f},
                    Shader.TileMode.CLAMP));
            canvas.drawRoundRect(rect, r2, r2, paint);

            paint.setShader(null);
            paint.setStyle(Paint.Style.FILL);
            paint.setAlpha(255);
            canvas.restore();
        } catch (Throwable ignored) {
        }
    }

    private boolean refract(Canvas canvas, RectF box, float radius, int bgColor, float w, float h) {
        try {
            if (!canvas.isHardwareAccelerated() || Build.VERSION.SDK_INT < 33) return false;
            if (node == null) node = new RenderNode("mlens");
            if (rs == null) rs = new RuntimeShader(SHADER_SRC);

            float d = host.getResources().getDisplayMetrics().density;
            float pad = 24f * d;
            float bw = box.width();
            float bh = box.height();
            int nw = (int) (bw + 2f * pad);
            int nh = (int) (bh + 2f * pad);
            if (nw <= 0 || nh <= 0) return false;

            node.setPosition(0, 0, nw, nh);
            Canvas rc = node.beginRecording(nw, nh);
            try {
                rc.drawColor(bgColor);
                rc.translate(pad - box.left, pad - box.top);
                drawScaledTabs(rc, w, h);
            } finally {
                node.endRecording();
            }

            rs.setFloatUniform("size", bw, bh);
            rs.setFloatUniform("radius", radius);
            rs.setFloatUniform("pad", pad);
            rs.setFloatUniform("edge", Math.min((8f + 12f * lensA) * d, radius));
            rs.setFloatUniform("strength", (2f + 14f * lensA) * d);
            rs.setFloatUniform("mag", 1f + 0.12f * lensA);

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

final class MFore extends Drawable {
    final MGlass g;

    MFore(MGlass g) {
        this.g = g;
    }

    @Override public void draw(Canvas canvas) { g.fore(canvas, getBounds()); }
    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    @Override public void setAlpha(int alpha) {}
    @Override public void setColorFilter(ColorFilter cf) {}
}

final class MDrag implements View.OnTouchListener {
    private final MGlass g;
    private float downX;
    private boolean dragging;

    MDrag(MGlass g) {
        this.g = g;
    }

    @Override
    public boolean onTouch(View v, MotionEvent ev) {
        try {
            View host = g.host;
            int act = ev.getActionMasked();
            float rawX = ev.getRawX();
            int[] loc = new int[2];
            host.getLocationOnScreen(loc);
            float localX = rawX - loc[0];

            if (act == MotionEvent.ACTION_DOWN) {
                downX = rawX;
                dragging = false;
                return false;
            }
            if (act == MotionEvent.ACTION_MOVE) {
                if (!dragging) {
                    float slop = 10f * host.getResources().getDisplayMetrics().density;
                    if (Math.abs(rawX - downX) <= slop) return false;
                    dragging = true;
                    ViewParent p = host.getParent();
                    if (p != null) p.requestDisallowInterceptTouchEvent(true);
                    MotionEvent cancel = MotionEvent.obtain(ev);
                    cancel.setAction(MotionEvent.ACTION_CANCEL);
                    v.onTouchEvent(cancel);
                    cancel.recycle();
                    v.setPressed(false);
                }
                g.drag = g.posFromX(localX);
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
                        ViewGroup vg = g.tabs();
                        if (vg != null) {
                            View target = MGlass.kid(vg, idx);
                            if (target != null) target.performClick();
                        }
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

final class MBack extends Drawable {
    final MGlass g;

    MBack(MGlass g) {
        this.g = g;
    }

    @Override
    public void draw(Canvas canvas) {
        g.back(canvas, getBounds());
    }

    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    @Override public void setAlpha(int alpha) {}
    @Override public void setColorFilter(ColorFilter cf) {}
}
