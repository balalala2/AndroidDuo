package com.zsplit.msg;

import android.app.Activity;
import android.app.Application;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.ViewTreeObserver;
import android.widget.TextView;

public final class MSplit implements ViewTreeObserver.OnPreDrawListener {
    private static final int ID_MAIN = 0x7f0b12dc;
    private static final int ID_THREAD = 0x7f0b0c92;

    static boolean sWide;
    private static boolean sCbRegistered;

    final Activity act;
    boolean forced;
    boolean unhidePosted;
    View ph;

    MSplit(Activity act) {
        this.act = act;
    }

    public static void install(Activity act) {
        try {
            Configuration cfg = act.getResources().getConfiguration();
            if (cfg != null && cfg.screenWidthDp >= 600) {
                sWide = true;
            }
            MSplit split = new MSplit(act);
            act.getWindow().getDecorView().getViewTreeObserver().addOnPreDrawListener(split);
            registerCallbacks(act);
            PrefSplit.initEmbedding(act);
        } catch (Throwable ignored) {
        }
    }

    private static void registerCallbacks(Activity act) {
        if (sCbRegistered) return;
        Application app = act.getApplication();
        if (app == null) return;
        sCbRegistered = true;
        app.registerActivityLifecycleCallbacks(new Application.ActivityLifecycleCallbacks() {
            @Override public void onActivityCreated(Activity a, Bundle b) {
                PrefSplit.tryAttach(a);
            }
            @Override public void onActivityStarted(Activity a) {
                PrefSplit.tryAttach(a);
            }
            @Override public void onActivityResumed(Activity a) {}
            @Override public void onActivityPaused(Activity a) {}
            @Override public void onActivityStopped(Activity a) {}
            @Override public void onActivitySaveInstanceState(Activity a, Bundle b) {}
            @Override public void onActivityDestroyed(Activity a) {}
        });
    }

    public static boolean keepVisible(Object fragment) {
        try {
            if (fragment == null) return false;
            boolean wide = sWide;
            if (!wide) {
                try {
                    Object res = fragment.getClass().getMethod("getResources").invoke(fragment);
                    if (res instanceof android.content.res.Resources) {
                        Configuration cfg = ((android.content.res.Resources) res).getConfiguration();
                        if (cfg != null && cfg.screenWidthDp >= 600) {
                            wide = true;
                            sWide = true;
                        }
                    }
                } catch (Throwable ignored) {
                }
            }
            if (wide) {
                String s = fragment.toString();
                return s.contains("tag=main_content_fragment_tag")
                        || s.contains("tag=me_preference_fragment");
            }
        } catch (Throwable ignored) {
        }
        return false;
    }

    private void ensureMainFragmentShown(View anchor) {
        if (unhidePosted) return;
        try {
            Object fm = act.getClass().getMethod("DCY").invoke(act);
            if (fm == null) return;
            Object frag = fm.getClass().getMethod("A0a", String.class).invoke(fm, "main_content_fragment_tag");
            if (frag == null) return;
            Object hidden = frag.getClass().getMethod("isHidden").invoke(frag);
            if (!(hidden instanceof Boolean) || !((Boolean) hidden).booleanValue()) return;

            unhidePosted = true;
            anchor.post(new Runnable() {
                @Override
                public void run() {
                    unhidePosted = false;
                    try {
                        if (!sWide || act.isFinishing() || act.isDestroyed()) return;
                        Object fm2 = act.getClass().getMethod("DCY").invoke(act);
                        if (fm2 == null) return;
                        Object f2 = fm2.getClass().getMethod("A0a", String.class).invoke(fm2, "main_content_fragment_tag");
                        if (f2 == null) return;
                        Object h2 = f2.getClass().getMethod("isHidden").invoke(f2);
                        if (!(h2 instanceof Boolean) || !((Boolean) h2).booleanValue()) return;
                        Class<?> txCls = Class.forName("X.08j", false, act.getClassLoader());
                        Object tx = txCls.getConstructor(fm2.getClass()).newInstance(fm2);
                        Class<?> fragCls = Class.forName("androidx.fragment.app.Fragment", false, act.getClassLoader());
                        txCls.getMethod("A0M", fragCls).invoke(tx, f2);
                        txCls.getMethod("A06").invoke(tx);
                        android.util.Log.i("MSplit", "Un-hid main_content_fragment_tag after unfold -> Inbox real-time resumed");
                    } catch (Throwable t) {
                        android.util.Log.w("MSplit", "ensureMainFragmentShown err: " + t);
                    }
                }
            });
        } catch (Throwable ignored) {
        }
    }

