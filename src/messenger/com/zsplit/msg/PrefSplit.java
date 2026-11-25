package com.zsplit.msg;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import android.util.Pair;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.WindowMetrics;
import android.widget.TextView;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;
import java.util.WeakHashMap;
import java.util.function.Predicate;

final class PrefSplit implements ViewTreeObserver.OnPreDrawListener {
    private static final String PREF_ACT = "com.facebook.messaging.settings.mesettings.surface.MessengerMePreferenceActivity";
    private static final String MAIN_ACT = "com.facebook.messenger.neue.MainActivity";
    private static final int ID_LEFT = 0x7f0b0b08;
    private static final WeakHashMap<Activity, PrefSplit> sAttached = new WeakHashMap<>();
    private static boolean sEmbedInit;

    private final Activity act;
    private View ph;
    private View divider;

    private PrefSplit(Activity act) {
        this.act = act;
    }

    static void initEmbedding(Activity act) {
        if (sEmbedInit) return;
        sEmbedInit = true;
        try {
            Class<?> provCls = Class.forName("androidx.window.extensions.WindowExtensionsProvider");
            Object ext = provCls.getMethod("getWindowExtensions").invoke(null);
            if (ext == null) return;
            Object emb = ext.getClass().getMethod("getActivityEmbeddingComponent").invoke(ext);
            if (emb == null) return;

            final float density = act.getResources().getDisplayMetrics().density;

            Predicate<Pair<Activity, Activity>> pairPred = new Predicate<Pair<Activity, Activity>>() {
                @Override
                public boolean test(Pair<Activity, Activity> p) {
                    if (p == null || p.first == null || p.second == null) return false;
                    String a = p.first.getClass().getName();
                    String b = p.second.getClass().getName();
                    return PREF_ACT.equals(a) && !PREF_ACT.equals(b) && !MAIN_ACT.equals(b);
                }
            };

            Predicate<Pair<Activity, Intent>> intentPred = new Predicate<Pair<Activity, Intent>>() {
                @Override
                public boolean test(Pair<Activity, Intent> p) {
                    if (p == null || p.first == null || p.second == null) return false;
                    if (!PREF_ACT.equals(p.first.getClass().getName())) return false;
                    if (p.second.getComponent() != null) {
                        String cls = p.second.getComponent().getClassName();
                        if (PREF_ACT.equals(cls) || MAIN_ACT.equals(cls)) return false;
                    }
                    return true;
                }
            };

            Predicate<WindowMetrics> metricsPred = new Predicate<WindowMetrics>() {
                @Override
                public boolean test(WindowMetrics wm) {
                    if (wm == null) return false;
                    int w = wm.getBounds().width();
                    int h = wm.getBounds().height();
                    if (w <= 0 || h <= 0) return false;
                    float wdp = w / density;
                    return wdp >= 600.0f || (wdp >= 380.0f && w * 10 >= h * 8);
                }
            };

            Class<?> builderCls = Class.forName("androidx.window.extensions.embedding.SplitPairRule$Builder");
            Constructor<?> ctor = builderCls.getConstructor(Predicate.class, Predicate.class, Predicate.class);
            Object builder = ctor.newInstance(pairPred, intentPred, metricsPred);

            // Configure 40/60 split attributes
            try {
                Class<?> ratioCls = Class.forName("androidx.window.extensions.embedding.SplitAttributes$SplitType$RatioSplitType");
                Object ratio = ratioCls.getConstructor(float.class).newInstance(0.4f);
                Class<?> attrBuilderCls = Class.forName("androidx.window.extensions.embedding.SplitAttributes$Builder");
                Object attrBuilder = attrBuilderCls.getConstructor().newInstance();
                Class<?> splitTypeCls = Class.forName("androidx.window.extensions.embedding.SplitAttributes$SplitType");
                attrBuilderCls.getMethod("setSplitType", splitTypeCls).invoke(attrBuilder, ratio);
                attrBuilderCls.getMethod("setLayoutDirection", int.class).invoke(attrBuilder, 3); // LOCALE
                Object attrs = attrBuilderCls.getMethod("build").invoke(attrBuilder);
                Class<?> attrCls = Class.forName("androidx.window.extensions.embedding.SplitAttributes");
                builderCls.getMethod("setDefaultSplitAttributes", attrCls).invoke(builder, attrs);
            } catch (Throwable ignored) {
                try {
                    builderCls.getMethod("setSplitRatio", float.class).invoke(builder, 0.4f);
                } catch (Throwable ignored2) {
                }
            }

            try { builderCls.getMethod("setShouldClearTop", boolean.class).invoke(builder, true); } catch (Throwable ignored) {}
            try { builderCls.getMethod("setFinishPrimaryWithSecondary", int.class).invoke(builder, 0); } catch (Throwable ignored) {}
            try { builderCls.getMethod("setFinishSecondaryWithPrimary", int.class).invoke(builder, 1); } catch (Throwable ignored) {}

            Object rule = builderCls.getMethod("build").invoke(builder);
            Set<Object> rules = new HashSet<>(Collections.singleton(rule));
            Method setRules = emb.getClass().getMethod("setEmbeddingRules", Set.class);
            setRules.invoke(emb, rules);
            Log.i("MSplit", "ActivityEmbedding rule registered for Settings");
        } catch (Throwable t) {
            Log.w("MSplit", "ActivityEmbedding init failed: " + t);
        }
    }

