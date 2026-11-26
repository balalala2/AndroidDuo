package com.zsplit.yt;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.LinearGradient;
import android.graphics.Outline;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.RenderEffect;
import android.graphics.RenderNode;
import android.graphics.RuntimeShader;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.RippleDrawable;
import android.graphics.drawable.StateListDrawable;
import android.os.Build;
import android.os.SystemClock;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.view.ViewParent;
import android.view.ViewTreeObserver;
import android.view.WindowInsets;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.lang.reflect.Method;
import java.util.ArrayList;

public final class YGlass {
    private static final int TAG_ATTACHED = 0x795f0101;
    private static final int TAG_CTRL = 0x795f0102;

    private static boolean sVivoProbed;
    private static Method sSetMaterial;
    private static Method sSetCornerRadius;
    private static Method sSetForceUpdateBg;
    private static Method sSetDamageHwLayer;
    private static volatile int sLastWidthDp = 0;

    public static int getDynamicFormFactor(int original) {
        int w = sLastWidthDp;
        if (w <= 0) {
            try {
                // Read live Application Configuration.screenWidthDp (Resources.getSystem() returns cover screen on foldables!)
                Class<?> at = Class.forName("android.app.ActivityThread");
                Object app = at.getMethod("currentApplication").invoke(null);
                if (app instanceof Context) {
                    Configuration cfg = ((Context) app).getResources().getConfiguration();
                    if (cfg != null && cfg.screenWidthDp > 0) {
                        w = cfg.screenWidthDp;
                    }
                }
            } catch (Throwable ignored) {}
        }
        int ret = (w >= 580) ? 2 : ((w > 0) ? 1 : original);
        android.util.Log.i("YGlass", "getDynamicFormFactor orig=" + original + " wDp=" + w + " -> " + ret);
        return ret;
    }

    // AGSL Liquid Glass droplet shader:
    // - Strictly clipped inside SDF (d <= 0.5) -> zero gray box
    // - Solid vivid YouTube Red on ALL monochrome icons & text inside droplet
    // - Excludes Tab 5's circular user avatar (avatarBox) so avatar stays 100% pure original color while "Bạn" text turns red!
    private static final String SHADER_SRC =
            "uniform shader content;\n" +
            "uniform float2 size;\n" +
            "uniform float radius;\n" +
            "uniform float edge;\n" +
            "uniform float strength;\n" +
            "uniform float mag;\n" +
            "uniform float pad;\n" +
            "uniform float4 avatarBox;\n" +
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
            " float inAvatar=step(avatarBox.x,base.x)*step(base.x,avatarBox.z)*step(avatarBox.y,base.y)*step(base.y,avatarBox.w);\n" +
            " float sat=max(fg.r,max(fg.g,fg.b))-min(fg.r,min(fg.g,fg.b));\n" +
            " float mono=clamp(1.0-sat*3.0,0.0,1.0)*(1.0-inAvatar);\n" +
            " half3 selRgb=mix(fg.rgb, half3(selColor.rgb)*fg.a, half(mono*0.98));\n" +
            " half3 prism=half3(r.a-gg.a, 0.0, b.a-gg.a)*half(k*0.75);\n" +
            " half3 outRgb=clamp(selRgb + prism, half3(0.0), half3(1.0)) + half3(tintBg.rgb)*(1.0-fg.a);\n" +
            " half outA=max(fg.a, half(tintBg.a));\n" +
            " return half4(outRgb, outA)*aa;\n" +
            "}";

    private static void probeVivo() {
        if (sVivoProbed) return;
        sVivoProbed = true;
        try {
            sSetMaterial = View.class.getMethod("setMaterial", int.class, int.class);
            sSetCornerRadius = View.class.getMethod("setMaterialCornerRadius", float.class);
            try { sSetForceUpdateBg = View.class.getMethod("setMaterialForceUpdateBg", boolean.class); } catch (Throwable ignored) {}
            try { sSetDamageHwLayer = View.class.getMethod("setMaterialDamageHardwareLayer", boolean.class); } catch (Throwable ignored) {}
        } catch (Throwable ignored) {
            sSetMaterial = null;
        }
    }

