#!/usr/bin/env python3
"""
Render Apple Icon Composer-style Liquid Glass icons for TikTok & Zalo
strictly preserving 100% of the original iOS/Android glyph geometry.
"""
import os
import numpy as np
from PIL import Image, ImageFilter, ImageDraw

WORK = os.environ.get("ICONS_WORK", os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "..", "Antigravity-ZSplit", "icons-work")))
OUT  = os.path.join(WORK, "out")
os.makedirs(OUT, exist_ok=True)


def blur_arr(arr: np.ndarray, radius: float) -> np.ndarray:
    """Gaussian blur a float32 [0..1] 2D array using PIL (fast & smooth)."""
    im = Image.fromarray(np.clip(arr * 255.0, 0, 255).astype(np.uint8), mode="L")
    im = im.filter(ImageFilter.GaussianBlur(radius=radius))
    return np.asarray(im, dtype=np.float32) / 255.0


def blur_rgba(arr: np.ndarray, radius: float) -> np.ndarray:
    im = Image.fromarray(np.clip(arr * 255.0, 0, 255).astype(np.uint8), mode="RGBA")
    im = im.filter(ImageFilter.GaussianBlur(radius=radius))
    return np.asarray(im, dtype=np.float32) / 255.0


def apply_liquid_glass_to_glyph(
    rgb: np.ndarray,
    alpha: np.ndarray,
    size: int = 432,
    rim_width: float = 3.2,
    glow_radius: float = 15.0,
    glow_alpha: float = 0.36,
    glow_offset_y: float = 4.5,
    specular_strength: float = 0.90,
    inner_depth: float = 0.04,
    frosted_lift_top: float = 0.16,
    frosted_lift_bottom: float = 0.32,
    edge_bloom: float = 0.28,
    colored_glow: np.ndarray = None,
) -> np.ndarray:
    """
    Apply Apple Icon Composer Liquid Glass optical shading to an exact glyph (rgb [H,W,3], alpha [H,W] in 0..1)
    WITHOUT modifying its silhouette at all.
    Calibrated directly against YouTube (yt_Vd3.png) & Messenger (msg_lb2.png) v2.2 reference icons:
      1. Soft luminous colored ambient glow / drop shadow underneath
      2. Translucent milky white glaze ("làm nhạt màu"): ~16% white lift at top -> ~32% luminous caustic lift at bottom
      3. Broad luminous frosted inner-bevel rim + bright 45-degree diagonal specular flare ("lóe sáng")
    """
    H, W = alpha.shape
    sc = size / 432.0

    # 1. Soft ambient colored glow behind glyph
    if colored_glow is None:
        colored_glow = rgb.copy()
    glow_src = np.dstack([colored_glow, alpha])
    glow_blur = blur_rgba(glow_src, glow_radius * sc)
    dy = int(round(glow_offset_y * sc))
    glow_shifted = np.zeros_like(glow_blur)
    if dy > 0:
        glow_shifted[dy:, :, :] = glow_blur[:-dy, :, :]
    else:
        glow_shifted = glow_blur
    glow_shifted[:, :, 3] = np.clip(glow_shifted[:, :, 3] * glow_alpha, 0.0, 1.0)

    # 2. Multi-scale inward bevel fields & surface normals from alpha mask
    a_crisp  = blur_arr(alpha, rim_width * 0.85 * sc)
    a_smooth = blur_arr(alpha, rim_width * 1.65 * sc)
    a_wide   = blur_arr(alpha, rim_width * 3.6 * sc)

    # Crisp glass meniscus highlight right inside edge
    inner_rim = np.clip((alpha - a_crisp) * 3.1, 0.0, 1.0) * alpha
    # Broad luminous frosted edge band (matches YT/MSG 6px glowing perimeter)
    mid_rim   = np.clip((alpha - a_smooth) * 2.3, 0.0, 1.0) * alpha
    # Soft inner light scatter / bloom bleeding inward from edges
    wide_rim  = np.clip((alpha - a_wide) * 1.6, 0.0, 1.0) * alpha

    # Compute gradient of a_smooth (points INWARD from edge toward interior)
    gy, gx = np.gradient(a_smooth)
    mag = np.sqrt(gx * gx + gy * gy) + 1e-6
    nx = gx / mag
    ny = gy / mag

    # Apple Icon Composer 45-degree diagonal directional catchlight + strong bottom bounce:
    # Top-left highlight + strong bottom-right caustic catchlight (matching YT #FF8AAA & MSG #6DB2FF)
    d_tl = np.clip((nx * 0.7071 + ny * 0.7071), 0.0, 1.0)
    d_br = np.clip((-nx * 0.7071 - ny * 0.7071), 0.0, 1.0)
    d_bot = np.clip(-ny, 0.0, 1.0)
    dir_spec = 0.42 + 0.58 * np.maximum(d_tl, np.maximum(d_br * 0.92, d_bot * 0.85))

    # 3. Translucent milky glass body + bottom internal caustic bounce (measured directly from YT & MSG!)
    mask_y = np.where(alpha.max(axis=1) > 0.2)[0]
    if len(mask_y) > 0:
        y0, y1 = mask_y[0], max(mask_y[-1], mask_y[0] + 1)
        yn = np.clip((np.arange(H, dtype=np.float32)[:, None] - y0) / (y1 - y0), 0.0, 1.0)
    else:
        yn = np.linspace(0.0, 1.0, H, dtype=np.float32)[:, None]

    # Smooth S-curve milky translucency lift: lighter & more luminous toward lower half (real glass caustic!)
    caustic_curve = yn ** 1.15
    frosted_lift = frosted_lift_top * (1.0 - caustic_curve) + frosted_lift_bottom * caustic_curve
    # Add a subtle soft top specular dome glint too
    top_glint = (np.clip(1.0 - yn * 2.6, 0.0, 1.0) ** 2.0) * 0.08
    body_lift = np.clip(frosted_lift + top_glint, 0.0, 0.75)

    # 4. Compose translucent frosted glass glyph color
    out_rgb = rgb.copy()
    # Gentle inner refraction depth only in mid-transition band (very subtle so it stays luminous, not dark)
    refract_band = np.clip(wide_rim - mid_rim * 0.8, 0.0, 1.0)
    out_rgb = out_rgb * (1.0 - refract_band[:, :, None] * inner_depth)
    # Apply translucent milky glaze ("làm nhạt màu" — blends toward pure white like glass over bright light)
    out_rgb = out_rgb + (1.0 - out_rgb) * body_lift[:, :, None]
    # Add broad frosted luminous inner-edge bloom
    out_rgb = out_rgb + (1.0 - out_rgb) * (wide_rim * edge_bloom)[:, :, None]
    # Add intense Apple Icon Composer specular rim flare ("lóe sáng"!)
    spec = np.clip(
        inner_rim * dir_spec * specular_strength + mid_rim * dir_spec * (specular_strength * 0.42),
        0.0, 1.0,
    )
    out_rgb = out_rgb + (1.0 - out_rgb) * spec[:, :, None]
    out_rgb = np.clip(out_rgb, 0.0, 1.0)

    # 5. Alpha-composite glyph OVER luminous colored ambient glow
    fg_a = alpha[:, :, None]
    bg_a = glow_shifted[:, :, 3:4]
    bg_rgb = glow_shifted[:, :, :3]

    comp_a = fg_a + bg_a * (1.0 - fg_a)
    comp_rgb = np.where(
        comp_a > 1e-5,
        (out_rgb * fg_a + bg_rgb * bg_a * (1.0 - fg_a)) / np.maximum(comp_a, 1e-5),
        0.0,
    )
    return np.dstack([np.clip(comp_rgb, 0.0, 1.0), np.clip(comp_a[:, :, 0], 0.0, 1.0)])


