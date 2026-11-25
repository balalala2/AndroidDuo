package com.zsplit.fb;

import android.app.Activity;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;
import java.lang.ref.WeakReference;

public final class FSplit {
    private static final int TAG_INSTALLED = 0x7a5f0001;
    private static final int TAG_BG = 0x7a5f0003;
    private static final int TAG_SURF = 0x7a5f0004;
    private static final int TAG_SCROLL = 0x7a5f0006;
    private static final int ID_TAB_INDICATOR = 0x7f0a201a;
    private static final int ID_TAB_DIVIDER = 0x7f0a2017;
    private static final int ID_TAB_SLOT = 0x7f0a2019;
    private static final int ID_APPBAR = 0x7f0a0173;
    private static final int ID_HEADER = 0x7f0a212e;

    private static WeakReference<View> sHdr;
    private static WeakReference<View> sTabBar;
    private static WeakReference<View> sAppBar;
    private static WeakReference<ViewGroup> sFeedRv;
    private static WeakReference<View> sLastChild0;
    private static int sLastTop0;
    private static int sPadTick;
    private static int sLastSelTab = -1;
    private static long sLastClipMs = 0L;
    private static float sDockHideTarget = 0f;
    private static float sDockHideCur = 0f;
    private static long sLastHideMs = 0L;

    public static void install(Activity act) {
        try {
            if (act == null) return;
            Window w = act.getWindow();
            if (w == null) return;
            View decor = w.peekDecorView();
            if (decor == null) return;
            if (decor.getTag(TAG_INSTALLED) != null) return;
            decor.setTag(TAG_INSTALLED, Boolean.TRUE);
            decor.getViewTreeObserver().addOnGlobalLayoutListener(new LayoutWatcher(decor, act));
            // Drive smooth spring animations + O(1) outer-screen scroll auto-hide on every frame
            decor.getViewTreeObserver().addOnPreDrawListener(new ViewTreeObserver.OnPreDrawListener() {
                @Override
                public boolean onPreDraw() {
                    try {
                        View tabBar = (sTabBar != null) ? sTabBar.get() : null;
                        if (tabBar != null && tabBar.isAttachedToWindow()) {
                            if (tabBar.getBackground() instanceof FGlass) {
                                ((FGlass) tabBar.getBackground()).tick();
                            }
                            syncOuterDockHide(tabBar);
                        }
                    } catch (Throwable ignored) {
                    }
                    return true;
                }
            });
        } catch (Throwable ignored) {
        }
    }

    static void onFeedScrolled(int dy) {
        if (dy > 10) {
            sDockHideTarget = 1f;
        } else if (dy < -10) {
            sDockHideTarget = 0f;
        }
    }

    private static void syncOuterDockHide(View tabBar) {
        if (!(tabBar instanceof LinearLayout)) return;
        LinearLayout ll = (LinearLayout) tabBar;
        if (ll.getOrientation() == LinearLayout.VERTICAL) {
            sDockHideTarget = 0f;
            sDockHideCur = 0f;
            if (ll.getTranslationY() != 0f) ll.setTranslationY(0f);
            if (ll.getAlpha() != 1f) ll.setAlpha(1f);
            return;
        }
        // Obfuscation-proof scroll direction detection via first visible child delta
        ViewGroup feed = (sFeedRv != null) ? sFeedRv.get() : null;
        if (feed != null && feed.isAttachedToWindow() && feed.getChildCount() > 0) {
            View c0 = feed.getChildAt(0);
            View prev = (sLastChild0 != null) ? sLastChild0.get() : null;
            int top0 = c0.getTop();
            if (c0 == prev) {
                int dy = sLastTop0 - top0;
                if (dy != 0) onFeedScrolled(dy);
            }
            sLastChild0 = new WeakReference<>(c0);
            sLastTop0 = top0;
        }
        long now = android.os.SystemClock.uptimeMillis();
        float dt = (sLastHideMs > 0L) ? Math.min(32f, Math.max(4f, now - sLastHideMs)) : 16.67f;
        sLastHideMs = now;
        float k = 1f - (float) Math.pow(0.84, dt / 16.67f);
        float diff = sDockHideTarget - sDockHideCur;
        if (Math.abs(diff) < 0.005f) {
            sDockHideCur = sDockHideTarget;
        } else {
            sDockHideCur += diff * k;
            ll.postInvalidateOnAnimation();
        }
        float d = ll.getResources().getDisplayMetrics().density;
        float wantTy = sDockHideCur * (ll.getHeight() + 36f * d);
        float wantAlpha = 1f - sDockHideCur * 0.95f;
        if (Math.abs(ll.getTranslationY() - wantTy) > 0.4f) {
            ll.setTranslationY(wantTy);
        }
        if (Math.abs(ll.getAlpha() - wantAlpha) > 0.01f) {
            ll.setAlpha(wantAlpha);
        }
    }