    public static void attach(final View pivotBar) {
        if (pivotBar == null) return;
        if (pivotBar.getTag(TAG_ATTACHED) != null) return;
        pivotBar.setTag(TAG_ATTACHED, Boolean.TRUE);

        final GlassController ctrl = new GlassController(pivotBar);
        pivotBar.setTag(TAG_CTRL, ctrl);
        pivotBar.setBackground(ctrl.backDrawable);
        pivotBar.setForeground(ctrl.foreDrawable);
        pivotBar.setOutlineProvider(new ViewOutlineProvider() {
            @Override
            public void getOutline(View v, Outline outline) {
                int w = v.getWidth(), h = v.getHeight();
                if (w > 0 && h > 0) outline.setRoundRect(0, 0, w, h, h * 0.5f);
            }
        });
        pivotBar.setClipToOutline(true);

        pivotBar.getViewTreeObserver().addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
            @Override
            public boolean onPreDraw() {
                return ctrl.tick();
            }
        });
        pivotBar.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int l, int t, int r, int b, int ol, int ot, int or, int ob) {
                ctrl.enforceGeometry();
            }
        });
    }

    public static boolean onTouch(View pivotBar, MotionEvent e) {
        if (pivotBar == null || e == null) return false;
        Object o = pivotBar.getTag(TAG_CTRL);
        if (!(o instanceof GlassController)) return false;
        return ((GlassController) o).handleTouch(e);
    }

    private static final class GlassController {
        // YouTube's tab icons are StateListDrawables keyed on state_activated (0x10102fe) for the filled icon
        private static final int[] STATE_SELECTED = new int[]{android.R.attr.state_activated, android.R.attr.state_selected, android.R.attr.state_checked, android.R.attr.state_enabled};

        final View host;
        final YBack backDrawable;
        final YFore foreDrawable;
        final TabFx fx = new TabFx();
        final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        final RectF rect = new RectF();
        float cur = Float.NaN;
        float drag = Float.NaN;
        float vel = 0f;
        float hold = Float.NaN;
        long holdT = 0L;
        boolean lens = false;
        float lensA = 0f;
        float darkMix = -1f;
        float shortsDropMix = 0f;
        long lastTickMs = 0L;
        long lastStyleMs = 0L;
        boolean vivoActive = false;
        int vivoStyle = -1;
        float vivoRadius = -1f;
        RenderNode node;
        RuntimeShader rs;
        int cancelStreak = 0;
        int lastWideState = -1;
        private static long sLastRecreateMs = 0L;

        // Smooth tab-to-tab horizontal page carousel transition (snapshot-based, sweeps through intermediate tabs)
        final Bitmap[] snapshots = new Bitmap[6];
        int lastSelIdx = -1;
        long settleTimeMs = 0L;
        boolean snapshotCapturedForCurrent = false;
        PageStripOverlay pageOverlay;

        GlassController(View host) {
            this.host = host;
            this.backDrawable = new YBack(this);
            this.foreDrawable = new YFore(this);
        }

        boolean isShortsSelected() {
            ViewGroup tabs = tabs();
            if (tabs == null) return false;
            int n = count(tabs);
            for (int i = 0; i < n; i++) {
                View k = kid(tabs, i);
                if (k != null && k.isSelected() && isShortsTab(k)) {
                    return true;
                }
            }
            return false;
        }

        boolean isDarkMode() {
            // YouTube's own theme (Settings > Appearance), not just the system night flag
            return TabFx.themeDark(host) || isShortsSelected();
        }

        private static boolean isShortsTab(View v) {
            CharSequence cd = v.getContentDescription();
            if (cd != null && cd.toString().toLowerCase().contains("shorts")) return true;
            if (v instanceof TextView) {
                CharSequence t = ((TextView) v).getText();
                if (t != null && t.toString().toLowerCase().contains("shorts")) return true;
            }
            if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    if (isShortsTab(vg.getChildAt(i))) return true;
                }
            }
            return false;
        }

        ViewGroup tabs() {
            if (!(host instanceof ViewGroup)) return null;
            ViewGroup vg = (ViewGroup) host;
            for (int i = 0; i < vg.getChildCount(); i++) {
                View c = vg.getChildAt(i);
                if (c instanceof LinearLayout && ((ViewGroup) c).getChildCount() >= 2) {
                    return (ViewGroup) c;
                }
            }
            return null;
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

        static float cx(ViewGroup vg, View v) {
            return vg.getLeft() + v.getLeft() + v.getWidth() * 0.5f;
        }

        float selectedPos() {
            ViewGroup vg = tabs();
            if (vg == null) return Float.NaN;
            int n = count(vg);
            for (int i = 0; i < n; i++) {
                View k = kid(vg, i);
                if (k != null && k.isSelected()) return (float) i;
            }
            return Float.NaN;
        }

        float posFromX(float x) {
            ViewGroup vg = tabs();
            if (vg == null) return 0f;
            int n = count(vg);
            for (int i = 0; i < n - 1; i++) {
                View a = kid(vg, i);
                View b = kid(vg, i + 1);
                if (a == null || b == null) continue;
                float ax = cx(vg, a);
                float bx = cx(vg, b);
                if (x <= bx) {
                    float t = (bx != ax) ? (x - ax) / (bx - ax) : 0f;
                    if (t < 0f) t = 0f;
                    return i + t;
                }
            }
            return Math.max(0, n - 1);
        }

        float downX;
        boolean dragging;

        boolean handleTouch(MotionEvent e) {
            int act = e.getActionMasked();
            float rawX = e.getRawX();
            int[] loc = new int[2];
            host.getLocationOnScreen(loc);
            float localX = rawX - loc[0];
            float slop = 10f * host.getResources().getDisplayMetrics().density;

            if (act == MotionEvent.ACTION_DOWN) {
                downX = rawX;
                dragging = false;
                if (lastSelIdx >= 0 && lastSelIdx < snapshots.length) {
                    captureTabSnapshot(lastSelIdx);
                }
                return false;
            } else if (act == MotionEvent.ACTION_MOVE) {
                if (!dragging && Math.abs(rawX - downX) > slop) {
                    dragging = true;
                    ViewParent p = host.getParent();
                    if (p != null) p.requestDisallowInterceptTouchEvent(true);
                    MotionEvent cancel = MotionEvent.obtain(e);
                    cancel.setAction(MotionEvent.ACTION_CANCEL);
                    ViewGroup vg = tabs();
                    if (vg != null) vg.dispatchTouchEvent(cancel);
                    cancel.recycle();
                }
                if (dragging) {
                    drag = posFromX(localX);
                    host.invalidate();
                    return true;
                }
                return false;
            } else if (act == MotionEvent.ACTION_UP || act == MotionEvent.ACTION_CANCEL) {
                if (dragging) {
                    dragging = false;
                    float pos = posFromX(localX);
                    int idx = Math.round(pos);
                    drag = Float.NaN;
                    hold = idx;
                    holdT = SystemClock.uptimeMillis() + 700L;
                    ViewGroup vg = tabs();
                    if (vg != null && act == MotionEvent.ACTION_UP) {
                        View target = kid(vg, idx);
                        if (target != null) target.performClick();
                    }
                    host.invalidate();
                    return true;
                }
                return false;
            }
            return false;
        }

        boolean ensureVivoGlass(float r, boolean dark) {
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
                    return true;
                }
            } catch (Throwable t) {
                sSetMaterial = null;
            }
            vivoActive = false;
            return false;
        }

        boolean tick() {
            if (host.getVisibility() != View.VISIBLE) return true;
            long now = SystemClock.uptimeMillis();
            boolean geomChanged = enforceGeometry();
            if (geomChanged && cancelStreak < 2) {
                cancelStreak++;
                return false;
            }
            cancelStreak = 0;
            if (now - lastStyleMs > 200L) {
                lastStyleMs = now;
                styleContainer();
                hookTabs();
                checkFoldRefresh();
            }

            if (host.getBackground() != backDrawable) {
                host.setBackground(backDrawable);
            }
            if (host.getForeground() != foreDrawable) {
                host.setForeground(foreDrawable);
            }

            // Detect tab selection change -> trigger smooth horizontal carousel sweep through intermediate tabs!
            float sp = selectedPos();
            if (!Float.isNaN(sp)) {
                int selIdx = Math.round(sp);
                if (lastSelIdx == -1) {
                    lastSelIdx = selIdx;
                    settleTimeMs = now;
                    snapshotCapturedForCurrent = false;
                } else if (selIdx != lastSelIdx) {
                    int fromIdx = lastSelIdx;
                    lastSelIdx = selIdx;
                    settleTimeMs = now;
                    snapshotCapturedForCurrent = false;
                    startPageTransition(fromIdx, selIdx);
                } else if (!snapshotCapturedForCurrent && (now - settleTimeMs) > 650L && lensA < 0.05f) {
                    snapshotCapturedForCurrent = true;
                    captureTabSnapshot(selIdx);
                }
            }

            float dt = (lastTickMs > 0L) ? Math.min(32f, Math.max(4f, now - lastTickMs)) : 16.67f;
            lastTickMs = now;
            float step = dt / 16.67f;

            boolean shorts = isShortsSelected();

            // Smoothly fade darkMix (0=Light, 1=Dark/Shorts) over ~240ms when entering/leaving Shorts
            float wantDark = isDarkMode() ? 1f : 0f;
            if (darkMix < 0f) {
                darkMix = wantDark;
            } else if (Math.abs(wantDark - darkMix) > 0.005f) {
                float dStep = dt / 240f;
                if (wantDark > darkMix) darkMix = Math.min(1f, darkMix + dStep);
                else darkMix = Math.max(0f, darkMix - dStep);
                host.invalidate();
            } else {
                darkMix = wantDark;
            }

            // Smooth vertical dock positioning + full-bezel scroll hide/show:
            // - Normal tabs visible: parent.translationY = -16dp (floats cleanly above bottom gesture bar)
            // - Shorts tab visible: smoothly glides to 0dp (tucked right under Shorts progress bar)
            // - When YouTube hides the dock on scroll (host.translationY: 0 -> hostH), push parent smoothly
            //   down to +24dp so the dock glides completely OFF the bottom edge of the screen and rises back from the bottom!
            float wantDrop = shorts ? 1f : 0f;
            if (Math.abs(wantDrop - shortsDropMix) > 0.005f) {
                float dStep = dt / 240f;
                if (wantDrop > shortsDropMix) shortsDropMix = Math.min(1f, shortsDropMix + dStep);
                else shortsDropMix = Math.max(0f, shortsDropMix - dStep);
                host.invalidate();
            } else {
                shortsDropMix = wantDrop;
            }
            float d = host.getResources().getDisplayMetrics().density;
            float baseParentTy = (1f - shortsDropMix) * (-16f * d);
            float hostH = (host.getHeight() > 0) ? host.getHeight() : (48f * d);
            float hostTy = Math.max(0f, host.getTranslationY());
            float hideFrac = Math.min(1f, hostTy / hostH);
            // Smoothly interpolate parent from floating (-16dp / 0dp) down to +24dp as host hides -> exits completely off bottom bezel!
            float targetParentTy = baseParentTy + hideFrac * (24f * d - baseParentTy);
            ViewParent p = host.getParent();
            if (p instanceof View) {
                View pv = (View) p;
                if (Math.abs(pv.getTranslationY() - targetParentTy) > 0.5f) {
                    pv.setTranslationY(targetParentTy);
                }
            }

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

            updateTabColors();
            fx.refresh(tabs(), isDarkMode(), lensA == 0f && Float.isNaN(drag));

            boolean wantClip = lensA < 0.05f;
            if (host.getClipToOutline() != wantClip) {
                host.setClipToOutline(wantClip);
                host.invalidateOutline();
            }
            return true;
        }

        private ViewGroup findPageContainer(View[] outDockAncestor) {
            View child = host;
            ViewParent vp = host.getParent();
            while (vp instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) vp;
                if (!(vg instanceof LinearLayout) && vg.getHeight() > host.getHeight() * 3 && vg.getWidth() > 0) {
                    outDockAncestor[0] = child;
                    return vg;
                }
                child = vg;
                vp = vg.getParent();
            }
            return null;
        }

        private void captureTabSnapshot(int idx) {
            if (idx < 0 || idx >= snapshots.length) return;
            try {
                View[] anc = new View[1];
                ViewGroup container = findPageContainer(anc);
                if (container == null) return;
                int w = container.getWidth();
                int h = container.getHeight();
                if (w <= 0 || h <= 0) return;
                int sw = Math.max(1, w / 2);
                int sh = Math.max(1, h / 2);
                Bitmap bmp = snapshots[idx];
                if (bmp == null || bmp.isRecycled() || bmp.getWidth() != sw || bmp.getHeight() != sh) {
                    if (bmp != null && !bmp.isRecycled()) bmp.recycle();
                    bmp = Bitmap.createBitmap(sw, sh, Bitmap.Config.RGB_565);
                    snapshots[idx] = bmp;
                }
                Canvas c = new Canvas(bmp);
                c.drawColor(isDarkMode() ? 0xFF0F0F0F : 0xFFFFFFFF);
                c.scale(0.5f, 0.5f);
                int dockIdx = container.indexOfChild(anc[0]);
                for (int i = 0; i < container.getChildCount(); i++) {
                    if (i == dockIdx) continue;
                    View child = container.getChildAt(i);
                    if (child == pageOverlay || child.getVisibility() != View.VISIBLE) continue;
                    int save = c.save();
                    c.translate(child.getLeft() + child.getTranslationX(), child.getTop() + child.getTranslationY());
                    child.draw(c);
                    c.restoreToCount(save);
                }
            } catch (Throwable ignored) {}
        }

        private void startPageTransition(int fromIdx, int toIdx) {
            if (fromIdx == toIdx) return;
            try {
                View[] anc = new View[1];
                ViewGroup container = findPageContainer(anc);
                if (container == null) return;
                int dockIdx = container.indexOfChild(anc[0]);
                if (dockIdx < 0) return;
                if (pageOverlay == null) {
                    pageOverlay = new PageStripOverlay(host.getContext());
                }
                if (pageOverlay.getParent() != container) {
                    if (pageOverlay.getParent() instanceof ViewGroup) {
                        ((ViewGroup) pageOverlay.getParent()).removeView(pageOverlay);
                    }
                    ViewGroup.LayoutParams lp = new ViewGroup.LayoutParams(
                            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                    container.addView(pageOverlay, dockIdx, lp);
                }
                pageOverlay.start(snapshots, fromIdx, toIdx, isDarkMode());
            } catch (Throwable ignored) {}
        }

        boolean enforceGeometry() {
            boolean chg = false;
            try {
                float d = host.getResources().getDisplayMetrics().density;
                View root = host.getRootView();
                int rw = (root != null && root.getWidth() > 0) ? root.getWidth() : host.getResources().getDisplayMetrics().widthPixels;
                int wDp = (int) (rw / d);
                if (wDp > 0) sLastWidthDp = wDp;
                boolean wide = wDp >= 580;
                boolean shorts = isShortsSelected();

                int wantW = wide ? Math.min((int) (436f * d), rw - (int) (32f * d)) : ViewGroup.LayoutParams.MATCH_PARENT;
                int wantLR = wide ? 0 : (int) (14f * d);

                ViewParent p0 = host.getParent();
                if (p0 instanceof ViewGroup) {
                    ViewGroup parent = (ViewGroup) p0;
                    if (parent.getPaddingBottom() != 0 || parent.getPaddingTop() != 0) {
                        parent.setPadding(parent.getPaddingLeft(), 0, parent.getPaddingRight(), 0);
                        chg = true;
                    }
                    boolean sysDark = (host.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK)
                            == Configuration.UI_MODE_NIGHT_YES;
                    boolean shortsInLight = !sysDark && shorts;
                    if (shortsInLight) {
                        int a = (int) (255f * Math.max(0f, Math.min(1f, darkMix)));
                        parent.setBackgroundColor((a << 24));
                    } else if (parent.getBackground() != null) {
                        parent.setBackground(null);
                    }
                }

                ViewGroup.LayoutParams lp = host.getLayoutParams();
                if (lp instanceof ViewGroup.MarginLayoutParams) {
                    ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) lp;
                    if (mlp.width != wantW) { mlp.width = wantW; chg = true; }
                    if (mlp.height != ViewGroup.LayoutParams.MATCH_PARENT) { mlp.height = ViewGroup.LayoutParams.MATCH_PARENT; chg = true; }
                    if (mlp.leftMargin != wantLR) { mlp.leftMargin = wantLR; chg = true; }
                    if (mlp.rightMargin != wantLR) { mlp.rightMargin = wantLR; chg = true; }
                    if (mlp.bottomMargin != 0) { mlp.bottomMargin = 0; chg = true; }
                    if (mlp.topMargin != 0) { mlp.topMargin = 0; chg = true; }
                    if (lp instanceof FrameLayout.LayoutParams) {
                        FrameLayout.LayoutParams flp = (FrameLayout.LayoutParams) lp;
                        int wantG = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                        if (flp.gravity != wantG) { flp.gravity = wantG; chg = true; }
                    } else if (lp instanceof LinearLayout.LayoutParams) {
                        LinearLayout.LayoutParams llp = (LinearLayout.LayoutParams) lp;
                        if (llp.gravity != Gravity.CENTER_HORIZONTAL) { llp.gravity = Gravity.CENTER_HORIZONTAL; chg = true; }
                    }
                    if (chg) {
                        host.setLayoutParams(mlp);
                    }
                }
                if (host.getPaddingBottom() != 0 || host.getPaddingTop() != 0) {
                    host.setPadding(host.getPaddingLeft(), 0, host.getPaddingRight(), 0);
                    chg = true;
                }
            } catch (Throwable ignored) {}
            return chg;
        }

        // On physical fold/unfold crossing 580dp, sLastWidthDp updates immediately so getDynamicFormFactor()
        // switches 1 <-> 2 (SMALL <-> LARGE). Trigger YouTube's own SwipeRefreshLayout listener so the server
        // delivers the exact native 2-col inner grid (or 1-col outer feed) with ZERO Activity.recreate()!
        private void checkFoldRefresh() {
            try {
                if (host.getVisibility() != View.VISIBLE) return;
                float d = host.getResources().getDisplayMetrics().density;
                View root = host.getRootView();
                if (root == null || root.getWidth() <= 0) return;
                int wDp = (int) (root.getWidth() / d);
                if (wDp <= 0) return;
                sLastWidthDp = wDp;
                int wideNow = (wDp >= 580) ? 1 : 0;
                if (lastWideState == -1) {
                    lastWideState = wideNow;
                    return;
                }
                if (wideNow != lastWideState) {
                    lastWideState = wideNow;
                    long now = SystemClock.uptimeMillis();
                    if (now - sLastRecreateMs < 1200L) return;
                    sLastRecreateMs = now;
                    host.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            triggerSwipeRefresh(host.getRootView());
                        }
                    }, 120L);
                }
            } catch (Throwable ignored) {}
        }

        private static boolean triggerSwipeRefresh(View v) {
            if (v == null || !v.isShown()) return false;
            if (v.getClass().getName().contains("SwipeRefreshLayout")) {
                try {
                    Class<?> cls = v.getClass();
                    while (cls != null && cls != ViewGroup.class) {
                        for (java.lang.reflect.Field f : cls.getDeclaredFields()) {
                            Class<?> ft = f.getType();
                            if (!ft.isInterface()) continue;
                            Method[] ms = ft.getDeclaredMethods();
                            if (ms.length == 1 && ms[0].getParameterTypes().length == 0 && ms[0].getReturnType() == void.class) {
                                f.setAccessible(true);
                                Object listener = f.get(v);
                                if (listener != null) {
                                    ms[0].invoke(listener);
                                    android.util.Log.i("YGlass", "Triggered SwipeRefreshLayout refresh for wDp=" + sLastWidthDp);
                                    return true;
                                }
                            }
                        }
                        cls = cls.getSuperclass();
                    }
                } catch (Throwable t) {
                    android.util.Log.w("YGlass", "triggerSwipeRefresh err: " + t);
                }
            }
            if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    if (triggerSwipeRefresh(vg.getChildAt(i))) return true;
                }
            }
            return false;
        }

        private void styleContainer() {
            try {
                float d = host.getResources().getDisplayMetrics().density;
                ViewParent p = host.getParent();
                if (p instanceof ViewGroup) {
                    ViewGroup parent = (ViewGroup) p;
                    parent.setClipChildren(false);
                    parent.setClipToPadding(false);
                    parent.setElevation(0f);
                    for (int i = 0; i < parent.getChildCount(); i++) {
                        View sibling = parent.getChildAt(i);
                        if (sibling == host) continue;
                        if (sibling.getHeight() > 0 && sibling.getHeight() <= (int) (3f * d)) {
                            sibling.setVisibility(View.GONE);
                        }
                    }
                    ViewParent gp = parent.getParent();
                    if (gp instanceof ViewGroup) {
                        ((ViewGroup) gp).setClipChildren(false);
                        ((ViewGroup) gp).setClipToPadding(false);
                    }
                }
            } catch (Throwable ignored) {}
        }

        private void hookTabs() {
            ViewGroup vg = tabs();
            if (vg == null) return;
            if (vg.getBackground() != null) vg.setBackground(null);
            vg.setClipChildren(false);
            float d = host.getResources().getDisplayMetrics().density;
            int inset = (int) Math.round(4f * d);
            int hostW = host.getWidth();
            int hostH = host.getHeight();
            if (hostW > 0) {
                ViewGroup.LayoutParams vlp = vg.getLayoutParams();
                if (vlp != null && vlp.width != hostW) {
                    vlp.width = hostW;
                    vg.setLayoutParams(vlp);
                }
            }
            if (vg.getPaddingLeft() != inset || vg.getPaddingRight() != inset || vg.getPaddingTop() != 0 || vg.getPaddingBottom() != 0) {
                vg.setPadding(inset, 0, inset, 0);
            }
            if (vg.getScaleX() != 1f || vg.getScaleY() != 1f) {
                vg.setScaleX(1f);
                vg.setScaleY(1f);
            }
            int visCount = count(vg);
            int cellW = (hostW > 2 * inset && visCount > 0) ? ((hostW - 2 * inset) / visCount) : 0;
            int n = vg.getChildCount();
            boolean dark = isDarkMode();
            for (int i = 0; i < n; i++) {
                View tab = vg.getChildAt(i);
                if (tab.getVisibility() == View.VISIBLE && cellW > 0) {
                    ViewGroup.LayoutParams tlp = tab.getLayoutParams();
                    if (tlp != null && (tlp.width != cellW || (hostH > 0 && tlp.height != hostH))) {
                        tlp.width = cellW;
                        if (hostH > 0) tlp.height = hostH;
                        if (tlp instanceof LinearLayout.LayoutParams) {
                            ((LinearLayout.LayoutParams) tlp).weight = 0f;
                        }
                        tab.setLayoutParams(tlp);
                    }
                }
                if (tab.getWidth() > 0 && tab.getHeight() > 0) {
                    float px = tab.getWidth() * 0.5f;
                    float py = tab.getHeight() * 0.5f;
                    if (Math.abs(tab.getPivotX() - px) > 0.5f) tab.setPivotX(px);
                    if (Math.abs(tab.getPivotY() - py) > 0.5f) tab.setPivotY(py);
                }
                if (Math.abs(tab.getScaleX() - 0.80f) > 0.005f) {
                    tab.setScaleX(0.80f);
                    tab.setScaleY(0.80f);
                }
                stripRipple(tab);
                boostTextLegibility(tab, dark, d);
            }
        }

        private void updateTabColors() {
            ViewGroup vg = tabs();
            if (vg == null) return;
            float dm = (darkMix >= 0f) ? darkMix : (isDarkMode() ? 1f : 0f);
            int unselColor = blendColor(0xFF3A3A3F, 0xD8FFFFFF, dm);
            int selIconColor = blendColor(0xFFFF0033, 0xFFFF334B, dm);
            int selTextColor = blendColor(0xFFE6002E, 0xFFFF3B52, dm);
            float restWeight = Math.max(0f, Math.min(1f, 1f - lensA));
            int activeIconColor = blendColor(unselColor, selIconColor, restWeight);
            int activeTextColor = blendColor(unselColor, selTextColor, restWeight);

            int n = vg.getChildCount();
            for (int i = 0; i < n; i++) {
                View tab = vg.getChildAt(i);
                if (tab.getVisibility() != View.VISIBLE) continue;
                boolean sel = tab.isSelected();
                applyTabTint(tab, sel ? activeIconColor : unselColor, sel ? activeTextColor : unselColor);
            }
        }

        private static void applyTabTint(View v, int iconColor, int textColor) {
            if (v instanceof ImageView) {
                ImageView iv = (ImageView) v;
                Drawable dr = iv.getDrawable();
                if (isIconDrawable(dr)) {
                    iv.setColorFilter(new PorterDuffColorFilter(iconColor, PorterDuff.Mode.SRC_IN));
                } else if (iv.getColorFilter() != null) {
                    iv.setColorFilter(null);
                }
            } else if (v instanceof TextView) {
                TextView tv = (TextView) v;
                if (tv.getCurrentTextColor() != textColor) {
                    tv.setTextColor(textColor);
                }
            } else if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    applyTabTint(vg.getChildAt(i), iconColor, textColor);
                }
            }
        }

        private static boolean isIconDrawable(Drawable dr) {
            if (dr == null) return false;
            if (dr instanceof StateListDrawable || dr instanceof LayerDrawable) return true;
            if (dr instanceof BitmapDrawable) return false;
            String cn = dr.getClass().getName();
            if (cn.contains("Bitmap") || cn.contains("Rounded") || cn.contains("Circle") || cn.contains("Avatar")) {
                return false;
            }
            return cn.contains("Vector") || cn.contains("StateList") || cn.contains("Layer") || cn.contains("Animated");
        }

        private static int blendColor(int c0, int c1, float t) {
            if (t <= 0f) return c0;
            if (t >= 1f) return c1;
            int a = (int) (Color.alpha(c0) + (Color.alpha(c1) - Color.alpha(c0)) * t);
            int r = (int) (Color.red(c0) + (Color.red(c1) - Color.red(c0)) * t);
            int g = (int) (Color.green(c0) + (Color.green(c1) - Color.green(c0)) * t);
            int b = (int) (Color.blue(c0) + (Color.blue(c1) - Color.blue(c0)) * t);
            return Color.argb(a, r, g, b);
        }

        private static final class SavedDrawable {
            final Drawable dr;
            final Drawable.Callback cb;
            final int[] state;
            SavedDrawable(Drawable dr, Drawable.Callback cb, int[] state) {
                this.dr = dr;
                this.cb = cb;
                this.state = state;
            }
        }

        private static void forceSelectedDrawables(View v, ArrayList<SavedDrawable> saved) {
            if (v instanceof ImageView) {
                Drawable dr = ((ImageView) v).getDrawable();
                if (isIconDrawable(dr)) {
                    Drawable.Callback cb = dr.getCallback();
                    int[] prev = dr.getState();
                    int[] copy = (prev != null) ? prev.clone() : new int[0];
                    saved.add(new SavedDrawable(dr, cb, copy));
                    dr.setCallback(null);
                    dr.setState(STATE_SELECTED);
                }
            } else if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    forceSelectedDrawables(vg.getChildAt(i), saved);
                }
            }
        }

        private static void restoreDrawables(ArrayList<SavedDrawable> saved) {
            for (int i = saved.size() - 1; i >= 0; i--) {
                SavedDrawable s = saved.get(i);
                s.dr.setState(s.state);
                s.dr.setCallback(s.cb);
            }
        }

        private static boolean findAvatarRect(View v, View root, RectF out) {
            if (v.getVisibility() != View.VISIBLE) return false;
            if (v instanceof ImageView) {
                Drawable dr = ((ImageView) v).getDrawable();
                if (dr != null && !isIconDrawable(dr) && v.getWidth() > 0 && v.getHeight() > 0) {
                    Rect vr = new Rect();
                    Rect rr = new Rect();
                    if (v.getGlobalVisibleRect(vr) && root.getGlobalVisibleRect(rr)) {
                        out.set(vr.left - rr.left - 3f, vr.top - rr.top - 3f,
                                vr.right - rr.left + 3f, vr.bottom - rr.top + 3f);
                        return true;
                    }
                }
            } else if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    if (findAvatarRect(vg.getChildAt(i), root, out)) return true;
                }
            }
            return false;
        }

        private static void boostTextLegibility(View v, boolean dark, float d) {
            if (v instanceof TextView) {
                TextView tv = (TextView) v;
                tv.setShadowLayer(2.0f * d, 0f, 0.5f * d, dark ? 0x80000000 : 0x66FFFFFF);
            } else if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    boostTextLegibility(vg.getChildAt(i), dark, d);
                }
            }
        }

        private static void stripRipple(View v) {
            if (v instanceof ViewGroup) {
                if (v.getBackground() != null) v.setBackground(null);
                if (v.getForeground() != null) v.setForeground(null);
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    stripRipple(vg.getChildAt(i));
                }
            } else {
                Drawable bg = v.getBackground();
                if (bg instanceof RippleDrawable || bg instanceof StateListDrawable || bg instanceof ColorDrawable) {
                    v.setBackground(null);
                }
                Drawable fg = v.getForeground();
                if (fg instanceof RippleDrawable || fg instanceof StateListDrawable) {
                    v.setForeground(null);
                }
            }
        }

        private void tickSpring(float step) {
            float target = selectedPos();
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

        // Zalo Android Duo geometry: concentric 4dp resting pill; droplet swells to 1.42x cell (+velocity stretch)
        // and 5dp past the dock top/bottom while gliding/dragging.
        boolean computePillRect(RectF out, float d, float unused) {
            ViewGroup vg = tabs();
            if (vg == null || Float.isNaN(cur)) return false;
            int n = count(vg);
            if (n <= 0) return false;
            float pos = Math.max(0f, Math.min(cur, n - 1));
            int i0 = Math.max(0, Math.min((int) pos, n - 2));
            float f = pos - i0;
            View v0 = kid(vg, i0);
            View v1 = kid(vg, Math.min(i0 + 1, n - 1));
            if (v0 == null || v1 == null) return false;
            float c0 = cx(vg, v0);
            float c1 = cx(vg, v1);
            float centerX = c0 + (c1 - c0) * f;
            float cellW = v0.getWidth() + (v1.getWidth() - v0.getWidth()) * f;
            float stretch = 1f + Math.min(Math.abs(vel) * 6f, 0.22f);
            float pad = 4f * d;
            float restW = cellW - 2f * pad;
            float lensW = cellW * 1.42f * stretch;
            float pillW = restW + (lensW - restW) * lensA;
            float insetY = (2f * pad) - 18f * d * lensA;
            float w = host.getWidth();
            float h = host.getHeight();
            float pillH = h - insetY;
            float top = (h - pillH) * 0.5f;
            float left = centerX - pillW * 0.5f;
            float right = centerX + pillW * 0.5f;
            if (lensA < 0.05f) {
                if (left < pad) {
                    left = pad;
                    right = Math.min(w - pad, left + pillW);
                } else if (right > w - pad) {
                    right = w - pad;
                    left = Math.max(pad, right - pillW);
                }
            }
            out.set(left, top, right, top + pillH);
            return out.width() > 0f && out.height() > 0f;
        }

        void drawBack(Canvas canvas, Rect bounds) {
            try {
                float w = bounds.width(), h = bounds.height();
                if (w <= 0f || h <= 0f) return;
                float d = host.getResources().getDisplayMetrics().density;
                boolean dark = isDarkMode();
                float r = h * 0.5f;

                if (ensureVivoGlass(r, dark)) {
                    if (host.getElevation() != 0f) host.setElevation(0f);
                } else {
                    rect.set(0f, 0f, w, h);
                    paint.setStyle(Paint.Style.FILL);
                    paint.setShader(new LinearGradient(0f, 0f, 0f, h,
                            dark ? 0xCC1E1E22 : 0xDCFFFFFF,
                            dark ? 0xD8141418 : 0xCCF2F4F8,
                            Shader.TileMode.CLAMP));
                    canvas.drawRoundRect(rect, r, r, paint);
                    paint.setShader(null);
                }

                // Zalo resting pill: clear glass behind the selected icon, cross-fades into the droplet
                if (lensA < 0.95f && computePillRect(rect, d, 0f)) {
                    float pr = rect.height() * 0.5f;
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
            } catch (Throwable ignored) {}
        }

        void drawFore(Canvas canvas) {
            if (lensA <= 0.02f) return;
            try {
                float d = host.getResources().getDisplayMetrics().density;
                boolean dark = isDarkMode();
                float dm = (darkMix >= 0f) ? darkMix : (dark ? 1f : 0f);
                float fx = lensA * lensA;
                if (!computePillRect(rect, d, fx * 0.6f)) return;
                float r = rect.height() * 0.5f;

                if (Build.VERSION.SDK_INT >= 33 && canvas.isHardwareAccelerated()) {
                    ViewGroup vg = tabs();
                    if (vg != null) {
                        if (node == null) node = new RenderNode("ylens");
                        if (rs == null) rs = new RuntimeShader(SHADER_SRC);
                        float pad = 12f * d;
                        int nw = (int) (rect.width() + 2f * pad);
                        int nh = (int) (rect.height() + 2f * pad);
                        if (nw > 0 && nh > 0) {
                            ArrayList<SavedDrawable> saved = new ArrayList<>();
                            node.setPosition(0, 0, nw, nh);
                            Canvas rc = node.beginRecording(nw, nh);
                            try {
                                forceSelectedDrawables(vg, saved);
                                rc.translate(pad - rect.left, pad - rect.top);
                                rc.translate(vg.getLeft(), vg.getTop());
                                this.fx.drawSelected(vg, rc); // filled icons dumped from each tab's selected look
                            } finally {
                                restoreDrawables(saved);
                                node.endRecording();
                            }
                            RectF av = new RectF(-9999f, -9999f, -9998f, -9998f);
                            if (findAvatarRect(vg, host, av)) {
                                av.offset(pad - rect.left, pad - rect.top);
                            }
                            rs.setFloatUniform("size", rect.width(), rect.height());
                            rs.setFloatUniform("radius", r);
                            rs.setFloatUniform("pad", pad);
                            rs.setFloatUniform("edge", Math.min(13f * d, r));
                            rs.setFloatUniform("strength", 13f * d * fx);
                            rs.setFloatUniform("mag", 1f + 0.10f * fx);
                            rs.setFloatUniform("avatarBox", av.left, av.top, av.right, av.bottom);
                            float bgR = 0.97f * (1f - dm) + 0.21f * dm;
                            float bgG = 0.98f * (1f - dm) + 0.21f * dm;
                            float bgB = 1.00f * (1f - dm) + 0.24f * dm;
                            float bgA = (0.90f * (1f - dm) + 0.90f * dm) * lensA;
                            rs.setFloatUniform("tintBg", bgR, bgG, bgB, bgA);
                            rs.setFloatUniform("selColor", 1.0f, 0.0f + 0.30f * dm, 0.20f + 0.18f * dm, 1.0f);
                            node.setRenderEffect(RenderEffect.createRuntimeShaderEffect(rs, "content"));
                            canvas.save();
                            canvas.translate(rect.left - pad, rect.top - pad);
                            canvas.drawRenderNode(node);
                            canvas.restore();
                        }
                    }
                }

                // Crisp concentric specular glass rim on the moving droplet
                paint.setStyle(Paint.Style.STROKE);
                paint.setStrokeWidth(1.1f * d);
                paint.setShader(new LinearGradient(rect.left, rect.top, rect.left + rect.width() * 0.4f, rect.bottom,
                        dark ? new int[]{0xAAFFFFFF, 0x20FFFFFF, 0x60FFFFFF}
                             : new int[]{0xFFFFFFFF, 0x40FFFFFF, 0xBBFFFFFF},
                        new float[]{0f, 0.5f, 1f}, Shader.TileMode.CLAMP));
                paint.setAlpha((int) (255 * lensA));
                canvas.drawRoundRect(rect, r, r, paint);
                paint.setShader(null);
                paint.setStyle(Paint.Style.FILL);
                paint.setAlpha(255);
            } catch (Throwable ignored) {}
        }
    }

    // GPU-accelerated horizontal carousel overlay: sweeps smoothly across intermediate tab snapshots (e.g. 1 -> 2 -> 3 -> 4)
    private static final class PageStripOverlay extends View {
        private final Paint bmpPaint = new Paint(Paint.FILTER_BITMAP_FLAG);
        private final Paint bgPaint = new Paint();
        private final Rect dst = new Rect();
        private Bitmap[] snaps;
        private int fromIdx;
        private int toIdx;
        private long startMs;
        private long durationMs;
        private boolean dark;
        private boolean active;

        PageStripOverlay(Context ctx) {
            super(ctx);
            setClickable(false);
            setFocusable(false);
            setVisibility(View.GONE);
        }

        void start(Bitmap[] snapshots, int from, int to, boolean darkMode) {
            this.snaps = snapshots;
            this.fromIdx = from;
            this.toIdx = to;
            this.dark = darkMode;
            this.startMs = SystemClock.uptimeMillis();
            int dist = Math.abs(to - from);
            this.durationMs = 230L + 55L * dist;
            this.active = true;
            setAlpha(1f);
            setVisibility(View.VISIBLE);
            invalidate();
        }

        @Override
        protected void onDraw(Canvas canvas) {
            if (!active || snaps == null) return;
            int w = getWidth(), h = getHeight();
            if (w <= 0 || h <= 0) return;

            long elapsed = SystemClock.uptimeMillis() - startMs;
            float t = Math.min(1f, Math.max(0f, elapsed / (float) durationMs));
            float inv = 1f - t;
            float ease = 1f - inv * inv * inv;

            float curPage = fromIdx + (toIdx - fromIdx) * ease;
            int minIdx = Math.min(fromIdx, toIdx);
            int maxIdx = Math.max(fromIdx, toIdx);

            float overlayAlpha = (t > 0.82f) ? Math.max(0f, (1f - t) / 0.18f) : 1f;
            int alpha255 = (int) (255f * overlayAlpha);

            bgPaint.setColor(dark ? 0xFF0F0F0F : 0xFFFFFFFF);
            bgPaint.setAlpha(alpha255);
            bmpPaint.setAlpha(alpha255);

            for (int i = minIdx; i <= maxIdx; i++) {
                float xOff = (i - curPage) * w;
                if (xOff > w || xOff + w < 0) continue;
                int left = Math.round(xOff);
                dst.set(left, 0, left + w, h);
                Bitmap b = (i >= 0 && i < snaps.length) ? snaps[i] : null;
                if (b != null && !b.isRecycled()) {
                    canvas.drawBitmap(b, null, dst, bmpPaint);
                } else {
                    canvas.drawRect(dst, bgPaint);
                }
            }

            if (t >= 1f) {
                active = false;
                setVisibility(View.GONE);
            } else {
                postInvalidateOnAnimation();
            }
        }
    }

    private static final class YBack extends Drawable {
        final GlassController c;
        YBack(GlassController c) { this.c = c; }
        @Override public void draw(Canvas canvas) { c.drawBack(canvas, getBounds()); }
        @Override public void setAlpha(int alpha) {}
        @Override public void setColorFilter(ColorFilter cf) {}
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }

    private static final class YFore extends Drawable {
        final GlassController c;
        YFore(GlassController c) { this.c = c; }
        @Override public void draw(Canvas canvas) { c.drawFore(canvas); }
        @Override public void setAlpha(int alpha) {}
        @Override public void setColorFilter(ColorFilter cf) {}
        @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    }
}