def make_squircle_mask(size: int, radius_ratio: float = 0.225) -> np.ndarray:
    """Superellipse (Apple squircle, n=4.5) mask in [0..1] anti-aliased."""
    aa = 2
    S = size * aa
    coords = (np.arange(S, dtype=np.float32) + 0.5) / S * 2.0 - 1.0
    X, Y = np.meshgrid(coords, coords)
    # Superellipse exponent ~4.6 matches iOS/OriginOS squircle closely
    n = 4.6
    dist = (np.abs(X) ** n + np.abs(Y) ** n) ** (1.0 / n)
    mask = np.clip((1.0 - dist) * (S * 0.35), 0.0, 1.0)
    im = Image.fromarray((mask * 255).astype(np.uint8), mode="L").resize((size, size), Image.LANCZOS)
    return np.asarray(im, dtype=np.float32) / 255.0


def build_tiktok_icons():
    print("=== Rendering TikTok Liquid Glass icons ===")
    ios = Image.open(os.path.join(WORK, "ios", "tiktok_ios_1024.png")).convert("RGBA")
    arr = np.asarray(ios, dtype=np.float32) / 255.0

    # Extract ONLY the central musical note (exclude iOS outer glass border frame!)
    # Note occupies center ~[115..910] of 1024x1024; outside is dark frame
    H, W = arr.shape[:2]
    yy, xx = np.mgrid[0:H, 0:W]
    # Safe interior mask well inside the iOS outer squircle rim (rim ends around 85px from edge)
    interior = (xx >= 105) & (xx <= W - 105) & (yy >= 95) & (yy <= H - 95)

    # Note pixels are bright cyan (#25F4EE), white (#FFFFFF), or magenta/red (#FE2C55) on pure black (#000000)
    lum = np.max(arr[:, :, :3], axis=2)
    # Smooth alpha from luminance on pure black background (preserves exact anti-aliased edges!)
    note_alpha = np.clip((lum - 0.04) / 0.22, 0.0, 1.0) * interior.astype(np.float32)
    # Recover pure un-premultiplied RGB on anti-aliased edge pixels
    safe_a = np.maximum(note_alpha, 0.15)
    note_rgb = np.clip(arr[:, :, :3] / safe_a[:, :, None], 0.0, 1.0)
    # Keep solid interior colors untouched
    solid = note_alpha > 0.85
    note_rgb[solid] = arr[:, :, :3][solid]

    # Crop tightly around the note to verify bounding box, then place into 432x432 Android Adaptive Foreground
    # Android adaptive icon safe zone: 72/108 = 66.7%; in TikTok's Android icon (res_aq_a.png),
    # the note height is ~76% of the squircle -> in 108dp adaptive canvas, 76% * 66.7% = 50.7% of 432px (~220px).
    # Let's check exact note height ratio in tt_orig/res_aq_a.png (masking out transparent corners!)
    tt_and = np.asarray(Image.open(os.path.join(WORK, "tt_orig", "res_aq_a.png")).convert("RGBA"), dtype=np.float32) / 255.0
    and_lum = np.max(tt_and[:, :, :3], axis=2) * tt_and[:, :, 3]
    ay = np.where((and_lum > 0.40).any(axis=1))[0]
    ax = np.where((and_lum > 0.40).any(axis=0))[0]
    and_h_ratio = (ay[-1] - ay[0] + 1) / tt_and.shape[0]
    and_cy_ratio = ((ay[0] + ay[-1]) * 0.5) / tt_and.shape[0]
    and_cx_ratio = ((ax[0] + ax[-1]) * 0.5) / tt_and.shape[1]
    print(f"  Android TikTok note ratios: h={and_h_ratio:.3f}, cx={and_cx_ratio:.3f}, cy={and_cy_ratio:.3f}")

    # Crop iOS note cleanly
    ny = np.where((note_alpha > 0.05).any(axis=1))[0]
    nx = np.where((note_alpha > 0.05).any(axis=0))[0]
    pad = 8
    y0, y1 = max(0, ny[0] - pad), min(H, ny[-1] + pad + 1)
    x0, x1 = max(0, nx[0] - pad), min(W, nx[-1] + pad + 1)
    note_crop = Image.fromarray(
        np.clip(np.dstack([note_rgb[y0:y1, x0:x1], note_alpha[y0:y1, x0:x1]]) * 255, 0, 255).astype(np.uint8),
        mode="RGBA",
    )

    # Render at 432x432 (xxxhdpi adaptive foreground)
    S = 432
    # Visible launcher squircle is center 66.7% of 432 (= 288px).
    # Place note at exact Android proportion inside that 288px safe zone!
    safe = S * (72.0 / 108.0)  # 288px
    target_h = int(round(safe * and_h_ratio))  # ~222px
    scale = target_h / (ny[-1] - ny[0] + 1)
    new_w = int(round(note_crop.width * scale))
    new_h = int(round(note_crop.height * scale))
    note_rs = note_crop.resize((new_w, new_h), Image.LANCZOS)

    canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    # Center matching Android cx/cy inside the 288px safe zone
    cx = S * 0.5 + (and_cx_ratio - 0.5) * safe
    cy = S * 0.5 + (and_cy_ratio - 0.5) * safe
    px = int(round(cx - new_w * 0.5))
    py = int(round(cy - new_h * 0.5))
    canvas.paste(note_rs, (px, py))

    c_arr = np.asarray(canvas, dtype=np.float32) / 255.0
    fg_rgb = c_arr[:, :, :3]
    fg_a   = c_arr[:, :, 3]

    # Apply Apple Icon Composer Liquid Glass shading to the note:
    glow_rgb = np.clip(fg_rgb * 0.85 + 0.15, 0.0, 1.0)
    fg_glass = apply_liquid_glass_to_glyph(
        fg_rgb, fg_a,
        size=S,
        rim_width=2.5,
        glow_radius=16.0,
        glow_alpha=0.36,
        glow_offset_y=3.0,
        specular_strength=0.60,
        inner_depth=0.03,
        frosted_lift_top=0.14,
        frosted_lift_bottom=0.25,
        edge_bloom=0.16,
        colored_glow=glow_rgb,
    )
    fg_im = Image.fromarray(np.clip(fg_glass * 255, 0, 255).astype(np.uint8), mode="RGBA")
    fg_im.save(os.path.join(OUT, "tiktok_adaptive_fg_432.png"))

    # Adaptive background: deeper smoked obsidian glass (less whitish gray)
    Y, X = np.mgrid[0:S, 0:S].astype(np.float32) / S
    diag = (X + Y) * 0.5
    rad = np.sqrt((X - 0.5) ** 2 + (Y - 0.58) ** 2)
    dome = np.clip(1.0 - rad * 1.45, 0.0, 1.0) ** 1.6
    bg = np.zeros((S, S, 4), dtype=np.float32)
    base_v = 0.112 * (1.0 - diag) + 0.062 * diag + 0.040 * dome
    bg[:, :, 0] = np.clip(base_v, 0.0, 1.0)
    bg[:, :, 1] = np.clip(base_v + 0.004, 0.0, 1.0)
    bg[:, :, 2] = np.clip(base_v + 0.016, 0.0, 1.0)
    bg[:, :, 3] = 1.0
    bg_im = Image.fromarray(np.clip(bg * 255, 0, 255).astype(np.uint8), mode="RGBA")
    bg_im.save(os.path.join(OUT, "tiktok_adaptive_bg_432.png"))

    # Legacy icon (composited squircle + Apple iOS 26 dark glass rim)
    comp = Image.alpha_composite(bg_im, fg_im)
    crop0 = (S - 288) // 2
    sq = comp.crop((crop0, crop0, crop0 + 288, crop0 + 288))
    sq_arr = np.asarray(sq, dtype=np.float32) / 255.0
    sq_mask = make_squircle_mask(288)
    sm_crisp = blur_arr(sq_mask, 2.4)
    sm_wide  = blur_arr(sq_mask, 6.5)
    rim_c = np.clip((sq_mask - sm_crisp) * 3.2, 0.0, 1.0) * sq_mask
    rim_w = np.clip((sq_mask - sm_wide) * 1.8, 0.0, 1.0) * sq_mask
    gy, gx = np.gradient(sm_crisp)
    mag = np.sqrt(gx * gx + gy * gy) + 1e-6
    nx, ny = gx / mag, gy / mag
    d_tl = np.clip((nx * 0.7071 + ny * 0.7071), 0.0, 1.0)
    d_br = np.clip((-nx * 0.7071 - ny * 0.7071), 0.0, 1.0)
    dir_o = 0.22 + 0.78 * np.maximum(d_tl, d_br * 0.88)
    rim_spec = np.clip(rim_c * dir_o * 0.45 + rim_w * dir_o * 0.13, 0.0, 1.0)
    sq_arr[:, :, :3] = np.clip(sq_arr[:, :, :3] + (1.0 - sq_arr[:, :, :3]) * rim_spec[:, :, None], 0.0, 1.0)
    sq_arr[:, :, 3] = sq_mask
    sq_im = Image.fromarray(np.clip(sq_arr * 255, 0, 255).astype(np.uint8), mode="RGBA")
    sq_im.save(os.path.join(OUT, "tiktok_preview_squircle.png"))

    # Save exact legacy sizes matching TikTok 48.0.2
    for fname, sz in [("ap_a_56.png", 56), ("am_b_84.png", 84), ("an_b_112.png", 112), ("ao_b_168.png", 168), ("aq_a_224.png", 224)]:
        sq_im.resize((sz, sz), Image.LANCZOS).save(os.path.join(OUT, f"tiktok_legacy_{fname}"))
    print("  Saved TikTok Liquid Glass icons!")