    static void tryAttach(Activity act) {
        try {
            if (act == null || !PREF_ACT.equals(act.getClass().getName())) return;
            initEmbedding(act);
            if (sAttached.containsKey(act)) return;
            if (act.getWindow() == null || act.getWindow().getDecorView() == null) return;
            PrefSplit ps = new PrefSplit(act);
            sAttached.put(act, ps);
            act.getWindow().getDecorView().getViewTreeObserver().addOnPreDrawListener(ps);
        } catch (Throwable ignored) {
        }
    }

    @Override
    public boolean onPreDraw() {
        try {
            View rawContent = act.findViewById(android.R.id.content);
            if (!(rawContent instanceof ViewGroup)) return true;
            ViewGroup content = (ViewGroup) rawContent;
            View left = act.findViewById(ID_LEFT);
            if (left == null) return true;

            View leftHost = left;
            while (leftHost.getParent() instanceof View && leftHost.getParent() != content) {
                leftHost = (View) leftHost.getParent();
            }
            if (leftHost.getParent() != content) return true;

            boolean wide = MSplit.isWide(content);
            MSplit.sWide = wide;

            if (wide) {
                int lw = MSplit.leftPaneWidth(content);
                MSplit.apply(leftHost, lw, 0);
                if (leftHost.getVisibility() != View.VISIBLE) {
                    leftHost.setVisibility(View.VISIBLE);
                }

                boolean hasDetail = false;
                for (int i = 0; i < content.getChildCount(); i++) {
                    View c = content.getChildAt(i);
                    if (c == leftHost || c == ph || c == divider) continue;
                    boolean nonEmpty = c.getVisibility() == View.VISIBLE
                            && (!(c instanceof ViewGroup) || ((ViewGroup) c).getChildCount() > 0);
                    if (nonEmpty) {
                        hasDetail = true;
                        MSplit.apply(c, ViewGroup.LayoutParams.MATCH_PARENT, lw);
                    }
                }

                updatePh(content, !hasDetail, lw);
                updateDivider(content, true, lw);
            } else {
                MSplit.apply(leftHost, ViewGroup.LayoutParams.MATCH_PARENT, 0);
                for (int i = 0; i < content.getChildCount(); i++) {
                    View c = content.getChildAt(i);
                    if (c == leftHost || c == ph || c == divider) continue;
                    MSplit.apply(c, ViewGroup.LayoutParams.MATCH_PARENT, 0);
                }
                updatePh(content, false, 0);
                updateDivider(content, false, 0);
            }
        } catch (Throwable ignored) {
        }
        return true;
    }

    private void updatePh(ViewGroup content, boolean show, int leftMargin) {
        if (!show) {
            if (ph != null && ph.getVisibility() != View.GONE) ph.setVisibility(View.GONE);
            return;
        }
        if (ph == null) {
            TextView tv = new TextView(content.getContext());
            tv.setText("Ch\u1ecdn m\u1ed9t m\u1ee5c c\u00e0i \u0111\u1eb7t");
            tv.setGravity(Gravity.CENTER);
            tv.setTextSize(16.0f);
            if (MSplit.isDark(content)) {
                tv.setBackgroundColor(0xFF000000);
                tv.setTextColor(0xFF9AA0A6);
            } else {
                tv.setBackgroundColor(0xFFFFFFFF);
                tv.setTextColor(0xFF7A8594);
            }
            ViewGroup.MarginLayoutParams lp = new ViewGroup.MarginLayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            content.addView(tv, 0, lp);
            ph = tv;
        }
        MSplit.apply(ph, ViewGroup.LayoutParams.MATCH_PARENT, leftMargin);
        if (ph.getVisibility() != View.VISIBLE) ph.setVisibility(View.VISIBLE);
    }

    private void updateDivider(ViewGroup content, boolean show, int leftMargin) {
        if (!show) {
            if (divider != null && divider.getVisibility() != View.GONE) divider.setVisibility(View.GONE);
            return;
        }
        if (divider == null) {
            View v = new View(content.getContext());
            v.setBackgroundColor(MSplit.isDark(content) ? 0x22FFFFFF : 0x18000000);
            int w = Math.max(1, (int) content.getResources().getDisplayMetrics().density);
            ViewGroup.MarginLayoutParams lp = new ViewGroup.MarginLayoutParams(
                    w, ViewGroup.LayoutParams.MATCH_PARENT);
            content.addView(v, lp);
            divider = v;
        }
        int w = Math.max(1, (int) content.getResources().getDisplayMetrics().density);
        MSplit.apply(divider, w, leftMargin);
        if (divider.getVisibility() != View.VISIBLE) divider.setVisibility(View.VISIBLE);
    }
}
