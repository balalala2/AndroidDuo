---
name: android-duo-release
description: >-
  End-to-end workflow to fetch latest APKs (Zalo, Messenger, Facebook, TikTok, YouTube, etc.)
  from 3rd-party APK sites or Morphe patch sources, apply Morphe pre-patches when needed for
  re-signing, inject Android Duo & Liquid Glass patches, verify signatures, and publish a Draft
  GitHub Release on balalala2/AndroidDuo. Use whenever the user asks to update, patch, or
  release any Android Duo app.
---

# Android Duo — End-to-End Update, Patch & Release Workflow

Central config and scripts live in `AndroidDuo/pipeline/`:
- `apps.json` — Registry of all apps (`zalo`, `messenger`, `facebook`, `tiktok`, `youtube`, `instagram`, `telegram`), package IDs, APK sources, Morphe rules, build scripts, and signing cert SHA-256.
- `step1-morphe-check.ps1` — Checks Morphe-compatible versions/patches (Java 21) or merges split APKs (`.apkm`/`.xapk`/`.apks`) via `APKEditor.jar`.
- `step2-morphe-prepatch.ps1` — Runs headless Morphe pre-patch (`--unsigned`) using Java 21 + `morphe-desktop-*.jar`.
- `step3-stage-and-release.ps1` — Verifies manifest + `zsplit.jks` certificate SHA-256 (`VerifyCert.java`), stages canonical filenames, and creates a **Draft** GitHub Release on `balalala2/AndroidDuo`.
- `verify-apk.py` — Inspects binary `AndroidManifest.xml` (`package`, `versionName`, `versionCode`), DEX count, `baseline.prof*` presence, and file SHA-256.

## Environment Rules
- **Java 21+** (`jre-21*`) is required for `morphe-desktop-*.jar`.
- **JDK 17** (`javac --release 11 -encoding UTF-8`, `D8`, `smali.jar`, `baksmali.jar`, `APKEditor.jar`, `SignV123.java` / `Sign.java`) is used for compiling and signing.
- **Signing key**: `zsplit.jks` at workspace root (`SHA-256: 8c3408403a657900eab0ba56d2a5871b3d9e2eb002bad73f0993f7084f8d21db`). **NEVER commit keystores or passphrases.**

---

## Step 1 — Find & Fetch Latest APK

1. Read `AndroidDuo/pipeline/apps.json` for each requested app.
2. **Check Morphe requirement first** (`morphe.enabled == true`):
   - Run:
     ```powershell
     .\AndroidDuo\pipeline\step1-morphe-check.ps1 -App <app>
     ```
   - **YouTube (`youtube`) special rule**: Prefer taking a **pre-built Morphe YouTube APK** directly first (or patching the latest Morphe-supported `com.google.android.youtube` version with `MorpheApp/morphe-patches` + GmsCore). Note that the Morphe-patched output package is `app.morphe.android.youtube` (`patched_package` in `apps.json`).
   - **Zalo (`zalo`) special rule**: Use the pure-bytecode **ZNQ Morphe stack** (`zeldris` + `nezumi` + `https://github.com/mnhqngl/quang-patches`) with `-e "Allow Zalo to see Photos (Zalo)" -O "photosPackage=com.google.android.apps.photos"` and `-d "Change Photos picker package (Zalo)" -d "Drive backup via microG" -d "microG Drive support"`. **Never use NPatch / ElectroHeavenVN ZaloXposed** (its native anti-tamper calls `exit(1)` during voice calls).
   - **TikTok (`tiktok`) special rule**: **No HushFeed / no Morphe needed** — fetch latest direct APK from APKMirror/APKPure and only apply the right-pane foldable comment split patch.