    public static boolean isWide(Context ctx) {
        try {
            if (ctx == null) return false;
            if (ctx instanceof Activity) {
                install((Activity) ctx);
            }
            Configuration cfg = ctx.getResources().getConfiguration();
            int w = cfg.screenWidthDp;
            int h = cfg.screenHeightDp;
            if (w >= 600) return true;
            return w >= 380 && (w * 10 >= h * 8);
        } catch (Throwable ignored) {
            return false;
        }
    }

    public static boolean pin(long id) {
        return ((int) (id >>> 32)) == 0x101082a;
    }

    public static void flog(Context ctx, String msg) {
    }

    private static final class LayoutWatcher implements ViewTreeObserver.OnGlobalLayoutListener {
        private final View root;
        private final WeakReference<Activity> actRef;
        private int lastWide = -1;

        LayoutWatcher(View root, Activity act) {
            this.root = root;
            this.actRef = new WeakReference<>(act);
        }

        @Override
        public void onGlobalLayout() {
            try {
                Context ctx = actRef.get();
                if (ctx == null) ctx = root.getContext();
                boolean wide = isWide(ctx);
                int cur = wide ? 1 : 0;
                if (lastWide >= 0 && lastWide != cur) {
                    lastWide = cur;
                    final Activity act = actRef.get();
                    if (act != null && !act.isFinishing() && !act.isDestroyed()) {
                        // Clean single Activity.recreate() ONLY on physical fold/unfold crossing 600dp:
                        // forces Facebook's Litho TopOfFeedTrayRootComponent & Reels to re-measure all
                        // Story tiles uniformly for the new screen width (eliminates uneven/jagged Stories).
                        root.post(new Runnable() {
                            @Override
                            public void run() {
                                try {
                                    if (!act.isFinishing() && !act.isDestroyed()) {
                                        act.recreate();
                                    }
                                } catch (Throwable ignored) {
                                }
                            }
                        });
                        return;
                    }
                }
                lastWide = cur;
                applyLayout(root, wide);
            } catch (Throwable ignored) {
            }
        }
    }

    static void applyLayout(View root, boolean wide) {
        View pager = findPager(root);
        if (pager == null) return;
        View tabBar = (sTabBar != null) ? sTabBar.get() : null;
        if (tabBar == null || !tabBar.isAttachedToWindow()) {
            tabBar = findByName(root, "TabBarContainerLayout", 0);
            if (tabBar != null) sTabBar = new WeakReference<>(tabBar);
        }
        if (!(tabBar instanceof LinearLayout)) return;
        View appBar = root.findViewById(ID_APPBAR);
        if (appBar != null) sAppBar = new WeakReference<>(appBar);
        ViewParent vp = pager.getParent();
        if (!(vp instanceof FrameLayout)) return;
        View pagerParent = (View) vp;

        LinearLayout rail = (LinearLayout) tabBar;
        FrameLayout pagerParentFrame = (FrameLayout) vp;
        float d = rail.getResources().getDisplayMetrics().density;

        // Hide Facebook's old tab bar slot, indicator, and divider inside the top AppBar
        View ind = root.findViewById(ID_TAB_INDICATOR);
        if (ind != null && ind.getVisibility() != View.GONE) ind.setVisibility(View.GONE);
        View div = root.findViewById(ID_TAB_DIVIDER);
        if (div != null && div.getVisibility() != View.GONE) div.setVisibility(View.GONE);

        // Reparent TabBarContainerLayout into full-screen pagerParent FrameLayout so:
        // - Narrow (outer): Gravity.BOTTOM truly pins the Liquid Glass dock to the bottom of the screen!
        // - Wide (inner): Gravity.TOP|START pins the vertical Liquid Glass rail cleanly on the left!
        if (rail.getParent() != pagerParentFrame) {
            ViewParent oldP = rail.getParent();
            if (oldP instanceof ViewGroup) {
                ((ViewGroup) oldP).removeView(rail);
            }
            FrameLayout.LayoutParams flp = new FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    (int) (56.0f * d),
                    Gravity.BOTTOM);
            pagerParentFrame.addView(rail, flp);
        }
        // Collapse the now-empty tab bar slot inside the top AppBar so header is only the Facebook wordmark bar
        View tabSlot = root.findViewById(ID_TAB_SLOT);
        if (tabSlot != null && tabSlot.getVisibility() != View.GONE) {
            tabSlot.setVisibility(View.GONE);
        }