    static boolean isWide(View v) {
        int w = v.getWidth();
        int h = v.getHeight();
        if (w <= 0 || h <= 0) return false;
        float density = v.getResources().getDisplayMetrics().density;
        float wdp = w / density;
        if (wdp >= 600.0f) return true;
        return wdp >= 380.0f && (w * 10 >= h * 8);
    }

    static int leftPaneWidth(View content) {
        int w = (content.getWidth() * 2) / 5;
        float density = content.getResources().getDisplayMetrics().density;
        int max = (int) (420.0f * density);
        return Math.min(w, max);
    }

    static void apply(View v, int width, int leftMargin) {
        ViewGroup.LayoutParams lp = v.getLayoutParams();
        if (lp instanceof ViewGroup.MarginLayoutParams) {
            ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) lp;
            if (mlp.width != width || mlp.leftMargin != leftMargin) {
                mlp.width = width;
                mlp.leftMargin = leftMargin;
                v.setLayoutParams(mlp);
            }
        }
    }

    static View child0(View v) {
        if (v instanceof ViewGroup) {
            ViewGroup vg = (ViewGroup) v;
            if (vg.getChildCount() > 0) return vg.getChildAt(0);
        }
        return null;
    }

    static boolean isDark(View v) {
        return TabFx.themeDark(v);
    }

    @Override
    public boolean onPreDraw() {
        try {
            View main = act.findViewById(ID_MAIN);
            View thread = act.findViewById(ID_THREAD);
            View content = act.findViewById(android.R.id.content);
            if (main == null || thread == null || content == null) return true;

            boolean wide = isWide(content);
            sWide = wide;

            boolean hasThread = false;
            if (thread.getVisibility() == View.VISIBLE) {
                View tc = child0(thread);
                if (tc != null && tc.getVisibility() == View.VISIBLE) {
                    hasThread = true;
                }
            }

            View mc = child0(main);

            if (wide) {
                int lw = leftPaneWidth(content);
                apply(main, lw, 0);
                apply(thread, ViewGroup.LayoutParams.MATCH_PARENT, lw);
                if (hasThread) {
                    if (mc != null && mc.getVisibility() != View.VISIBLE) {
                        mc.setVisibility(View.VISIBLE);
                        forced = true;
                    }
                    ensureMainFragmentShown(main);
                } else {
                    forced = false;
                }
                updatePh(main, !hasThread, lw);
            } else {
                apply(main, ViewGroup.LayoutParams.MATCH_PARENT, 0);
                apply(thread, ViewGroup.LayoutParams.MATCH_PARENT, 0);
                if (forced) {
                    forced = false;
                    if (hasThread && mc != null) {
                        mc.setVisibility(View.GONE);
                    }
                }
                updatePh(main, false, 0);
            }

            MDock.tick(main);
        } catch (Throwable ignored) {
        }
        return true;
    }

    void updatePh(View anchor, boolean show, int leftMargin) {
        if (!show) {
            if (ph != null && ph.getVisibility() != View.GONE) {
                ph.setVisibility(View.GONE);
            }
            return;
        }
        if (ph == null) {
            ViewParent p = anchor.getParent();
            if (!(p instanceof ViewGroup)) return;
            ViewGroup vg = (ViewGroup) p;
            TextView tv = new TextView(vg.getContext());
            tv.setText("Ch\u1ecdn m\u1ed9t cu\u1ed9c tr\u00f2 chuy\u1ec7n");
            tv.setGravity(android.view.Gravity.CENTER);
            tv.setTextSize(16.0f);
            if (isDark(vg)) {
                tv.setBackgroundColor(0xFF000000);
                tv.setTextColor(0xFF9AA0A6);
            } else {
                tv.setBackgroundColor(0xFFFFFFFF);
                tv.setTextColor(0xFF7A8594);
            }
            ViewGroup.MarginLayoutParams lp = new ViewGroup.MarginLayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            vg.addView(tv, 0, lp);
            ph = tv;
        }
        apply(ph, ViewGroup.LayoutParams.MATCH_PARENT, leftMargin);
        if (ph.getVisibility() != View.VISIBLE) {
            ph.setVisibility(View.VISIBLE);
        }
    }
}