def build_zalo_icons():
    print("=== Rendering Zalo Liquid Glass icons ===")
    # Load BOTH official iOS 1024x1024 icon AND Android 432x432 adaptive foreground so geometry matches Android 100%!
    ios = Image.open(os.path.join(WORK, "ios", "zalo_ios_1024.png")).convert("RGBA")
    and_fg = Image.open(os.path.join(WORK, "zalo_orig", "res_mipmap-xxxhdpi-v4_ic_launcher_adaptive_foreground.png")).convert("RGBA")

    S = 432
    af = np.asarray(and_fg, dtype=np.float32) / 255.0
    # Inspect Zalo Android foreground composition:
    # - White speech bubble: high R, G, B (~1.0), high alpha
    # - Blue "Zalo" letters: blue (#0068FF), high alpha (B > 0.7, R < 0.3)
    # - Diagonal gray shadow under bubble: gray (~0.85, low alpha ~0.18)
    r, g, b, a = af[:, :, 0], af[:, :, 1], af[:, :, 2], af[:, :, 3]

    # Exact blue "Zalo" text mask from Android foreground (100% pixel-identical shape!)
    # Text pixels have strong blue chroma (b - r > 0.35) and high alpha
    # Even better: also measure iOS 1024x1024 sharpness — let's upsample/align iOS 1024 onto Android 432 OR
    # extract exact crisp masks directly at 432px (Wait: let's check if iOS 1024 aligns 1:1 with Android's 72/108 center!)
    ios_arr = np.asarray(ios, dtype=np.float32) / 255.0
    ir, ig, ib = ios_arr[:, :, 0], ios_arr[:, :, 1], ios_arr[:, :, 2]

    # Let's measure bounding box of "Zalo" letters in Android 432 vs iOS 1024 so we can align 1024x1024 with SUB-PIXEL precision!
    and_text_mask = (a > 0.5) & ((b - r) > 0.25)
    aty, atx = np.where(and_text_mask)
    ios_text_mask = (ib - ir) > 0.25
    # Restrict ios_text_mask to inside the speech bubble (center region where text lives, avoiding blue corners!)
    H, W = ir.shape
    yy, xx = np.mgrid[0:H, 0:W]
    ios_text_only = ios_text_mask & (xx > 180) & (xx < 920) & (yy > 280) & (yy < 640)
    ity, itx = np.where(ios_text_only)

    and_tw = atx[-1] - atx[0] + 1
    and_th = aty[-1] - aty[0] + 1
    ios_tw = itx[-1] - itx[0] + 1
    ios_th = ity[-1] - ity[0] + 1
    print(f"  Zalo Android text box: x=[{atx[0]}..{atx[-1]}] ({and_tw}), y=[{aty[0]}..{aty[-1]}] ({and_th})")
    print(f"  Zalo iOS text box:     x=[{itx[0]}..{itx[-1]}] ({ios_tw}), y=[{ity[0]}..{ity[-1]}] ({ios_th})")

    # Separate the Android foreground cleanly into:
    # 1. White speech bubble (including area behind text -> solid white bubble silhouette!)
    #    In Android foreground, bubble pixels have alpha > 0.5 and (either white OR blue text)
    #    Wait: shadow pixels have alpha < 0.35! Let's check alpha distribution!
    bubble_mask = np.clip((a - 0.35) / 0.45, 0.0, 1.0)
    # Text mask (smooth anti-aliased from blue chroma inside bubble!)
    text_chroma = np.clip((b - r) / 0.85, 0.0, 1.0) * bubble_mask
    # Clean crisp text alpha
    text_alpha = np.clip((text_chroma - 0.08) / 0.72, 0.0, 1.0)

    # Extend top-right bleed of bubble_mask cleanly to canvas edges (prevents any square cut during launcher parallax)
    # In Android original, bubble extends right to x=392, top to y=43 -> fill top-right outer bleed cleanly
    bubble_mask[:65, 195:] = np.maximum(bubble_mask[:65, 195:], bubble_mask[65:66, 195:])
    bubble_mask[:295, 385:] = np.maximum(bubble_mask[:295, 385:], bubble_mask[:295, 384:385])

    # Pure white bubble RGB (filling under text too so bubble is a clean continuous glass layer!)
    bubble_rgb = np.ones((S, S, 3), dtype=np.float32) * np.array([0.995, 0.998, 1.0], dtype=np.float32)

    # Step A: Apply Apple Icon Composer Liquid Glass to the WHITE SPEECH BUBBLE!
    # Luminous frosty white glass over sky-blue glass + soft luminous blue shadow glow
    bubble_shadow_color = np.zeros((S, S, 3), dtype=np.float32)
    bubble_shadow_color[:, :, 0] = 0.14
    bubble_shadow_color[:, :, 1] = 0.45
    bubble_shadow_color[:, :, 2] = 0.92
    bubble_glass = apply_liquid_glass_to_glyph(
        bubble_rgb, bubble_mask,
        size=S,
        rim_width=3.2,
        glow_radius=14.5,
        glow_alpha=0.29,
        glow_offset_y=6.0,
        specular_strength=0.61,
        inner_depth=0.03,
        frosted_lift_top=0.06,
        frosted_lift_bottom=0.10,
        edge_bloom=0.11,
        colored_glow=bubble_shadow_color,
    )
    # Soft luminous pearlescent blue-glass edge tint along inner curve of white bubble
    sm_b = blur_arr(bubble_mask, 5.0)
    rim_b = np.clip((bubble_mask - sm_b) * 2.1, 0.0, 1.0) * bubble_mask
    bubble_glass[:, :, 0] = np.clip(bubble_glass[:, :, 0] - rim_b * 0.045, 0.0, 1.0)
    bubble_glass[:, :, 1] = np.clip(bubble_glass[:, :, 1] - rim_b * 0.015, 0.0, 1.0)

    # Step B: Apply Apple Icon Composer Liquid Glass to the BLUE "Zalo" WORDMARK!
    # Calibrated 1-to-1 with Messenger v2.2's luminous translucent glass blue (#1E76FF top -> #549DFF bottom + glowing #9ACAFF rim!)
    text_rgb = np.zeros((S, S, 3), dtype=np.float32)
    text_rgb[:, :, 0] = 0.00
    text_rgb[:, :, 1] = 0.43
    text_rgb[:, :, 2] = 1.00
    text_glow = np.zeros((S, S, 3), dtype=np.float32)
    text_glow[:, :, 0] = 0.25
    text_glow[:, :, 1] = 0.62
    text_glow[:, :, 2] = 1.00
    text_glass = apply_liquid_glass_to_glyph(
        text_rgb, text_alpha,
        size=S,
        rim_width=1.35,
        glow_radius=10.0,
        glow_alpha=0.23,
        glow_offset_y=3.5,
        specular_strength=0.55,
        inner_depth=0.02,
        frosted_lift_top=0.10,
        frosted_lift_bottom=0.22,
        edge_bloom=0.05,
        colored_glow=text_glow,
    )

    # Composite Liquid Glass "Zalo" wordmark OVER Liquid Glass white speech bubble
    fg_im = Image.alpha_composite(
        Image.fromarray(np.clip(bubble_glass * 255, 0, 255).astype(np.uint8), mode="RGBA"),
        Image.fromarray(np.clip(text_glass * 255, 0, 255).astype(np.uint8), mode="RGBA"),
    )
    fg_im.save(os.path.join(OUT, "zalo_adaptive_fg_432.png"))

    # Step C: Zalo Liquid Glass Adaptive Background
    # Calibrated directly to Messenger v2.2's translucent milky sky-glass blue (#1E76FF upper -> #549CFF lower caustic glow!)
    Y, X = np.mgrid[0:S, 0:S].astype(np.float32) / S
    yn = np.clip((Y - 0.16) / 0.68, 0.0, 1.0)
    bg = np.zeros((S, S, 4), dtype=np.float32)
    # Match MSG v2.2 measured gradient: top (28,118,255) -> mid (64,144,255) -> bottom (89,160,255)
    bg[:, :, 0] = np.clip(0.11 * (1.0 - yn) + 0.35 * yn, 0.0, 1.0)
    bg[:, :, 1] = np.clip(0.46 * (1.0 - yn) + 0.63 * yn, 0.0, 1.0)
    bg[:, :, 2] = 1.00
    bg[:, :, 3] = 1.0
    bg_im = Image.fromarray(np.clip(bg * 255, 0, 255).astype(np.uint8), mode="RGBA")
    bg_im.save(os.path.join(OUT, "zalo_adaptive_bg_432.png"))

    # Step D: Squircle preview & Legacy icons (cropped to Android's exact 72/108 = 288x288 visible launcher frame!)
    comp = Image.alpha_composite(bg_im, fg_im)
    crop0 = (S - 288) // 2
    sq = comp.crop((crop0, crop0, crop0 + 288, crop0 + 288))
    sq_arr = np.asarray(sq, dtype=np.float32) / 255.0
    sq_mask = make_squircle_mask(288)
    # Strong luminous Apple iOS 26 outer squircle specular rim flare
    sm_c = blur_arr(sq_mask, 2.5)
    sm_w = blur_arr(sq_mask, 6.5)
    rim_c = np.clip((sq_mask - sm_c) * 3.2, 0.0, 1.0) * sq_mask
    rim_w = np.clip((sq_mask - sm_w) * 1.8, 0.0, 1.0) * sq_mask
    gy, gx = np.gradient(sm_c)
    mag = np.sqrt(gx * gx + gy * gy) + 1e-6
    nx, ny = gx / mag, gy / mag
    d_tl = np.clip((nx * 0.7071 + ny * 0.7071), 0.0, 1.0)
    d_br = np.clip((-nx * 0.7071 - ny * 0.7071), 0.0, 1.0)
    dir_o = 0.30 + 0.70 * np.maximum(d_tl, d_br * 0.90)
    rim_spec = np.clip(rim_c * dir_o * 0.58 + rim_w * dir_o * 0.19, 0.0, 1.0)
    sq_arr[:, :, :3] = np.clip(sq_arr[:, :, :3] + (1.0 - sq_arr[:, :, :3]) * rim_spec[:, :, None], 0.0, 1.0)
    sq_arr[:, :, 3] = sq_mask
    sq_im = Image.fromarray(np.clip(sq_arr * 255, 0, 255).astype(np.uint8), mode="RGBA")
    sq_im.save(os.path.join(OUT, "zalo_preview_squircle.png"))

    # Also build circular round legacy icon
    Y2, X2 = np.mgrid[0:288, 0:288].astype(np.float32)
    rdist = np.sqrt(((X2 - 143.5) / 143.5) ** 2 + ((Y2 - 143.5) / 143.5) ** 2)
    cmask = np.clip((1.0 - rdist) * 100.0, 0.0, 1.0)
    circ_arr = np.asarray(sq, dtype=np.float32) / 255.0
    circ_arr[:, :, 3] = cmask
    circ_im = Image.fromarray(np.clip(circ_arr * 255, 0, 255).astype(np.uint8), mode="RGBA")

    # Save all 5 Android densities for Zalo
    densities = [
        ("mdpi",    108, 48),
        ("hdpi",    162, 72),
        ("xhdpi",   216, 96),
        ("xxhdpi",  324, 144),
        ("xxxhdpi", 432, 192),
    ]
    for dname, asz, lsz in densities:
        fg_im.resize((asz, asz), Image.LANCZOS).save(os.path.join(OUT, f"zalo_{dname}_fg.png"))
        bg_im.resize((asz, asz), Image.LANCZOS).save(os.path.join(OUT, f"zalo_{dname}_bg.png"))
        sq_im.resize((lsz, lsz), Image.LANCZOS).save(os.path.join(OUT, f"zalo_{dname}_legacy.png"))
        circ_im.resize((lsz, lsz), Image.LANCZOS).save(os.path.join(OUT, f"zalo_{dname}_round.png"))
    print("  Saved Zalo Liquid Glass icons!")