        // Detect if Reels tab is currently active so we can match Z Fold 7's full-bleed dark Reels chrome
        boolean onReels = false;
        for (int i = 0; i < rail.getChildCount(); i++) {
            View c = rail.getChildAt(i);
            if (c.isSelected()) {
                CharSequence cd = c.getContentDescription();
                if (cd != null && cd.toString().toLowerCase().contains("reel")) {
                    onReels = true;
                }
                break;
            }
        }

        // Seamless background on pagerParent AND its parent CoordinatorLayout so Dark Mode has zero unpainted border
        boolean dark = (rail.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK)
                == Configuration.UI_MODE_NIGHT_YES;
        int railBg = (wide && onReels) ? 0xFF000000 : (dark ? 0xFF1C1E21 : 0xFFFFFFFF);
        pagerParentFrame.setBackgroundColor(railBg);
        ViewParent grandP = pagerParentFrame.getParent();
        if (grandP instanceof View) {
            ((View) grandP).setBackgroundColor(railBg);
        }
        pagerParentFrame.setClipChildren(false);
        pagerParentFrame.setClipToPadding(false);

        View hdr = root.findViewById(ID_HEADER);
        if (hdr != null) sHdr = new WeakReference<>(hdr);
        else if (sHdr != null) hdr = sHdr.get();

        int[] parentLoc = new int[2];
        pagerParentFrame.getLocationInWindow(parentLoc);
        int topMargin = 0;
        if (!onReels && hdr != null && hdr.getVisibility() == View.VISIBLE) {
            int[] hLoc = new int[2];
            hdr.getLocationInWindow(hLoc);
            topMargin = (hLoc[1] + hdr.getHeight()) - parentLoc[1];
            if (topMargin < 0) topMargin = 0;
        }

        if (wide) {
            toVerticalGlassRail(rail, d, topMargin);
        } else {
            toBottomGlassDock(rail, d);
        }

        // Keep floating Liquid Glass dock/rail on top of ViewPager
        if (pagerParentFrame.indexOfChild(rail) != pagerParentFrame.getChildCount() - 1) {
            rail.bringToFront();
        }

        // Attach iOS 27 Liquid Glass background/foreground/drag (use Dark Glass while on Reels)
        FGlass glass = FGlass.attach(rail, pager);
        if (glass != null) glass.forceDark = onReels;

        int leftMargin;
        if (wide) {
            leftMargin = (int) (82.0f * d);
            updateHeaderPadding(hdr, leftMargin);
        } else {
            leftMargin = 0;
            updateHeaderPadding(hdr, 0);
        }

