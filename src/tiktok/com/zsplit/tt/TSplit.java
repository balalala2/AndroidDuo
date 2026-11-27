package com.zsplit.tt;

import android.app.Activity;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.os.Build;
import android.util.DisplayMetrics;
import android.view.WindowManager;
import android.view.WindowMetrics;

public final class TSplit {
    private static final int MIN_WIDTH_DP = 580;

    private TSplit() {}

    public static boolean shouldSplit(Activity act, Configuration cfg) {
        if (act == null || act.isFinishing() || act.isDestroyed()) {
            return false;
        }
        try {
            if (Build.VERSION.SDK_INT >= 24) {
                if (act.isInMultiWindowMode() || act.isInPictureInPictureMode()) {
                    return false;
                }
            }
            int wDp = (cfg != null) ? cfg.screenWidthDp : 0;
            if (wDp <= 0 && Build.VERSION.SDK_INT >= 30) {
                DisplayMetrics dm = act.getResources().getDisplayMetrics();
                if (dm != null && dm.density > 0f) {
                    WindowManager wm = act.getWindowManager();
                    if (wm != null) {
                        WindowMetrics metrics = wm.getCurrentWindowMetrics();
                        Rect bounds = metrics.getBounds();
                        wDp = Math.round(bounds.width() / dm.density);
                    }
                }
            }
            if (wDp <= 0) {
                Configuration resCfg = act.getResources().getConfiguration();
                if (resCfg != null) {
                    wDp = resCfg.screenWidthDp;
                }
            }
            return wDp >= MIN_WIDTH_DP;
        } catch (Throwable ignored) {
            return false;
        }
    }
}
