package com.zsplit.msg;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.content.res.Configuration;
import android.os.SystemClock;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import java.util.WeakHashMap;

/**
 * Android Duo dock helpers shared by YouTube / Messenger / Facebook:
 *  - snapshots of every tab in its SELECTED look (filled icon), used inside the droplet instead of the outline icon;
 *  - greys out the currently selected tab while the droplet is moving away from it (like YouTube / Zalo).
 */
final class TabFx {
    private static long sDarkT;
    private static boolean sDark;
    private static int sDarkLog = -1;

    /**
     * Dark if the APP's theme is dark (light primary text), so labels/glass follow the app's own dark mode
     * even when the system is light (and vice versa). Falls back to the system night flag.
     */
    static boolean themeDark(View v) {
        long now = SystemClock.uptimeMillis();
        if (now - sDarkT < 400L && sDarkT != 0L) return sDark;
        sDarkT = now;
        boolean sys = (v.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK)
                == Configuration.UI_MODE_NIGHT_YES;
        boolean dark = sys;
        int c = 0;
        try {
            TypedValue tv = new TypedValue();
            if (v.getContext().getTheme().resolveAttribute(android.R.attr.textColorPrimary, tv, true)) {
                if (tv.resourceId != 0) c = v.getContext().getColorStateList(tv.resourceId).getDefaultColor();
                else if (tv.type >= TypedValue.TYPE_FIRST_COLOR_INT && tv.type <= TypedValue.TYPE_LAST_COLOR_INT) c = tv.data;
                if (c != 0) {
                    float lum = 0.299f * ((c >> 16) & 255) + 0.587f * ((c >> 8) & 255) + 0.114f * (c & 255);
                    dark = lum > 128f;
                }
            }
        } catch (Throwable ignored) {
        }
        sDark = dark;
        int code = (dark ? 1 : 0) | (sys ? 2 : 0);
        if (code != sDarkLog) {
            sDarkLog = code;
            android.util.Log.i("DuoDock", "dark=" + dark + " sys=" + sys + " textPrimary=" + Integer.toHexString(c));
        }
        return dark;
    }

    private static final class Snap {
        Bitmap bmp;
        int w, h;
        boolean dark;
        boolean real;
        long t;
    }

    private final WeakHashMap<View, Snap> snaps = new WeakHashMap<>();
    private final WeakHashMap<View, Integer> grayed = new WeakHashMap<>();
    private final WeakHashMap<View, Float> grayT = new WeakHashMap<>();
    private final Paint bmpPaint = new Paint(Paint.FILTER_BITMAP_FLAG | Paint.ANTI_ALIAS_FLAG);
    private long lastPrewarm;
    private int gray;
    private int grayKey = -1;

    /** Call every frame. Only snapshots while the dock is at rest (no droplet, no drag). */
    void refresh(ViewGroup tabs, boolean dark, boolean atRest) {
        if (tabs == null || !atRest) return;
        long now = SystemClock.uptimeMillis();
        boolean prewarmed = false;
        View unsel = null;
        for (int i = 0; i < tabs.getChildCount(); i++) {
            View tab = tabs.getChildAt(i);
            if (tab.getVisibility() != View.VISIBLE) continue;
            int w = tab.getWidth(), h = tab.getHeight();
            if (w <= 0 || h <= 0) continue;
            Snap s = snaps.get(tab);
            boolean stale = s == null || s.w != w || s.h != h || s.dark != dark;
            if (tab.isSelected()) {
                if (grayed.containsKey(tab)) continue;
                if (stale || !s.real || now - s.t > 1200L) snap(tab, true, dark, now);
            } else {
                if (unsel == null) unsel = tab;
                if (stale && !prewarmed && now - lastPrewarm > 120L) {
                    prewarmed = true;
                    lastPrewarm = now;
                    prewarm(tab, dark, now);
                }
            }
        }
        int key = dark ? 1 : 0;
        if (unsel != null && grayKey != key) {
            int c = sampleColor(unsel);
            gray = c != 0 ? c : (dark ? 0xFFB0B3B8 : 0xFF65676B);
            grayKey = key;
        }
    }

    private void snap(View tab, boolean real, boolean dark, long now) {
        Snap s = snaps.get(tab);
        if (s == null) {
            s = new Snap();
            snaps.put(tab, s);
        }
        s.w = tab.getWidth();
        s.h = tab.getHeight();
        s.dark = dark;
        s.real = real;
        s.t = now;
        try {
            Bitmap b = (s.bmp != null && !s.bmp.isRecycled() && s.bmp.getWidth() == s.w && s.bmp.getHeight() == s.h)
                    ? s.bmp : Bitmap.createBitmap(s.w, s.h, Bitmap.Config.ARGB_8888);
            b.eraseColor(0);
            Canvas c = new Canvas(b);
            tab.draw(c);
            s.bmp = b;
        } catch (Throwable t) {
            s.bmp = null; // e.g. hardware bitmap avatar: fall back to drawing the live tab
        }
    }