        ViewGroup.LayoutParams lp = pager.getLayoutParams();
        if (lp instanceof ViewGroup.MarginLayoutParams) {
            ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) lp;
            if (mlp.leftMargin != leftMargin || mlp.topMargin != topMargin) {
                mlp.leftMargin = leftMargin;
                mlp.topMargin = topMargin;
                pager.setLayoutParams(mlp);
            }
        }
        // Strictly hardware-clip ViewPager to its own bounds so adjacent offscreen tabs NEVER bleed into the left rail column
        if (pager instanceof ViewGroup) {
            ((ViewGroup) pager).setClipChildren(true);
            ((ViewGroup) pager).setClipToPadding(true);
        }
        if (pager.getOutlineProvider() != android.view.ViewOutlineProvider.BOUNDS) {
            pager.setOutlineProvider(android.view.ViewOutlineProvider.BOUNDS);
        }
        if (!pager.getClipToOutline()) {
            pager.setClipToOutline(true);
        }

        if (wide) {
            int curSel = -1;
            for (int i = 0; i < rail.getChildCount(); i++) {
                if (rail.getChildAt(i).isSelected()) { curSel = i; break; }
            }
            syncPager(rail, pager);
            long now = android.os.SystemClock.uptimeMillis();
            if (curSel != sLastSelTab || (now - sLastClipMs) > 350L) {
                sLastSelTab = curSel;
                sLastClipMs = now;
                unalpha(pager, 0);
                clipOffscreenSurfaces(pager);
            }
        } else {
            int curSel = -1;
            for (int i = 0; i < rail.getChildCount(); i++) {
                if (rail.getChildAt(i).isSelected()) { curSel = i; break; }
            }
            if (curSel != sLastSelTab) {
                sLastSelTab = curSel;
                sDockHideTarget = 0f;
            }
            if (sPadTick % 12 == 0) {
                int dockSpace = (int) (84.0f * d);
                padLists(pager, dockSpace, pager.getHeight() / 2, 0);
            }
            sPadTick++;
        }
    }

    private static void toVerticalGlassRail(LinearLayout rail, float d, int headerBottom) {
        if (rail.getOrientation() != LinearLayout.VERTICAL) {
            rail.setOrientation(LinearLayout.VERTICAL);
        }
        if (rail.getMinimumHeight() != 0) {
            rail.setMinimumHeight(0);
        }
        int padV = (int) (4.0f * d);
        if (rail.getPaddingTop() != padV || rail.getPaddingBottom() != padV
                || rail.getPaddingLeft() != 0 || rail.getPaddingRight() != 0) {
            rail.setPadding(0, padV, 0, padV);
        }
        int railW = (int) (64.0f * d);
        int mStart = (int) (10.0f * d);
        // Fixed Y-position across ALL tabs (Home, Reels, Groups, Notifications, Profile, Menu) so the vertical rail never jumps!
        int mTop = (int) (54.0f * d);
        ViewGroup.LayoutParams rlp = rail.getLayoutParams();
        if (rlp instanceof FrameLayout.LayoutParams) {
            FrameLayout.LayoutParams mlp = (FrameLayout.LayoutParams) rlp;
            if (mlp.width != railW || mlp.height != ViewGroup.LayoutParams.WRAP_CONTENT
                    || mlp.leftMargin != mStart || mlp.rightMargin != 0
                    || mlp.topMargin != mTop || mlp.bottomMargin != 0
                    || mlp.gravity != (Gravity.TOP | Gravity.START)) {
                mlp.width = railW;
                mlp.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                mlp.leftMargin = mStart;
                mlp.rightMargin = 0;
                mlp.topMargin = mTop;
                mlp.bottomMargin = 0;
                mlp.gravity = Gravity.TOP | Gravity.START;
                rail.setLayoutParams(mlp);
            }
        }

        int itemH = (int) (56.0f * d);
        int count = rail.getChildCount();
        for (int i = 0; i < count; i++) {
            View child = rail.getChildAt(i);
            if (child.getVisibility() != View.VISIBLE) {
                child.setVisibility(View.VISIBLE);
            }
            if (child.getAlpha() < 0.99f) {
                child.setAlpha(1.0f);
            }
            ViewGroup.LayoutParams clp = child.getLayoutParams();
            if (clp instanceof LinearLayout.LayoutParams) {
                LinearLayout.LayoutParams llp = (LinearLayout.LayoutParams) clp;
                if (llp.width != ViewGroup.LayoutParams.MATCH_PARENT || llp.height != itemH || llp.weight != 0f) {
                    llp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                    llp.height = itemH;
                    llp.weight = 0f;
                    child.setLayoutParams(llp);
                }
            }
        }
    }

    private static void toBottomGlassDock(LinearLayout bar, float d) {
        if (bar.getOrientation() != LinearLayout.HORIZONTAL) {
            bar.setOrientation(LinearLayout.HORIZONTAL);
        }
        if (bar.getMinimumHeight() != 0) {
            bar.setMinimumHeight(0);
        }
        int padH = (int) (4.0f * d);
        if (bar.getPaddingLeft() != padH || bar.getPaddingRight() != padH
                || bar.getPaddingTop() != 0 || bar.getPaddingBottom() != 0) {
            bar.setPadding(padH, 0, padH, 0);
        }
        int barH = (int) (56.0f * d);
        int mH = (int) (12.0f * d);
        int mBot = (int) (14.0f * d);
        ViewGroup.LayoutParams blp = bar.getLayoutParams();
        if (blp instanceof FrameLayout.LayoutParams) {
            FrameLayout.LayoutParams mlp = (FrameLayout.LayoutParams) blp;
            if (mlp.width != ViewGroup.LayoutParams.MATCH_PARENT || mlp.height != barH
                    || mlp.leftMargin != mH || mlp.rightMargin != mH
                    || mlp.topMargin != 0 || mlp.bottomMargin != mBot
                    || mlp.gravity != (Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL)) {
                mlp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                mlp.height = barH;
                mlp.leftMargin = mH;
                mlp.rightMargin = mH;
                mlp.topMargin = 0;
                mlp.bottomMargin = mBot;
                mlp.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                bar.setLayoutParams(mlp);
            }
        }

        int count = bar.getChildCount();
        for (int i = 0; i < count; i++) {
            View child = bar.getChildAt(i);
            if (child.getVisibility() == View.GONE) {
                child.setVisibility(View.VISIBLE);
            }
            ViewGroup.LayoutParams clp = child.getLayoutParams();
            if (clp instanceof LinearLayout.LayoutParams) {
                LinearLayout.LayoutParams llp = (LinearLayout.LayoutParams) clp;
                if (llp.width != 0 || llp.height != ViewGroup.LayoutParams.MATCH_PARENT || llp.weight != 1f) {
                    llp.width = 0;
                    llp.height = ViewGroup.LayoutParams.MATCH_PARENT;
                    llp.weight = 1f;
                    child.setLayoutParams(llp);
                }
            }
        }
    }

    private static View findHeader(View rail) {
        if (rail != null) {
            View cur = rail;
            while (cur != null) {
                ViewParent p = cur.getParent();
                if (p instanceof LinearLayout) {
                    LinearLayout ll = (LinearLayout) p;
                    if (ll.getOrientation() == LinearLayout.VERTICAL && ll.indexOfChild(cur) > 0) {
                        View hdr = ll.getChildAt(0);
                        sHdr = new WeakReference<>(hdr);
                        return hdr;
                    }
                }
                cur = (p instanceof View) ? (View) p : null;
            }
        }
        return (sHdr != null) ? sHdr.get() : null;
    }

    private static void updateHeaderPadding(View hdr, int padLeft) {
        if (hdr != null && hdr.getPaddingLeft() != padLeft) {
            hdr.setPadding(padLeft, hdr.getPaddingTop(), hdr.getPaddingRight(), hdr.getPaddingBottom());
        }
    }

    private static void copyBackground(View src, View dst) {
        if (dst.getTag(TAG_BG) != null) return;
        View cur = src;
        while (cur != null) {
            Drawable bg = cur.getBackground();
            if (bg != null && !(bg instanceof FGlass)) {
                Drawable.ConstantState cs = bg.getConstantState();
                if (cs != null) {
                    dst.setBackground(cs.newDrawable());
                    dst.setTag(TAG_BG, Boolean.TRUE);
                }
                return;
            }
            ViewParent p = cur.getParent();
            cur = (p instanceof View) ? (View) p : null;
        }
    }

    private static void syncPager(ViewGroup rail, View pagerView) {
        try {
            int sel = -1;
            int count = rail.getChildCount();
            for (int i = 0; i < count; i++) {
                if (rail.getChildAt(i).isSelected()) {
                    sel = i;
                    break;
                }
            }
            if (sel < 0) return;

            ViewPager vp = (ViewPager) pagerView;
            if (rail.getChildAt(sel).getVisibility() == View.GONE) {
                View home = rail.getChildAt(0);
                if (home != null) home.performClick();
                if (vp.getCurrentItem() != 0) vp.setCurrentItem(0, false);
                if (vp.getScrollX() != 0) vp.scrollTo(0, 0);
                return;
            }

            PagerAdapter ad = vp.getAdapter();
            if (ad == null || sel >= ad.getCount()) return;
            if (vp.getCurrentItem() != sel) {
                vp.setCurrentItem(sel, false);
                return;
            }
            int pageW = vp.getWidth() - vp.getPaddingLeft() - vp.getPaddingRight() + vp.getPageMargin();
            int wantX = pageW * sel;
            if (vp.getScrollX() != wantX) {
                vp.scrollTo(wantX, 0);
            }
        } catch (Throwable ignored) {
        }
    }

    private static void padLists(View v, int padB, int minH, int depth) {
        if (!(v instanceof ViewGroup) || depth > 14 || v.getVisibility() == View.GONE) return;
        if (v instanceof RecyclerView && v.getHeight() >= minH) {
            RecyclerView rv = (RecyclerView) v;
            sFeedRv = new WeakReference<ViewGroup>(rv);
            if (rv.getPaddingBottom() < padB) {
                rv.setPadding(rv.getPaddingLeft(), rv.getPaddingTop(), rv.getPaddingRight(), padB);
            }
            if (rv.getClipToPadding()) rv.setClipToPadding(false);
            if (rv.getTag(TAG_SCROLL) == null) {
                rv.setTag(TAG_SCROLL, Boolean.TRUE);
                try {
                    rv.addOnScrollListener(new RecyclerView.OnScrollListener() {
                        @Override
                        public void onScrolled(RecyclerView r, int dx, int dy) {
                            onFeedScrolled(dy);
                        }
                    });
                } catch (Throwable ignored) {
                }
            }
            return;
        }
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            padLists(vg.getChildAt(i), padB, minH, depth + 1);
        }
    }

    private static void unalpha(View v, int depth) {
        if (v.getAlpha() < 0.05f && v.getVisibility() == View.VISIBLE) {
            v.setAlpha(1.0f);
        }
        if (v instanceof RecyclerView || !(v instanceof ViewGroup) || depth >= 12) return;
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            unalpha(vg.getChildAt(i), depth + 1);
        }
    }

    private static void clipOffscreenSurfaces(View pager) {
        try {
            int[] loc = new int[2];
            pager.getLocationInWindow(loc);
            int left = loc[0];
            int right = left + pager.getWidth();
            clipSurf(pager, left, right, 0);
        } catch (Throwable ignored) {
        }
    }

    private static void clipSurf(View v, int left, int right, int depth) {
        if (v instanceof SurfaceView) {
            int[] loc = new int[2];
            v.getLocationInWindow(loc);
            int sl = loc[0];
            int sr = sl + v.getWidth();
            boolean inBounds = sl < right && sr > left;
            if (!inBounds) {
                if (v.getVisibility() == View.VISIBLE) {
                    v.setVisibility(View.INVISIBLE);
                    v.setTag(TAG_SURF, Boolean.TRUE);
                }
            } else if (v.getTag(TAG_SURF) != null) {
                v.setTag(TAG_SURF, null);
                v.setVisibility(View.VISIBLE);
            }
            return;
        }
        if (!(v instanceof ViewGroup) || depth >= 40) return;
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            clipSurf(vg.getChildAt(i), left, right, depth + 1);
        }
    }

    static View findPager(View v) {
        if (v instanceof ViewPager) return v;
        if (!(v instanceof ViewGroup) || v instanceof RecyclerView) return null;
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            View r = findPager(vg.getChildAt(i));
            if (r != null) return r;
        }
        return null;
    }

    private static View findByName(View v, String suffix, int depth) {
        if (v.getClass().getName().endsWith(suffix)) return v;
        if (!(v instanceof ViewGroup) || v instanceof RecyclerView || v instanceof ViewPager || depth >= 20) return null;
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            View r = findByName(vg.getChildAt(i), suffix, depth + 1);
            if (r != null) return r;
        }
        return null;
    }

    static void rebind(View v, int depth) {
        if (v instanceof RecyclerView) {
            RecyclerView rv = (RecyclerView) v;
            try {
                RecyclerView.RecycledViewPool pool = rv.getRecycledViewPool();
                if (pool != null) pool.clear();
            } catch (Throwable ignored) {
            }
            RecyclerView.Adapter ad = rv.getAdapter();
            if (ad != null) ad.notifyDataSetChanged();
            rv.invalidateItemDecorations();
            rv.requestLayout();
        }
        if (!(v instanceof ViewGroup) || depth >= 20) return;
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            rebind(vg.getChildAt(i), depth + 1);
        }
    }
}
