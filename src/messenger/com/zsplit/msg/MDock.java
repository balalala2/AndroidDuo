package com.zsplit.msg;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Outline;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.RenderEffect;
import android.graphics.RenderNode;
import android.graphics.Shader;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.RippleDrawable;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewOutlineProvider;
import android.view.ViewParent;
import android.widget.FrameLayout;
import java.util.HashMap;
import java.util.WeakHashMap;

final class MDock {
    private static final int ID_TAB_BAR = 0x7f0b0903;
    private static final int ID_META_AI_CONTAINER = 0x7f0b0720;
    private static final int TAG_SCRIM = 0x7a5f0101;
    private static final int TAG_GLASS_HOST = 0x7a5f0102;
    private static final float TAB_SCALE = 1.0f;
    private static final WeakHashMap<View, MDrag> sDragMap = new WeakHashMap<>();
    private static final HashMap<Class<?>, Boolean> sIsList = new HashMap<>();
    private static final ViewOutlineProvider sPillOutline = new ViewOutlineProvider() {
        @Override
        public void getOutline(View view, Outline outline) {
            int w = view.getWidth();
            int h = view.getHeight();
            if (w > 0 && h > 0) {
                outline.setRoundRect(0, 0, w, h, h * 0.5f);
            }
        }
    };
    private static int sPadTick;

    static void tick(View mainRoot) {
        try {
            View tabBar = mainRoot.findViewById(ID_TAB_BAR);
            if (tabBar == null || tabBar.getVisibility() != View.VISIBLE) return;

            float d = tabBar.getResources().getDisplayMetrics().density;

            // Wrap LithoView tabBar inside a 100%-size GlassHost FrameLayout so we can scale
            // BOTH icons AND Litho text uniformly (0.88x) inside a full-size Liquid Glass capsule!
            FrameLayout glassHost;
            ViewParent curParent = tabBar.getParent();
            if (curParent instanceof GlassHostLayout && Integer.valueOf(TAG_GLASS_HOST).equals(((View) curParent).getTag())) {
                glassHost = (FrameLayout) curParent;
            } else if (curParent instanceof ViewGroup) {
                ViewGroup oldParent = (ViewGroup) curParent;
                int idx = oldParent.indexOfChild(tabBar);
                ViewGroup.LayoutParams origLp = tabBar.getLayoutParams();
                glassHost = new GlassHostLayout(tabBar.getContext());
                glassHost.setTag(TAG_GLASS_HOST);
                glassHost.setWillNotDraw(false);
                glassHost.setClipChildren(false);
                glassHost.setClipToPadding(false);
                oldParent.removeViewAt(idx);
                glassHost.addView(tabBar, new FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT));
                oldParent.addView(glassHost, idx, origLp);
            } else {
                return;
            }

            // Uniformly scale LithoView (icons + badges + Vietnamese text together!) inside GlassHost
            if (tabBar.getScaleX() != TAB_SCALE) {
                tabBar.setScaleX(TAB_SCALE);
                tabBar.setScaleY(TAB_SCALE);
            }
            if (tabBar.getElevation() != 0f) tabBar.setElevation(0f);
            if (tabBar.getOutlineProvider() != null) tabBar.setOutlineProvider(null);
            if (tabBar.getBackground() != null) tabBar.setBackground(null);
            if (tabBar.getForeground() != null) tabBar.setForeground(null);
            stripFullWidthBg(tabBar);

            Drawable fg = glassHost.getForeground();
            MGlass glass;
            if (!(fg instanceof MFore)) {
                glass = new MGlass(glassHost, (tabBar instanceof ViewGroup) ? (ViewGroup) tabBar : null);
                glassHost.setWillNotDraw(false);
                glassHost.setBackground(new MBack(glass));
                glassHost.setForeground(new MFore(glass));

                ViewParent p = glassHost.getParent();
                for (int i = 0; i < 3 && p instanceof ViewGroup; i++) {
                    ViewGroup vg = (ViewGroup) p;
                    vg.setClipChildren(false);
                    vg.setClipToPadding(false);
                    p = vg.getParent();
                }
            } else {
                glass = ((MFore) fg).g;
                if (!(glassHost.getBackground() instanceof MBack)) {
                    glassHost.setBackground(new MBack(glass));
                }
            }

            // Re-assert pill outline & subtle elevation (0dp when Vivo hardware glass is active to avoid double-ring shadow)
            if (glassHost.getOutlineProvider() != sPillOutline) {
                glassHost.setOutlineProvider(sPillOutline);
                glassHost.invalidateOutline();
            }
            float wantElev = glass.isVivoActive() ? 0f : 8.0f * d;
            if (glassHost.getElevation() != wantElev) {
                glassHost.setElevation(wantElev);
            }

            // Float the pill dock over the chat list above it
            int tabH = glassHost.getHeight();
            int bMargin = (int) (12.0f * d);
            ViewGroup.LayoutParams lp = glassHost.getLayoutParams();
            if (lp instanceof ViewGroup.MarginLayoutParams) {
                ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) lp;
                int hMargin = (int) (20.0f * d);
                int tMargin = tabH > 0 ? -(tabH + bMargin) : 0;
                if (mlp.leftMargin != hMargin || mlp.rightMargin != hMargin
                        || mlp.bottomMargin != bMargin || mlp.topMargin != tMargin) {
                    mlp.leftMargin = hMargin;
                    mlp.rightMargin = hMargin;
                    mlp.bottomMargin = bMargin;
                    mlp.topMargin = tMargin;
                    glassHost.setLayoutParams(mlp);
                }
            }