    /** Draw an unselected tab once in its selected state to learn its filled icon. */
    private void prewarm(View tab, boolean dark, long now) {
        boolean sel = tab.isSelected();
        boolean act = tab.isActivated();
        try {
            tab.setSelected(true);
            tab.setActivated(true);
            snap(tab, false, dark, now);
        } catch (Throwable ignored) {
        } finally {
            try {
                tab.setActivated(act);
                tab.setSelected(sel);
            } catch (Throwable ignored) {
            }
        }
    }

    private static int sampleColor(View tab) {
        try {
            int w = tab.getWidth(), h = tab.getHeight();
            if (w <= 0 || h <= 0) return 0;
            float sc = Math.min(1f, 64f / Math.max(w, h));
            int bw = Math.max(1, (int) (w * sc)), bh = Math.max(1, (int) (h * sc));
            Bitmap b = Bitmap.createBitmap(bw, bh, Bitmap.Config.ARGB_8888);
            Canvas c = new Canvas(b);
            c.scale(sc, sc);
            tab.draw(c);
            long r = 0, g = 0, bl = 0, n = 0;
            for (int y = 0; y < bh; y++) {
                for (int x = 0; x < bw; x++) {
                    int p = b.getPixel(x, y);
                    if ((p >>> 24) < 200) continue;
                    int pr = (p >> 16) & 255, pg = (p >> 8) & 255, pb = p & 255;
                    if (Math.max(pr, Math.max(pg, pb)) - Math.min(pr, Math.min(pg, pb)) > 40) continue;
                    r += pr; g += pg; bl += pb; n++;
                }
            }
            b.recycle();
            if (n < 4) return 0;
            return 0xFF000000 | ((int) (r / n) << 16) | ((int) (g / n) << 8) | (int) (bl / n);
        } catch (Throwable t) {
            return 0;
        }
    }

    /** Draw all tabs (in tabs-local coordinates) using the selected-look snapshots where available. */
    boolean drawSelected(ViewGroup tabs, Canvas rc) {
        boolean any = false;
        for (int i = 0; i < tabs.getChildCount(); i++) {
            View tab = tabs.getChildAt(i);
            if (tab.getVisibility() != View.VISIBLE) continue;
            rc.save();
            rc.translate(tab.getLeft() - tabs.getScrollX(), tab.getTop() - tabs.getScrollY());
            if (!tab.getMatrix().isIdentity()) rc.concat(tab.getMatrix());
            Snap s = snaps.get(tab);
            if (s != null && s.bmp != null && !s.bmp.isRecycled() && s.w == tab.getWidth() && s.h == tab.getHeight()) {
                rc.drawBitmap(s.bmp, 0f, 0f, bmpPaint);
                any = true;
            } else {
                tab.draw(rc);
            }
            rc.restore();
        }
        return any;
    }

    /** Grey the selected tab while the droplet is away from it (t = droplet strength 0..1). */
    void grayActive(ViewGroup tabs, float t) {
        if (tabs == null) return;
        int g = gray != 0 ? gray : 0xFF65676B;
        float gr = (g >> 16) & 255, gg = (g >> 8) & 255, gb = g & 255;
        for (int i = 0; i < tabs.getChildCount(); i++) {
            View tab = tabs.getChildAt(i);
            boolean want = t > 0.02f && tab.isSelected() && tab.getVisibility() == View.VISIBLE;
            if (want) {
                Float last = grayT.get(tab);
                if (last != null && Math.abs(last - t) < 0.02f) continue;
                if (!grayed.containsKey(tab)) grayed.put(tab, tab.getLayerType());
                float k = 1f - t;
                ColorMatrix cm = new ColorMatrix(new float[]{
                        k, 0, 0, 0, gr * t,
                        0, k, 0, 0, gg * t,
                        0, 0, k, 0, gb * t,
                        0, 0, 0, 1, 0});
                Paint p = new Paint();
                p.setColorFilter(new ColorMatrixColorFilter(cm));
                tab.setLayerType(View.LAYER_TYPE_HARDWARE, p);
                grayT.put(tab, t);
            } else if (grayed.containsKey(tab)) {
                Integer orig = grayed.remove(tab);
                grayT.remove(tab);
                tab.setLayerType(orig != null ? orig : View.LAYER_TYPE_NONE, null);
            }
        }
    }
}
