package com.zing.zalo.zsplit;

import android.content.res.Configuration;
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
import android.widget.LinearLayout;

public final class ZGlass extends Drawable {
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

    // Clean optical meniscus shader for outer Liquid Glass capsule (subtle dispersion, zero yellow halo)
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

    public View host;
    public View pager;
    public float cur = Float.NaN;
    public float drag = Float.NaN;
    public float vel = 0f;
    public float hold = Float.NaN;
    public long holdT = 0L;
    public final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    public final RectF rect = new RectF();
    private final RectF barRect = new RectF();
    public boolean lens = false;
    public float lensA = 0f;
    public Path path;
    private Path barPath;
    public RenderNode node;
    private RenderNode barBlurNode;
    public RuntimeShader rs;
    private RuntimeShader barRs;
    private boolean scrollHooked;
    private long lastScanMs;
    private long lastTickMs;
    private boolean vivoActive;
    private int vivoStyle = -1;
    private float vivoRadius = -1f;
    private static boolean sVivoProbed;
    private static java.lang.reflect.Method sSetMaterial;
    private static java.lang.reflect.Method sSetCornerRadius;
    private static java.lang.reflect.Method sSetForceUpdateBg;
    private static java.lang.reflect.Method sSetDamageHwLayer;
    static int sAct;

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
            android.util.Log.i("ZGlass", "Vivo native glass unavailable: " + t);
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
                android.util.Log.i("ZGlass", "Vivo native Liquid Glass ENABLED style=" + wantStyle + " r=" + r);
                return true;
            } else {
                android.util.Log.i("ZGlass", "Vivo setMaterial returned false for style=" + wantStyle);
            }
        } catch (Throwable t) {
            android.util.Log.i("ZGlass", "Vivo setMaterial error: " + t);
            sSetMaterial = null;
        }
        vivoActive = false;
        return false;
    }

    public ZGlass(View host, View pager) {
        this.host = host;
        this.pager = pager;
    }

    @Override public int getOpacity() { return PixelFormat.TRANSLUCENT; }
    @Override public void setAlpha(int alpha) {}
    @Override public void setColorFilter(ColorFilter cf) {}

    private static boolean isDark(View v) {
        return (v.getResources().getConfiguration().uiMode & Configuration.UI_MODE_NIGHT_MASK)
                == Configuration.UI_MODE_NIGHT_YES;
    }

    public ViewGroup tabs() {
        if (!(host instanceof ViewGroup)) return null;
        ViewGroup vg = (ViewGroup) host;
        for (int i = vg.getChildCount() - 1; i >= 0; i--) {
            View c = vg.getChildAt(i);
            if (c instanceof LinearLayout) return (ViewGroup) c;
        }
        return null;
    }

    public static int count(ViewGroup vg) {
        int c = 0;
        for (int i = 0; i < vg.getChildCount(); i++) {
            if (vg.getChildAt(i).getVisibility() == View.VISIBLE) c++;
        }
        return c;
    }

    public static View kid(ViewGroup vg, int idx) {
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

    public static float cx(ViewGroup vg, View v) {
        return vg.getLeft() + v.getLeft() + v.getWidth() * 0.5f;
    }

    public float posFromX(float x) {
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

    public float pagerPos() {
        ViewGroup vg = tabs();
        if (vg == null) return Float.NaN;
        if (sAct == 0) {
            sAct = vg.getResources().getIdentifier("iconActive", "id", vg.getContext().getPackageName());
            if (sAct == 0) return Float.NaN;
        }
        int n = count(vg);
        for (int i = 0; i < n; i++) {
            View k = kid(vg, i);
            if (k != null) {
                View act = k.findViewById(sAct);
                if (act != null && act.getVisibility() == View.VISIBLE) return (float) i;
            }
        }
        return Float.NaN;
    }

    public void tick() {
        if (!scrollHooked && pager != null) {
            scrollHooked = true;
            try {
                pager.getViewTreeObserver().addOnScrollChangedListener(new android.view.ViewTreeObserver.OnScrollChangedListener() {
                    @Override
                    public void onScrollChanged() {
                        if (host != null && !vivoActive) host.invalidate();
                    }
                });
            } catch (Throwable ignored) {
            }
        }
        long now = SystemClock.uptimeMillis();
        if (pager != null && host != null && host.getHeight() > 0) {
            fixOuterFold(host);
            if (now - lastScanMs > 900L) {
                lastScanMs = now;
                float d = host.getResources().getDisplayMetrics().density;
                int padB = host.getHeight() + (int) (28f * d);
                padLists(pager, padB, pager.getHeight() / 2, 0);
                mergeOtherSettings(host);
            }
            liftSnackbars(host, pager);
        }
        float dt = (lastTickMs > 0L) ? Math.min(32f, Math.max(4f, now - lastTickMs)) : 16.67f;
        lastTickMs = now;
        float step = dt / 16.67f;

        tick0(step);
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
        // Match Messenger & Facebook: clipToOutline=true at rest prevents VivoBlurRender self-feedback darkening loop!
        boolean wantClip = lensA < 0.05f;
        if (host.getClipToOutline() != wantClip) {
            host.setClipToOutline(wantClip);
            host.invalidateOutline();
        }
    }

    private static final int TAG_OTHER_MENU = 0x7a5f0201;

    public static void prePosition(ViewGroup parent, View child) {
        if (child != null) prePosition(parent, child, child.getLayoutParams());
    }

    public static void prePosition(ViewGroup parent, View child, ViewGroup.LayoutParams lp) {
        try {
            if (parent == null || child == null || !(lp instanceof ViewGroup.MarginLayoutParams)) return;
            int pw = parent.getWidth();
            if (pw <= 0) return;
            float d = parent.getResources().getDisplayMetrics().density;
            if ((pw / d) < 580f) return;
            int zvcId = parent.getResources().getIdentifier("zalo_view_container", "id", parent.getContext().getPackageName());
            if (zvcId == 0 || parent.getId() != zvcId) return;
            if (parent.getChildCount() < 1) return;
            int tabsId = parent.getResources().getIdentifier("sliding_tabs", "id", parent.getContext().getPackageName());
            if (tabsId != 0 && child.findViewById(tabsId) != null) return;
            // Pre-position incoming right-pane view at 40% split BEFORE addView so it NEVER flashes at x=0 under the dock!
            int splitX = Math.min((pw * 2) / 5, (int) (420f * d));
            ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) lp;
            if (mlp.leftMargin == 0) {
                mlp.leftMargin = splitX;
            }
        } catch (Throwable ignored) {
        }
    }

    private static void liftSnackbars(View host, View pager) {
        try {
            int h = host.getHeight();
            if (h <= 0) return;
            View root = host.getRootView();
            if (!(root instanceof ViewGroup)) return;
            float d = host.getResources().getDisplayMetrics().density;
            float lift = -(h + 26f * d);
            // ONLY lift actual SnackbarLayout or explicit "Hoàn tác"/"Undo" banners inside MainTabView/content (NEVER touch ChatView input bar!)
            if (pager instanceof ViewGroup) {
                liftExactSnack((ViewGroup) pager, lift, 18f * d, 0);
            }
            ViewParent hp = host.getParent();
            if (hp instanceof ViewGroup) {
                liftExactSnack((ViewGroup) hp, lift, 18f * d, 0);
            }
        } catch (Throwable ignored) {
        }
    }

    private static void liftExactSnack(ViewGroup vg, float lift, float elev, int depth) {
        if (depth > 5 || vg.getVisibility() != View.VISIBLE) return;
        if (isScrollList(vg)) return;
        int n = vg.getChildCount();
        for (int i = 0; i < n; i++) {
            View ch = vg.getChildAt(i);
            if (ch.getVisibility() != View.VISIBLE) continue;
            String cn = ch.getClass().getName();
            if (cn.contains("Snackbar")) {
                if (ch.getTranslationY() != lift) ch.setTranslationY(lift);
                if (ch.getElevation() < elev) ch.setElevation(elev);
                if (vg.getClipChildren()) vg.setClipChildren(false);
                continue;
            }
            if (ch instanceof android.widget.TextView) {
                CharSequence cs = ((android.widget.TextView) ch).getText();
                if (cs != null) {
                    String s = cs.toString();
                    if ("Hoàn tác".equalsIgnoreCase(s) || "Undo".equalsIgnoreCase(s) || s.contains("Hoàn tác")) {
                        // Lift the banner container (parent of the Hoàn tác button)
                        if (vg.getTranslationY() != lift) vg.setTranslationY(lift);
                        if (vg.getElevation() < elev) vg.setElevation(elev);
                        ViewParent p = vg.getParent();
                        if (p instanceof ViewGroup && ((ViewGroup) p).getClipChildren()) {
                            ((ViewGroup) p).setClipChildren(false);
                        }
                        return;
                    }
                }
            } else if (ch instanceof ViewGroup) {
                liftExactSnack((ViewGroup) ch, lift, elev, depth + 1);
            }
        }
    }

    private static int sLastWideState = -1;

    private static void fixOuterFold(View host) {
        try {
            View root = host.getRootView();
            if (root == null) return;
            float d = host.getResources().getDisplayMetrics().density;
            int rw = root.getWidth();
            if (rw <= 0) return;
            boolean wide = (rw / d) >= 580f;
            int curState = wide ? 1 : 0;
            boolean foldedNow = (sLastWideState == 1 && curState == 0);
            sLastWideState = curState;
            if (wide) return;

            // Walk up to zalo_view_container (FrameLayout holding MainTabView + ChatViews/MyDocuments/Settings)
            ViewParent p = host.getParent();
            ViewGroup zvc = null;
            int zvcId = host.getResources().getIdentifier("zalo_view_container", "id", host.getContext().getPackageName());
            while (p instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) p;
                if (zvcId != 0 && vg.getId() == zvcId) {
                    zvc = vg;
                    break;
                }
                p = vg.getParent();
            }
            if (zvc == null) return;
            boolean changed = false;
            for (int i = 0; i < zvc.getChildCount(); i++) {
                View ch = zvc.getChildAt(i);
                if (ch instanceof android.widget.TextView) continue;
                ViewGroup.LayoutParams lp = ch.getLayoutParams();
                if (lp instanceof ViewGroup.MarginLayoutParams) {
                    ViewGroup.MarginLayoutParams mlp = (ViewGroup.MarginLayoutParams) lp;
                    if (mlp.width > 0 || mlp.leftMargin != 0 || mlp.topMargin != 0 || ch.getTranslationX() != 0f) {
                        mlp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                        mlp.height = ViewGroup.LayoutParams.MATCH_PARENT;
                        mlp.leftMargin = 0;
                        mlp.topMargin = 0;
                        ch.setTranslationX(0f);
                        ch.setLayoutParams(mlp);
                        ch.requestLayout();
                        changed = true;
                    }
                }
            }
            if (foldedNow || changed) {
                final ViewGroup target = zvc;
                target.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        rebindAllLists(target, 0);
                    }
                }, 120L);
            }
        } catch (Throwable ignored) {
        }
    }

    private static void rebindAllLists(View v, int depth) {
        if (!(v instanceof ViewGroup) || depth > 14) return;
        String cn = v.getClass().getName();
        if (cn.endsWith("RecyclerView")) {
            try {
                java.lang.reflect.Method mPool = v.getClass().getMethod("getRecycledViewPool");
                Object pool = mPool.invoke(v);
                if (pool != null) {
                    pool.getClass().getMethod("clear").invoke(pool);
                }
            } catch (Throwable ignored) {}
            try {
                java.lang.reflect.Method mAd = v.getClass().getMethod("getAdapter");
                Object ad = mAd.invoke(v);
                if (ad != null) {
                    ad.getClass().getMethod("notifyDataSetChanged").invoke(ad);
                }
            } catch (Throwable ignored) {}
            v.requestLayout();
        }
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            rebindAllLists(vg.getChildAt(i), depth + 1);
        }
    }

    private static void mergeOtherSettings(View host) {
        try {
            View root = host.getRootView();
            if (!(root instanceof ViewGroup)) return;
            scanSettingsRows((ViewGroup) root, 0);
        } catch (Throwable ignored) {
        }
    }

    private static void scanSettingsRows(ViewGroup vg, int depth) {
        if (depth > 14 || vg.getVisibility() == View.GONE) return;
        // Never traverse ChatView / message lists (keeps chat switching 100% instant and stutter-free)
        String cn = vg.getClass().getName();
        if (cn.contains("ChatView") || cn.contains("MessageList")) return;
        int n = vg.getChildCount();
        for (int i = 0; i < n; i++) {
            View ch = vg.getChildAt(i);
            if (ch instanceof android.widget.TextView) {
                android.widget.TextView tv = (android.widget.TextView) ch;
                CharSequence cs = tv.getText();
                if (cs != null) {
                    String s = cs.toString();
                    if ("Nezumi's Settings".equals(s)) {
                        View row = findClickableRow(ch);
                        if (row != null && row.getVisibility() != View.GONE) {
                            row.setVisibility(View.GONE);
                        }
                    } else if ("Zeldris Patches".equals(s)) {
                        // Rename both the Cá nhân row AND the settings page header bar cleanly to "Cài đặt khác"
                        tv.setText("Cài đặt khác");
                    } else if ("Ẩn Khám phá".equals(s) || "Hide Discovery".equals(s)) {
                        // Inside the unified settings page: append all extra toggle rows directly into this LinearLayout!
                        LinearLayout list = findVerticalList(ch);
                        if (list != null && list.getTag(TAG_OTHER_MENU) == null) {
                            list.setTag(TAG_OTHER_MENU, Boolean.TRUE);
                            appendExtraSettingRows(list);
                        }
                    }
                }
            } else if (ch instanceof ViewGroup) {
                scanSettingsRows((ViewGroup) ch, depth + 1);
            }
        }
    }

    private static View findClickableRow(View tv) {
        View cur = tv;
        for (int i = 0; i < 5 && cur != null; i++) {
            if (cur.isClickable() && cur.hasOnClickListeners()) return cur;
            ViewParent p = cur.getParent();
            cur = (p instanceof View) ? (View) p : null;
        }
        return (tv.getParent() instanceof View) ? (View) tv.getParent() : null;
    }

    private static LinearLayout findVerticalList(View v) {
        ViewParent p = v.getParent();
        LinearLayout best = null;
        for (int i = 0; i < 8 && p instanceof ViewGroup; i++) {
            if (p instanceof LinearLayout && ((LinearLayout) p).getOrientation() == LinearLayout.VERTICAL) {
                LinearLayout ll = (LinearLayout) p;
                if (ll.getChildCount() >= 3) best = ll;
            }
            p = p.getParent();
        }
        return best;
    }

    private static void appendExtraSettingRows(LinearLayout list) {
        try {
            final android.content.Context ctx = list.getContext();
            final android.content.SharedPreferences sp = ctx.getSharedPreferences("nezumi_settings", 0);
            final boolean dark = isDark(list);
            final float d = ctx.getResources().getDisplayMetrics().density;

            String[][] items = new String[][]{
                    {"Mở khóa biểu tượng cảm xúc", "unlock_icon_react"},
                    {"Ẩn trạng thái đang nhập", "hide_text_typing"},
                    {"Ẩn trạng thái đã xem", "hide_read_receipts"},
                    {"Ẩn trạng thái đã nhận", "hide_delivery_receipts"},
                    {"Giữ tin nhắn đã thu hồi", "keep_recalled_messages"},
                    {"Ẩn trạng thái hoạt động", "hide_online_status"},
                    {"Ẩn quảng cáo Bảng tin", "hide_feed_ads"},
                    {"Ẩn quảng cáo trong Tin nhắn", "hide_message_ads"},
                    {"Ẩn Media Box", "hide_media_box"},
                    {"Ẩn Business Box", "hide_business_box"},
                    {"Ẩn tài khoản OA", "hide_oa_messages"},
                    {"Tắt thông báo tài khoản OA", "mute_oa_accounts"}
            };

            int bgColor = dark ? 0xFF1E1E1E : 0xFFFFFFFF;
            int textColor = dark ? 0xFFE8E8E8 : 0xFF1A1A1A;
            int divColor = dark ? 0xFF2E2E2E : 0xFFEAEAEA;
            int padH = (int) (16f * d);
            int padV = (int) (14f * d);

            for (int i = 0; i < items.length; i++) {
                final String title = items[i][0];
                final String key = items[i][1];

                View div = new View(ctx);
                div.setBackgroundColor(divColor);
                LinearLayout.LayoutParams dlp = new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, Math.max(1, (int) (0.75f * d)));
                dlp.leftMargin = padH;
                list.addView(div, dlp);

                LinearLayout row = new LinearLayout(ctx);
                row.setOrientation(LinearLayout.HORIZONTAL);
                row.setGravity(android.view.Gravity.CENTER_VERTICAL);
                row.setBackgroundColor(bgColor);
                row.setPadding(padH, padV, padH, padV);

                android.widget.TextView tv = new android.widget.TextView(ctx);
                tv.setText(title);
                tv.setTextColor(textColor);
                tv.setTextSize(15.5f);
                LinearLayout.LayoutParams tlp = new LinearLayout.LayoutParams(
                        0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f);
                row.addView(tv, tlp);

                final android.widget.Switch sw = new android.widget.Switch(ctx);
                sw.setChecked(sp.getBoolean(key, false));
                sw.setOnCheckedChangeListener(new android.widget.CompoundButton.OnCheckedChangeListener() {
                    @Override
                    public void onCheckedChanged(android.widget.CompoundButton buttonView, boolean isChecked) {
                        sp.edit().putBoolean(key, isChecked).apply();
                    }
                });
                row.addView(sw);

                row.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        sw.setChecked(!sw.isChecked());
                    }
                });

                list.addView(row, new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            }
        } catch (Throwable ignored) {
        }
    }

    private static boolean isScrollList(View v) {
        if (v instanceof android.widget.AbsListView || v instanceof android.widget.ScrollView) return true;
        Class<?> c = v.getClass();
        while (c != null && c != ViewGroup.class && c != Object.class) {
            String n = c.getName();
            if (n.endsWith("RecyclerView") || n.endsWith("NestedScrollView")) return true;
            c = c.getSuperclass();
        }
        return false;
    }

    private static void padLists(View v, int padB, int minH, int depth) {
        if (!(v instanceof ViewGroup) || depth > 14 || v.getVisibility() == View.GONE) return;
        if (isScrollList(v) && v.getHeight() >= minH) {
            ViewGroup vg = (ViewGroup) v;
            if (vg.getPaddingBottom() < padB) {
                vg.setPadding(vg.getPaddingLeft(), vg.getPaddingTop(), vg.getPaddingRight(), padB);
            }
            if (vg.getClipToPadding()) vg.setClipToPadding(false);
            return;
        }
        ViewGroup vg = (ViewGroup) v;
        for (int i = 0; i < vg.getChildCount(); i++) {
            padLists(vg.getChildAt(i), padB, minH, depth + 1);
        }
    }

    private void tick0(float step) {
        float target = pagerPos();
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

    @Override
    public void draw(Canvas canvas) {
        try {
            float d = host.getResources().getDisplayMetrics().density;
            boolean dark = isDark(host);
            Rect b = getBounds();
            float w = b.width();
            float h = b.height();
            if (w <= 0 || h <= 0) return;

            barRect.set(0f, 0f, w, h);
            float r = h * 0.5f;
            // Prefer native OriginOS hardware Liquid Glass engine (same as Album/Clock) when available
            if (ensureVivoGlass(r, dark)) {
                // Zero Android elevation shadow so ChatView transitions never flicker the dock shadow
                if (host.getElevation() != 0f) host.setElevation(0f);
                drawRestingActivePill(canvas, d, dark);
                return;
            }
            if (barPath == null) barPath = new Path();
            barPath.reset();
            barPath.addRoundRect(barRect, r, r, Path.Direction.CW);

            // Real-time iOS 26/27 Liquid Glass outer capsule: Blur + AGSL Refraction of pager behind dock
            boolean blurred = false;
            if (pager != null && Build.VERSION.SDK_INT >= 31 && canvas.isHardwareAccelerated()) {
                try {
                    if (barBlurNode == null) barBlurNode = new RenderNode("zbarblur");
                    int pad = (int) (32f * d);
                    int nw = (int) w + pad * 2;
                    int nh = (int) h + pad * 2;
                    if (nw > 0 && nh > 0) {
                        int[] hLoc = new int[2];
                        int[] pLoc = new int[2];
                        host.getLocationOnScreen(hLoc);
                        pager.getLocationOnScreen(pLoc);
                        float dx = (pLoc[0] - hLoc[0]) + pad - pager.getScrollX();
                        float dy = (pLoc[1] - hLoc[1]) + pad - pager.getScrollY();

                        barBlurNode.setPosition(0, 0, nw, nh);
                        Canvas rc = barBlurNode.beginRecording(nw, nh);
                        try {
                            rc.drawColor(dark ? 0xFF101014 : 0xFFF5F6FA);
                            rc.translate(dx, dy);
                            pager.draw(rc);
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

            // iOS 26/27 diagonal specular catchlight rim
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
            drawRestingActivePill(canvas, d, dark);
        } catch (Throwable ignored) {
        }
    }

    private void drawRestingActivePill(Canvas canvas, float d, boolean dark) {
        if (lensA >= 0.95f) return;
        float pr = geom(d);
        if (pr < 0f) return;
        float restAlpha = 1f - lensA;
        paint.setShader(null);
        paint.clearShadowLayer();
        paint.setStyle(Paint.Style.FILL);
        paint.setColor(dark ? 0x2EFFFFFF : 0x62FFFFFF);
        paint.setAlpha((int) ((dark ? 0x2E : 0x62) * restAlpha));
        canvas.drawRoundRect(rect, pr, pr, paint);

        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(1.0f * d);
        paint.setColor(dark ? 0x44FFFFFF : 0xCCFFFFFF);
        paint.setAlpha((int) ((dark ? 0x44 : 0xCC) * restAlpha));
        rect.inset(0.5f * d, 0.5f * d);
        canvas.drawRoundRect(rect, Math.max(0f, pr - 0.5f * d), Math.max(0f, pr - 0.5f * d), paint);
        paint.setStyle(Paint.Style.FILL);
        paint.setAlpha(255);
    }

    public static void grad(Paint p, float y0, float y1, int c0, int c1) {
        p.setShader(new LinearGradient(0f, y0, 0f, y1, c0, c1, Shader.TileMode.CLAMP));
    }

    public float geom(float d) {
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

        float c0 = cx(vg, v0);
        float c1 = cx(vg, v1);
        float centerX = c0 + (c1 - c0) * f;
        float w0 = v0.getWidth();
        float w1 = v1.getWidth();
        float cellW = w0 + (w1 - w0) * f;

        float stretch = 1f + Math.min(Math.abs(vel) * 6f, 0.22f);
        // Exact 4dp concentric margin on top, bottom, left, and right at rest
        float pad = 4f * d;
        float restW = cellW - 2f * pad;
        float lensW = cellW * 1.42f * stretch;
        float pillW = restW + (lensW - restW) * lensA;

        float insetY = (2f * pad) - 18f * d * lensA;
        float w = getBounds().width();
        float h = getBounds().height();
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

    public void fore(Canvas canvas) {
        try {
            // At rest, drawRestingActivePill() already drew the active pill cleanly BEHIND icons/badges with zero shadowLayer flicker.
            // fore() only draws the magnifying liquid lens while actively dragging/gliding!
            if (lensA < 0.03f) return;
            float d = host.getResources().getDisplayMetrics().density;
            boolean dark = isDark(host);
            float r = geom(d);
            if (r < 0f) return;

            if (path == null) path = new Path();
            path.reset();
            path.addRoundRect(rect, r, r, Path.Direction.CW);

            paint.setShader(null);
            paint.setStyle(Paint.Style.FILL);

            // Diffused outer glass shadow (clipped outside pill)
            canvas.save();
            canvas.clipOutPath(path);
            paint.setColor(dark ? 0xFF202026 : 0xFFFFFFFF);
            paint.setAlpha(255);
            int shadowA = (int) (14f + 38f * lensA);
            paint.setShadowLayer((8f + 6f * lensA) * d, 0f, (1.5f + 2f * lensA) * d, shadowA << 24);
            canvas.drawRoundRect(rect, r, r, paint);
            paint.clearShadowLayer();
            canvas.restore();

            // Interior clipped to active Liquid Glass pill
            canvas.saveLayerAlpha(rect, 255);
            canvas.clipPath(path);

            if (lensA > 0.03f) {
                int lensBg = dark ? 0xD8222228 : 0xD8F8F9FC;
                if (!refract(canvas, rect, r, lensBg)) {
                    ViewGroup vg = tabs();
                    if (vg != null) {
                        canvas.save();
                        float sc = 1f + 0.16f * lensA;
                        canvas.scale(sc, sc, rect.centerX(), rect.centerY());
                        canvas.translate(vg.getLeft(), vg.getTop());
                        vg.draw(canvas);
                        canvas.restore();
                    }
                }
            }

            // Luminous translucent glass fill
            paint.setColor(dark ? 0x2EFFFFFF : 0x45FFFFFF);
            canvas.drawRoundRect(rect, r, r, paint);

            // Top specular dome sheen
            grad(paint, rect.top, rect.centerY(),
                    dark ? 0x2CFFFFFF : 0x80FFFFFF,
                    0x00FFFFFF);
            canvas.drawRoundRect(rect, r, r, paint);
            paint.setShader(null);

            // Outer hairline + bright diagonal specular rim
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

    public boolean refract(Canvas canvas, RectF box, float radius, int bgColor) {
        try {
            if (!canvas.isHardwareAccelerated() || Build.VERSION.SDK_INT < 33) return false;
            ViewGroup vg = tabs();
            if (vg == null) return false;
            if (node == null) node = new RenderNode("zlens");
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
                rc.translate(vg.getLeft(), vg.getTop());
                vg.draw(rc);
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
            return false;
        }
    }
}