def make_comparison_sheet():
    """Side-by-side preview of YouTube v2.2, Messenger v2.2, new TikTok, and new Zalo on a clean wallpaper."""
    sheet = Image.new("RGBA", (1320, 380), (236, 240, 246, 255))

    def mk_ref_squircle(fg_path, bg_color):
        fg = Image.open(fg_path).convert("RGBA").resize((432, 432), Image.LANCZOS)
        bg = Image.new("RGBA", (432, 432), bg_color)
        comp = Image.alpha_composite(bg, fg).crop((72, 72, 360, 360))
        arr = np.asarray(comp, dtype=np.float32) / 255.0
        arr[:, :, 3] = make_squircle_mask(288)
        return Image.fromarray(np.clip(arr * 255, 0, 255).astype(np.uint8), mode="RGBA")

    yt_sq  = mk_ref_squircle(os.path.join(WORK, "ref", "yt_Vd3.png"), (255, 255, 255, 255))
    msg_sq = mk_ref_squircle(os.path.join(WORK, "ref", "msg_lb2.png"), (255, 255, 255, 255))
    tt_sq  = Image.open(os.path.join(OUT, "tiktok_preview_squircle.png")).convert("RGBA")
    zl_sq  = Image.open(os.path.join(OUT, "zalo_preview_squircle.png")).convert("RGBA")

    for i, im in enumerate([yt_sq, msg_sq, tt_sq, zl_sq]):
        sheet.alpha_composite(im, (36 + i * 320, 46))
    sheet.save(os.path.join(OUT, "preview_sheet_4apps.png"))
    print("Saved comparison sheet:", os.path.join(OUT, "preview_sheet_4apps.png"))


if __name__ == "__main__":
    build_tiktok_icons()
    build_zalo_icons()
    make_comparison_sheet()