3. **Locate & download APK** from 3rd-party sources (`apkmirror`, `apkpure`, `uptodown`) matching `arch: arm64-v8a` (and `dpi: nodpi` when available):
   - Use `search_web` or the `browser` subagent if a site requires JS/interactive download.
   - Never bypass CAPTCHAs or anti-bot gates — if gated, ask the user to download the APK into the app's dev folder (`Antigravity-ZSplit/<app>-<version>/`).
4. **If the download is a split bundle** (`.apkm`, `.xapk`, `.apks`, or folder of `base.apk` + `split_*.apk`), merge it first:
   ```powershell
   .\AndroidDuo\pipeline\step1-morphe-check.ps1 -MergeSplits <bundle_or_dir> -OutApk <merged.apk>
   ```

---

## Step 2 — Pre-Patch (Morphe) + Patch (Android Duo & Liquid Glass)

1. **Morphe pre-patch** (if `morphe.enabled == true`):
   ```powershell
   .\AndroidDuo\pipeline\step2-morphe-prepatch.ps1 -App <app> -InputApk <merged.apk> -OutApk <prepatched.apk>
   ```
   Verify the generated `.morphe-result.json` reports success before continuing.
2. **Check & remap obfuscated hooks** when moving to a newer app version:
   - Inspect `obfuscated_hooks` in `apps.json` (e.g., Zalo `cbo`/`vrv` -> `lio`/`u1w`, Facebook `X.01Bu`, TikTok `LX/07o1;`).
   - Use `baksmali.jar` / `Dump.java` to verify target classes and method signatures in the new APK's DEX files. Update mappings if obfuscation changed.
3. **Build & Sign Android Duo + Liquid Glass**:
   - Run the app's build script (or create a versioned copy in `Antigravity-ZSplit/<app>-<ver>/`).
   - Ensure the build:
     - Compiles Java with `javac --release 11 -encoding UTF-8` + `D8 --min-api 28`.
     - Strips `assets/dexopt/baseline.prof` and `assets/dexopt/baseline.profm`.
     - Keeps `versionCode` strictly greater than the previous released `versionCode` (for seamless `adb install -r` upgrades without data loss).
     - Signs with `zsplit.jks` (`v1+v2+v3` via `SignV123.java` or `v2+v3` via `Sign.java`).
4. **Verify APK** before staging:
   ```powershell
   python .\AndroidDuo\pipeline\verify-apk.py <built.apk>
   ```
   If a test phone is connected via ADB, optionally run `adb install -r <built.apk>` and smoke-test launch + logcat.

---

## Step 3 — Stage & Publish Draft Release

1. **Sync source code** into `AndroidDuo/src/<app>/`, update `AndroidDuo/pipeline/apps.json` (`last_released_version`, `last_released_version_code`), and update `AndroidDuo/README.md` (download table + Vietnamese changelog).
2. **Stage & create a DRAFT GitHub Release** (never publish directly without user approval):
   ```powershell
   # Dry run first to verify cert SHA-256, package, versionCode, and baseline.prof
   .\AndroidDuo\pipeline\step3-stage-and-release.ps1 `
     -ReleaseVersion "<X.Y>" `
     -Apks @{ zalo="<path>"; messenger="<path>"; facebook="<path>"; tiktok="<path>" } `
     -DryRun

   # Create Draft Release on balalala2/AndroidDuo
   .\AndroidDuo\pipeline\step3-stage-and-release.ps1 `
     -ReleaseVersion "<X.Y>" `
     -Apks @{ zalo="<path>"; messenger="<path>"; facebook="<path>"; tiktok="<path>" } `
     -NotesFile "<path-to-notes.md>"
   ```
3. **Commit & push** source/docs changes in `AndroidDuo` (double-check `git status` — never commit `.apk`, `.jks`, `.jar`, or secrets).
4. **Update `HANDOFF.md`** in both `c:\Users\Nguyen\Downloads\ZaloSplit\HANDOFF.md` and `C:\Users\Nguyen\Claude\HANDOFF.md`.
5. Report the Draft Release URL and verification summary to the user so they can review and click **Publish release**.