            // Link MGlass to GlassHostLayout so dispatchTouchEvent handles smooth droplet dragging at any Litho nesting depth
            if (glassHost instanceof GlassHostLayout) {
                ((GlassHostLayout) glassHost).glass = glass;
            }

            // Unwrap Litho wrapper hosts to reach the real 4-button row AND strip Messenger 588's duplicate native dock + native pill!
            ViewGroup realTabs = glass.tabs();
            if (realTabs != null) {
                // Strip native rounded pill background/border on every ancestor from realTabs up to tabBar
                View anc = realTabs;
                while (anc != null && anc != glassHost) {
                    if (anc.getBackground() != null) anc.setBackground(null);
                    if (anc.getForeground() != null) anc.setForeground(null);
                    if (anc.getElevation() != 0f) anc.setElevation(0f);
                    if (anc.getOutlineProvider() != null) anc.setOutlineProvider(null);
                    stripFullWidthBg(anc);
                    ViewParent ap = anc.getParent();
                    // Hide Messenger 588's duplicate native active-indicator sibling overlay (e.g. Child 1 next to realTabs)
                    if (ap instanceof ViewGroup && anc == realTabs) {
                        ViewGroup rowParent = (ViewGroup) ap;
                        for (int s = 0; s < rowParent.getChildCount(); s++) {
                            View sib = rowParent.getChildAt(s);
                            if (sib != realTabs) {
                                if (sib.getVisibility() != View.INVISIBLE) sib.setVisibility(View.INVISIBLE);
                                if (sib.getAlpha() != 0f) sib.setAlpha(0f);
                            }
                        }
                    }
                    anc = (ap instanceof View) ? (View) ap : null;
                }

                int count = realTabs.getChildCount();
                for (int i = 0; i < count; i++) {
                    View child = realTabs.getChildAt(i);
                    if (child.getBackground() != null) child.setBackground(null);
                    if (child.getForeground() != null) child.setForeground(null);
                    noRipple(child);
                    if (child.getScaleX() != 1.0f) {
                        child.setScaleX(1.0f);
                        child.setScaleY(1.0f);
                    }
                }

                // Sub-pixel vertical centering: Messenger 588's inner icon box has unequal top/bottom padding
                // (e.g. 13px top vs 26px bottom), making icons sit slightly high inside the glass pill.
                if (tabH > 0) {
                    float wantTy = 0f;
                    View firstTab = MGlass.kid(realTabs, 0);
                    if (firstTab instanceof ViewGroup && ((ViewGroup) firstTab).getChildCount() > 0) {
                        View iconBox = ((ViewGroup) firstTab).getChildAt(0);
                        if (iconBox.getHeight() > 0) {
                            float iconCy = iconBox.getTop() + iconBox.getHeight() * 0.5f;
                            View pV = firstTab;
                            while (pV != null && pV != glassHost) {
                                iconCy += pV.getTop();
                                ViewParent pvP = pV.getParent();
                                pV = (pvP instanceof View) ? (View) pvP : null;
                            }
                            wantTy = (tabH * 0.5f) - iconCy;
                            if (wantTy < -12f * d) wantTy = -12f * d;
                            if (wantTy > 12f * d) wantTy = 12f * d;
                        }
                    }
                    if (Math.abs(tabBar.getTranslationY() - wantTy) > 0.5f) {
                        tabBar.setTranslationY(wantTy);
                    }
                }
            }

            glass.tick();

            if (tabH > 0) {
                // Real-time frosted blur glass scrim over the bottom of the chat list + link backdrop to outer glass pill
                FrameLayout cf = ensureBottomBlur(glassHost, tabH + (int) (42.0f * d));
                glass.backdrop = cf;

                // Lift ALL Meta AI FAB containers (0x7f0b0720) across EVERY tab (Chats, People, Notifications, Menu)!
                liftAllFabContainers(mainRoot, -(tabH + 18.0f * d), 14.0f * d, 0);
            }

            // Periodically pad scrollable lists so last chat clears the floating dock
            sPadTick++;
            if (sPadTick % 15 == 0 && tabH > 0) {
                ViewParent p = glassHost.getParent();
                if (p instanceof ViewGroup) {
                    ViewGroup container = (ViewGroup) p;
                    int wantPad = tabH + (int) (28.0f * d);
                    int minH = container.getHeight() / 2;
                    for (int i = 0; i < container.getChildCount(); i++) {
                        View sib = container.getChildAt(i);
                        if (sib != glassHost) {
                            padLists(sib, wantPad, minH, 0);
                        }
                    }
                }
            }
        } catch (Throwable ignored) {
        }
    }

    private static final class GlassHostLayout extends FrameLayout {
        MGlass glass;
        private float downX;
        private boolean dragging;

        GlassHostLayout(Context ctx) {
            super(ctx);
        }

        @Override
        public boolean dispatchTouchEvent(android.view.MotionEvent ev) {
            MGlass g = this.glass;
            if (g != null) {
                try {
                    int act = ev.getActionMasked();
                    float rawX = ev.getRawX();
                    int[] loc = new int[2];
                    getLocationOnScreen(loc);
                    float localX = rawX - loc[0];

                    if (act == android.view.MotionEvent.ACTION_DOWN) {
                        downX = rawX;
                        dragging = false;
                        super.dispatchTouchEvent(ev);
                        return true;
                    }
                    if (act == android.view.MotionEvent.ACTION_MOVE) {
                        if (!dragging) {
                            float slop = 6f * getResources().getDisplayMetrics().density;
                            if (Math.abs(rawX - downX) <= slop) {
                                return super.dispatchTouchEvent(ev);
                            }
                            dragging = true;
                            ViewParent p = getParent();
                            if (p != null) p.requestDisallowInterceptTouchEvent(true);
                            android.view.MotionEvent cancel = android.view.MotionEvent.obtain(ev);
                            cancel.setAction(android.view.MotionEvent.ACTION_CANCEL);
                            super.dispatchTouchEvent(cancel);
                            cancel.recycle();
                        }
                        g.drag = g.posFromX(localX);
                        invalidate();
                        return true;
                    }
                    if (dragging) {
                        dragging = false;
                        float last = g.drag;
                        g.drag = Float.NaN;
                        if (act == android.view.MotionEvent.ACTION_UP) {
                            int idx = Math.round(last);
                            g.hold = idx;
                            g.holdT = android.os.SystemClock.uptimeMillis() + 700L;
                            int curIdx = Math.round(g.activePos());
                            if (curIdx != idx) {
                                ViewGroup vg = g.tabs();
                                if (vg != null) {
                                    View target = MGlass.kid(vg, idx);
                                    if (target != null) {
                                        if (!target.performClick()) {
                                            float cx = g.scaledCx(target);
                                            float cy = getHeight() * 0.5f;
                                            long t = android.os.SystemClock.uptimeMillis();
                                            android.view.MotionEvent dEv = android.view.MotionEvent.obtain(t, t, android.view.MotionEvent.ACTION_DOWN, cx, cy, 0);
                                            android.view.MotionEvent uEv = android.view.MotionEvent.obtain(t, t + 10, android.view.MotionEvent.ACTION_UP, cx, cy, 0);
                                            super.dispatchTouchEvent(dEv);
                                            super.dispatchTouchEvent(uEv);
                                            dEv.recycle();
                                            uEv.recycle();
                                        }
                                    }
                                }
                            }
                        }
                        invalidate();
                        return true;
                    }
                } catch (Throwable ignored) {
                }
            }
            return super.dispatchTouchEvent(ev);
        }
    }

    static final int TAG_SCRIM_ID = TAG_SCRIM;

    private static FrameLayout ensureBottomBlur(View tabBar, int scrimH) {
        ViewParent p = tabBar.getParent();
        if (!(p instanceof ViewGroup)) return null;
        ViewGroup linear = (ViewGroup) p;
        FrameLayout contentFrame = null;
        for (int i = 0; i < linear.getChildCount(); i++) {
            View c = linear.getChildAt(i);
            if (c != tabBar && c instanceof FrameLayout && c.getHeight() > scrimH) {
                contentFrame = (FrameLayout) c;
                break;
            }
        }
        if (contentFrame == null) return null;

        View scrim = contentFrame.findViewWithTag(TAG_SCRIM);
        if (scrim == null) {
            BlurScrimView bv = new BlurScrimView(contentFrame.getContext(), contentFrame, tabBar);
            bv.setTag(TAG_SCRIM);
            bv.setClickable(false);
            bv.setFocusable(false);
            bv.setImportantForAccessibility(View.IMPORTANT_FOR_ACCESSIBILITY_NO);
            FrameLayout.LayoutParams flp = new FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, scrimH, Gravity.BOTTOM);
            contentFrame.addView(bv, flp);
        } else {
            ViewGroup.LayoutParams lp = scrim.getLayoutParams();
            if (lp != null && lp.height != scrimH) {
                lp.height = scrimH;
                scrim.setLayoutParams(lp);
            }
            if (contentFrame.indexOfChild(scrim) != contentFrame.getChildCount() - 1) {
                scrim.bringToFront();
            }
        }
        return contentFrame;
    }

    private static boolean sLoggedStrip;

    private static void stripFullWidthBg(View tabBar) {
        try {
            int bw = tabBar.getWidth();
            if (bw <= 0) return;
            int minW = (int) (bw * 0.60f);
            java.util.IdentityHashMap<Object, Boolean> seen = new java.util.IdentityHashMap<>();
            seen.put(tabBar, Boolean.TRUE);
            int stripped = 0;
            Class<?> cls = tabBar.getClass();
            while (cls != null && cls != ViewGroup.class && cls != View.class && cls != Object.class) {
                java.lang.reflect.Field[] fs = cls.getDeclaredFields();
                for (int i = 0; i < fs.length; i++) {
                    java.lang.reflect.Field f = fs[i];
                    if (java.lang.reflect.Modifier.isStatic(f.getModifiers())) continue;
                    if (f.getType().isPrimitive()) continue;
                    f.setAccessible(true);
                    Object val = f.get(tabBar);
                    if (val != null) stripped += stripFromObj(val, minW, 0, seen);
                }
                cls = cls.getSuperclass();
            }
            if (stripped > 0 && !sLoggedStrip) {
                sLoggedStrip = true;
                android.util.Log.i("MDock", "stripFullWidthBg bw=" + bw + " stripped=" + stripped);
            }
        } catch (Throwable ignored) {
        }
    }

    private static int stripFromObj(Object obj, int minW, int depth, java.util.IdentityHashMap<Object, Boolean> seen) {
        if (obj == null || depth > 5 || seen.size() > 350) return 0;
        if (seen.put(obj, Boolean.TRUE) != null) return 0;
        int c = 0;
        if (obj instanceof Drawable) {
            Drawable dr = (Drawable) obj;
            if ((dr instanceof android.graphics.drawable.ColorDrawable) || dr.getBounds().width() >= minW) {
                dr.setAlpha(0);
                dr.setBounds(0, 0, 0, 0);
                c++;
            }
            // Also recurse into Drawable wrappers (e.g., Litho MatrixDrawable -> ColorDrawable)
            Class<?> dc = dr.getClass();
            while (dc != null && dc != Drawable.class && dc != Object.class) {
                try {
                    java.lang.reflect.Field[] fs = dc.getDeclaredFields();
                    for (int i = 0; i < fs.length; i++) {
                        java.lang.reflect.Field f = fs[i];
                        if (java.lang.reflect.Modifier.isStatic(f.getModifiers())) continue;
                        if (Drawable.class.isAssignableFrom(f.getType())) {
                            f.setAccessible(true);
                            c += stripFromObj(f.get(dr), minW, depth + 1, seen);
                        }
                    }
                } catch (Throwable ignored) {}
                dc = dc.getSuperclass();
            }
            return c;
        }
        if (obj instanceof java.util.List) {
            java.util.List<?> list = (java.util.List<?>) obj;
            for (int i = 0; i < list.size(); i++) {
                c += stripFromObj(list.get(i), minW, depth + 1, seen);
            }
            return c;
        }
        if (obj instanceof Object[]) {
            Object[] arr = (Object[]) obj;
            for (int i = 0; i < arr.length; i++) {
                c += stripFromObj(arr[i], minW, depth + 1, seen);
            }
            return c;
        }
        if (obj instanceof android.util.SparseArray) {
            android.util.SparseArray<?> sa = (android.util.SparseArray<?>) obj;
            for (int i = 0; i < sa.size(); i++) {
                c += stripFromObj(sa.valueAt(i), minW, depth + 1, seen);
            }
            return c;
        }
        if (obj instanceof View) return 0;
        String cn = obj.getClass().getName();
        if (cn.startsWith("android.") || cn.startsWith("java.")) return 0;
        try {
            Class<?> oc = obj.getClass();
            while (oc != null && oc != Object.class) {
                java.lang.reflect.Field[] fs = oc.getDeclaredFields();
                for (int i = 0; i < fs.length; i++) {
                    java.lang.reflect.Field f = fs[i];
                    if (java.lang.reflect.Modifier.isStatic(f.getModifiers())) continue;
                    Class<?> ft = f.getType();
                    if (ft.isPrimitive() || ft == String.class) continue;
                    f.setAccessible(true);
                    c += stripFromObj(f.get(obj), minW, depth + 1, seen);
                }
                oc = oc.getSuperclass();
            }
        } catch (Throwable ignored) {
        }
        return c;
    }

    private static void liftAllFabContainers(View v, float ty, float elev, int depth) {
        if (v == null || depth > 14 || v.getVisibility() == View.GONE) return;
        boolean isFabBox = (v.getId() == ID_META_AI_CONTAINER);
        if (!isFabBox && v instanceof ViewGroup && v.getClass().getName().endsWith("LithoView")) {
            float d = v.getResources().getDisplayMetrics().density;
            int w = v.getWidth();
            int h = v.getHeight();
            if (w > 0 && h > 0 && w <= (int) (320f * d) && h <= (int) (130f * d) && hasMetaAiDesc(v, 0)) {
                isFabBox = true;
            }
        }
        if (isFabBox) {
            if (v.getTranslationY() != ty) {
                v.setTranslationY(ty);
            }
            if (v.getElevation() < elev) {
                v.setElevation(elev);
            }
            ViewParent p = v.getParent();
            if (p instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) p;
                if (vg.indexOfChild(v) != vg.getChildCount() - 1) {
                    v.bringToFront();
                }
            }
            return;
        }
        if (v instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) v;
            if (isList(vg.getClass())) return;
            for (int i = 0; i < vg.getChildCount(); i++) {
                liftAllFabContainers(vg.getChildAt(i), ty, elev, depth + 1);
            }
        }
    }

    private static boolean hasMetaAiDesc(View v, int depth) {
        if (v == null || depth > 4) return false;
        CharSequence cd = v.getContentDescription();
        if (cd != null && cd.toString().contains("Meta AI")) return true;
        if (v instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) v;
            for (int i = 0; i < vg.getChildCount(); i++) {
                if (hasMetaAiDesc(vg.getChildAt(i), depth + 1)) return true;
            }
        }
        return false;
    }

    private static boolean isList(Class<?> cls) {
        Boolean cached = sIsList.get(cls);
        if (cached != null) return cached;
        boolean res = false;
        Class<?> c = cls;
        while (c != null) {
            String n = c.getName();
            if (n.endsWith("RecyclerView") || n.equals("android.widget.AbsListView")) {
                res = true;
                break;
            }
            c = c.getSuperclass();
        }
        sIsList.put(cls, res);
        return res;
    }

    private static void padLists(View v, int padB, int minH, int depth) {
        if (!(v instanceof ViewGroup) || depth > 12 || v.getVisibility() == View.GONE) return;
        ViewGroup vg = (ViewGroup) v;
        if (isList(vg.getClass()) && vg.getHeight() >= minH) {
            if (vg.getPaddingBottom() < padB) {
                vg.setPadding(vg.getPaddingLeft(), vg.getPaddingTop(), vg.getPaddingRight(), padB);
            }
            if (vg.getClipToPadding()) {
                vg.setClipToPadding(false);
            }
            return;
        }
        int n = vg.getChildCount();
        for (int i = 0; i < n; i++) {
            padLists(vg.getChildAt(i), padB, minH, depth + 1);
        }
    }

    private static void noRipple(View v) {
        if (v.getBackground() instanceof RippleDrawable) v.setBackground(null);
        if (v.getForeground() instanceof RippleDrawable) v.setForeground(null);
        if (v instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) v;
            for (int i = 0; i < vg.getChildCount(); i++) {
                noRipple(vg.getChildAt(i));
            }
        }
    }

    private static final class BlurScrimView extends View {
        private final ViewGroup source;
        private final Paint tintPaint = new Paint();
        private final Paint maskPaint = new Paint();
        private RenderNode blurNode;
        private boolean capturing;

        BlurScrimView(Context ctx, ViewGroup source, final View dockRef) {
            super(ctx);
            this.source = source;
            maskPaint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_IN));
            source.getViewTreeObserver().addOnScrollChangedListener(new android.view.ViewTreeObserver.OnScrollChangedListener() {
                @Override
                public void onScrollChanged() {
                    invalidate();
                    if (dockRef != null) dockRef.invalidate();
                }
            });
        }

        @Override
        protected void onDraw(Canvas canvas) {
            if (capturing) return;
            int w = getWidth();
            int h = getHeight();
            if (w <= 0 || h <= 0) return;
            float d = getResources().getDisplayMetrics().density;
            boolean dark = MSplit.isDark(this);

            boolean blurred = false;
            if (Build.VERSION.SDK_INT >= 31 && canvas.isHardwareAccelerated()) {
                try {
                    if (blurNode == null) blurNode = new RenderNode("mblur");
                    int pad = (int) (20f * d);
                    int nw = w;
                    int nh = h + pad;
                    blurNode.setPosition(0, 0, nw, nh);
                    Canvas rc = blurNode.beginRecording(nw, nh);
                    try {
                        rc.drawColor(dark ? 0xFF000000 : 0xFFFFFFFF);
                        float offsetY = -(source.getHeight() - h) + pad;
                        rc.translate(0f, offsetY);
                        capturing = true;
                        try {
                            // Draw ONLY sibling children (never source.draw, which would create a RenderNode cycle!)
                            int cnt = source.getChildCount();
                            for (int i = 0; i < cnt; i++) {
                                View sib = source.getChildAt(i);
                                if (sib == this || sib.getVisibility() != View.VISIBLE) continue;
                                rc.save();
                                rc.translate(sib.getLeft(), sib.getTop());
                                sib.draw(rc);
                                rc.restore();
                            }
                        } finally {
                            capturing = false;
                        }
                    } finally {
                        blurNode.endRecording();
                    }
                    float radius = 4f * d;
                    blurNode.setRenderEffect(RenderEffect.createBlurEffect(radius, radius, Shader.TileMode.CLAMP));

                    int save = canvas.saveLayer(0f, 0f, w, h, null);
                    canvas.save();
                    canvas.translate(0f, -pad);
                    canvas.drawRenderNode(blurNode);
                    canvas.restore();

                    // Feather top edge seamlessly into the conversation list above
                    maskPaint.setShader(new LinearGradient(
                            0f, 0f, 0f, h,
                            new int[]{0x00000000, 0x77000000, 0xDD000000},
                            new float[]{0f, 0.4f, 0.8f},
                            Shader.TileMode.CLAMP));
                    canvas.drawRect(0f, 0f, w, h, maskPaint);
                    canvas.restoreToCount(save);
                    blurred = true;
                } catch (Throwable ignored) {
                    capturing = false;
                }
            }

            // Ultra-light fade so colors stay vivid & refract sharply inside the Liquid Glass capsule
            int[] colors;
            if (blurred) {
                colors = dark
                        ? new int[]{0x00000000, 0x16101014, 0x2E101014}
                        : new int[]{0x00FFFFFF, 0x16FFFFFF, 0x2EFFFFFF};
            } else {
                colors = dark
                        ? new int[]{0x00000000, 0xCC121214, 0xF2121214}
                        : new int[]{0x00FFFFFF, 0xCCFFFFFF, 0xF2FFFFFF};
            }
            tintPaint.setShader(new LinearGradient(
                    0f, 0f, 0f, h, colors, new float[]{0f, 0.4f, 1f}, Shader.TileMode.CLAMP));
            canvas.drawRect(0f, 0f, w, h, tintPaint);
        }
    }
}
