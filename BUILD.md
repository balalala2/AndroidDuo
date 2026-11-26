# Hướng dẫn Build & Vá (Android Duo 2.2)

Tài liệu này được viết theo chuẩn **tự chứa (self-contained)** để bạn (hoặc một phiên **Antigravity** mới ở máy khác) có thể lấy repo + APK gốc/đang cài trên máy là dựng lại, vá tiếp và ký được ngay mà không cần nhớ lại ngữ cảnh cũ.

---

## 1. Môi trường & Công cụ cần có

- **JDK 17 hoặc 21** (có thể dùng bản portable, không cần quyền admin).
- **Python 3** (chỉ dùng thư viện chuẩn `zipfile`, `struct`, `zlib` — không cần `pip install`).
- **`morphe-desktop-2.3.0-all.jar`** (đã tích hợp sẵn `dexlib2`, `smali`, `apksig`, `reandroid` — mọi công cụ Java trong `tools/` đều biên dịch và chạy trực tiếp bằng file jar này, **không cần Android SDK** khi chỉ vá smali/dexlib2).
- **Android SDK (`android-35/android.jar` + `d8`/`r8.jar`)**: chỉ cần khi biên dịch lại mã nguồn `.java` (`ZGlass.java`, `YGlass.java`, `MSplit.java`, `FSplit.java`) sang `.dex`. Nếu chỉ sửa trực tiếp `.smali` đã có sẵn thì **không cần SDK**.
- **`zsplit.jks`** *(không commit vào repo)*: keystore PKCS12, alias `zsplit`, chứng chỉ SHA-256:
  ```
  8c3408403a657900eab0ba56d2a5871b3d9e2eb002bad73f0993f7084f8d21db
  ```
  > **Quan trọng:** Trước khi build để cài đè (`adb install -r`), luôn kiểm tra chữ ký APK đang cài trên máy có khớp cert SHA-256 trên hay không. Không tự gỡ app người dùng để tránh mất dữ liệu.

### Bảng công cụ trong `tools/`
| Công cụ | Chức năng | Cách gọi |
|---|---|---|
| `Asm.java` | Dịch các file `.smali` thành 1 file `.dex` | `java -cp bin;morphe.jar Asm out.dex a.smali b.smali ...` |
| `SplitDex.java` | Tách toàn bộ class trong 1 `.dex` thành các file `.smali` riêng lẻ | `java -cp bin;morphe.jar SplitDex in.dex out_dir` |
| `Dump.java` | Xuất 1 class (lọc theo tên) trong `.dex` ra `.smali` | `java -cp bin;morphe.jar Dump in.dex out.smali ClassFilter` |
| `RebuildDex.java` | Vá bytecode DEX trực tiếp bằng `dexlib2` cho Zalo 26.11.02 (`replace`, `killzv`, `fixcontact`, `hookn0`) | xem mục 2 bên dưới |
| `Verify.java` | Kiểm tra bytecode (thanh ghi, kiểu dữ liệu, jump target) trước khi đóng gói | `java -cp bin;morphe.jar Verify patched.dex [extra_dex...]` |
| `Combine.java` | Gộp nhiều `.dex` thành một | `java -cp bin;morphe.jar Combine out.dex a.dex b.dex` |
| `Patch.java` | Sửa nhanh method (`false` / `norecreate`) | `java -cp bin;morphe.jar Patch in.dex out.dex LType; method mode` |
| `Prefix.java` | Chèn `invoke-static {p0}` vào đầu method | `java -cp bin;morphe.jar Prefix in out LType; m1,m2 LHelper; fn` |
| `Redirect.java` | Đổi `ViewGroup.addView/removeView` thành `zs_addView/zs_removeView` | `java -cp bin;morphe.jar Redirect in out LType; LHelper;` |
| `rezip.py` | Đóng gói lại APK (giữ căn lề `.so` 16 KB & nén chuẩn); `file=path` để thay, `file=-` để xóa | `python3 tools/rezip.py in.apk out.apk classes10.dex=new.dex ...` |
| `axml.py` | Đọc `AndroidManifest.xml` nhị phân, kiểm tra `configChanges`, `resizeableActivity` | `python3 tools/axml.py app.apk MainActivity` |
| `MergeApk.java` | Gộp `base.apk` + `split_*.apk` thành 1 APK | `java -cp bin;morphe.jar MergeApk split_dir out.apk` |
| `Sign.java` | Ký APK v2+v3 bằng `zsplit.jks` và tự verify + in SHA-256 | `java -cp bin;morphe.jar Sign in.apk out.apk zsplit.jks` |

### Biên dịch sẵn bộ `tools/` (chạy 1 lần)
**Windows PowerShell:**
```powershell
$JDK = "C:\path\to\jdk-21\bin"
$JAR = "C:\path\to\morphe-desktop-2.3.0-all.jar"
New-Item -ItemType Directory -Force -Path tools_bin | Out-Null
& "$JDK\javac.exe" -d tools_bin -cp $JAR tools\Asm.java tools\SplitDex.java tools\Dump.java tools\RebuildDex.java tools\Verify.java tools\Sign.java
```

**Linux / macOS:**
```sh
mkdir -p tools_bin
javac -d tools_bin -cp morphe-desktop-2.3.0-all.jar tools/Asm.java tools/SplitDex.java tools/Dump.java tools/RebuildDex.java tools/Verify.java tools/Sign.java
```

---

## 2. Dựng lại Zalo (`v26.11.02` — Android Duo 2.2)

### Kiến trúc bản vá Zalo 26.11.02 (4 DEX được vá)
1. **`classes.dex` (`RebuildDex hookn0`)**:
   - Đã có sẵn các hook nền của Android Duo 2.0 (`b.C0`, `b.r0`, redirect `addView`/`removeView` → `ZSplit.zs_addView`/`zs_removeView`).
   - **Mới trong v2.2**: chèn guard vào đầu `Lcom/zing/zalo/zview/b;->n0(Llio;I)V`:
     ```smali
     invoke-static/range {p0 .. p2}, Lcom/zing/zalo/zsplit/ZSplit;->keepMainState(Lcom/zing/zalo/zview/b;Llio;I)Z
     move-result v0
     if-eqz v0, :cont
     return-void
     ```
     Tác dụng: ngăn Zalo hạ trạng thái vòng đời (`onPause`/`onStop`) của `MainTabView` khi mở panel phải ở chế độ màn trong chia đôi → loại bỏ hoàn toàn lỗi kẹt loading ở Panel trái (Tab Tin nhắn & Tab Danh bạ).
2. **`classes4.dex` (`RebuildDex fixcontact`)**:
   - Trong `Lcom/zing/zalo/zalocontact/ui/zaloview/ContactTabZaloView;->Y6()Z`: thay lệnh `instance-of vX, vY, Lcom/zing/zalo/ui/maintab/MainTabView;` bằng `const/4 vX, 0x1`.
   - Tác dụng: `ContactTabZaloView` vẫn nạp và cập nhật danh bạ bình thường ngay cả khi panel phải (`Cloud của tôi`) đang mở đè trên stack `zview.b`.
3. **`classes5.dex` (`RebuildDex killzv`)**:
   - Trong lớp `Lovu;` (Zalo Video feature gate): cho các method `a()Z`, `b()Z`, `f()Z`, `h()Z` trả về `false` và `d()Ljava/lang/String;` trả về `null`.
   - Tác dụng: tắt hoàn toàn Zalo Video, vào Tab 3 (Tường nhà) luôn mở thẳng Nhật ký.
4. **`classes10.dex` (`ZSplit.smali` + `ZTL.smali` + các lớp `ZGlass*`/`ZBack`/`ZDrag`/`ZFix`/`ZFore`/`ZOutline`/`ZRetry`)**:
   - `ZSplit.smali`: quản lý chia đôi 40/60 khi màn trong (`wDp >= 550`), tự tắt hoàn toàn chia đôi & auto-open ở màn ngoài (hoạt động đúng như máy thanh), giữ đúng vị trí và trạng thái chọn Tab 3 của thanh Dock khi mở/đóng Thông báo.
   - `ZTL.smali`: `Runnable` tự động mở panel phải mặc định theo tab (Tab 2 Danh bạ & Tab 4 Cá nhân → `Cloud của tôi` `uid=204278670`, Tab 3 Tường nhà → `Thông báo`), đồng thời dọn stack an toàn khi đổi tab.

### Quy trình build Zalo 26.11.02 từ APK nền (`Zalo-v26.11.02-pulled.apk` hoặc bản v2.2 hiện có)
1. Trích `classes.dex`, `classes4.dex`, `classes5.dex`, `classes10.dex` từ APK Zalo `26.11.02` nền (đã có hook `b.C0`/`b.r0`/`addView` của Android Duo):
   ```powershell
   python -c "import zipfile; z=zipfile.ZipFile('Zalo-base.apk'); [z.extract(f,'work-zalo') for f in ['classes.dex','classes4.dex','classes5.dex','classes10.dex']]"
   ```
2. Biên dịch `src/zalo/ZSplit.smali` + `src/zalo/ZTL.smali` rồi thay vào `classes10.dex`:
   ```powershell
   & "$JDK\java.exe" -cp "tools_bin;$JAR" Asm work-zalo\patch10.dex src\zalo\ZSplit.smali src\zalo\ZTL.smali
   & "$JDK\java.exe" -cp "tools_bin;$JAR" RebuildDex replace work-zalo\classes10.dex work-zalo\patch10.dex work-zalo\classes10.patched.dex
   ```
3. Vá `classes.dex`, `classes4.dex`, `classes5.dex` (lưu ý: nếu `Zalo-base.apk` là bản đã vá v2.2 rồi thì **không** chạy lại `hookn0` lần 2 kẻo chèn trùng; chỉ chạy khi `classes.dex` chưa có `keepMainState`):
   ```powershell
   & "$JDK\java.exe" -cp "tools_bin;$JAR" RebuildDex hookn0     work-zalo\classes.dex  work-zalo\classes.patched.dex
   & "$JDK\java.exe" -cp "tools_bin;$JAR" RebuildDex fixcontact work-zalo\classes4.dex work-zalo\classes4.patched.dex
   & "$JDK\java.exe" -cp "tools_bin;$JAR" RebuildDex killzv     work-zalo\classes5.dex work-zalo\classes5.patched.dex
   ```
4. Verify bytecode, đóng gói APK và ký:
   ```powershell
   & "$JDK\java.exe" -cp "tools_bin;$JAR" Verify work-zalo\classes10.patched.dex
   python tools\rezip.py Zalo-base.apk work-zalo\unsigned.apk `
     classes.dex=work-zalo\classes.patched.dex `
     classes4.dex=work-zalo\classes4.patched.dex `
     classes5.dex=work-zalo\classes5.patched.dex `
     classes10.dex=work-zalo\classes10.patched.dex `
     assets/dexopt/baseline.prof=- assets/dexopt/baseline.profm=-
   & "$JDK\java.exe" -cp "tools_bin;$JAR" Sign work-zalo\unsigned.apk ZaloDuo-2.2_26.11.02.apk zsplit.jks
   ```

> **Lưu ý khi Zalo lên phiên bản mới hơn (`26.11.03+`)**: các tên lớp bị obfuscate như `Llio;`, `Lu1w;`, `Lu0k;`, `Lvp4;`, `Lovu;`, và tên method `zview.b->n0`, `ContactTabZaloView->Y6` có thể đổi tên. Dùng `Dump.java` hoặc script `dexlib2` tìm lại chữ ký tương ứng trước khi chạy `RebuildDex`.

---

## 3. Dựng lại YouTube (`v21.30.216`, Morphe — Android Duo 2.2)

### Kiến trúc bản vá YouTube 21.30.216
APK nền (`app.morphe.android.youtube` v21.30.216) chỉ có **3 điểm hook** nối sang `classes16.dex` (`com.zsplit.yt.*`):
1. `classes10.dex`: `PivotBar->v(...)` → `YGlass.attach(View)`
2. `classes10.dex`: `PivotBar->dispatchTouchEvent(...)` → `YGlass.onTouch(View, MotionEvent)`
3. `classes14.dex`: `ChangeFormFactorPatch->getUniversalFormFactor(int)` → `YGlass.getDynamicFormFactor(int)`

### Điểm cốt lõi của bản sửa v2.2 (gập/mở 2 cột ↔ 1 cột KHÔNG reload feed)
Trong `src/youtube/com/zsplit/yt/YGlass.java`:
- **`YGlass.getDynamicFormFactor(int)` luôn trả về `2` (`LARGE_FORM_FACTOR`)**:
  - Server YouTube luôn trả về feed kèm bảng breakpoint responsive (`Lauam` / `Laual` trong `classes10.dex` & `classes2.dex`).
  - Engine responsive gốc của YouTube (`Lauam.i(width, height)` → `Latnz.as()` → `GridLayoutManager.setSpanCount()` / `FlowLayoutManager`) tự động chuyển:
    - Màn trong (`>= 580dp`, ví dụ `711dp`): **2 cột**, mỗi thẻ rộng `~355dp < 600dp` nên hiển thị dạng thẻ dọc chuẩn.
    - Màn ngoài (`< 580dp`, ví dụ `344dp`): tự co về **1 cột** kiểu máy thanh.
- **`YGlass$GlassController.checkFoldRefresh()` bỏ hẳn `triggerSwipeRefresh()`**:
  - Chỉ cập nhật `sLastWidthDp` và `lastWideState` cho thanh dock Liquid Glass, tuyệt đối không gọi `SwipeRefreshLayout.onRefresh()` khi gập/mở → giữ nguyên 100% video & vị trí cuộn.

### Cách build lại `classes16.dex` của YouTube

#### Cách A — Biên dịch từ Java (`YGlass.java` + `TabFx.java`, khi có `android.jar` + `d8`)
```sh
mkdir -p work-yt/cls
javac --release 11 -encoding UTF-8 -cp "$ANDROID_HOME/platforms/android-35/android.jar" \
  -d work-yt/cls src/youtube/com/zsplit/yt/TabFx.java src/youtube/com/zsplit/yt/YGlass.java
d8 --min-api 29 --lib "$ANDROID_HOME/platforms/android-35/android.jar" \
  --output work-yt work-yt/cls/com/zsplit/yt/*.class
mv work-yt/classes.dex work-yt/classes16.patched.dex
```

#### Cách B — Vá trực tiếp smali từ `classes16.dex` của APK nền (KHÔNG cần Android SDK / D8)
Rất tiện khi sửa nhanh trên máy chỉ có JDK + `morphe-desktop-2.3.0-all.jar`:
```powershell
# 1. Trích classes16.dex và tách thành 13 file .smali
python -c "import zipfile; zipfile.ZipFile('YouTube-base.apk').extract('classes16.dex','work-yt')"
& "$JDK\java.exe" -cp "tools_bin;$JAR" SplitDex work-yt\classes16.dex work-yt\dex16

# 2. Chỉnh sửa trong work-yt\dex16\com_zsplit_yt_YGlass.smali (hoặc GlassController.smali)
# 3. Đóng lại classes16.dex + verify + rezip + ký:
$smalis = (Get-ChildItem work-yt\dex16\*.smali | ForEach-Object { $_.FullName })
& "$JDK\java.exe" -cp "tools_bin;$JAR" Asm work-yt\classes16.patched.dex @smalis
& "$JDK\java.exe" -cp "tools_bin;$JAR" Verify work-yt\classes16.patched.dex
python tools\rezip.py YouTube-base.apk work-yt\unsigned.apk classes16.dex=work-yt\classes16.patched.dex
& "$JDK\java.exe" -cp "tools_bin;$JAR" Sign work-yt\unsigned.apk YouTubeDuo-2.2_21.30.216.apk zsplit.jks
```

---

## 4. Dựng lại Messenger (`v576.0.0.47.92`) & Facebook (`v588.0.0.42.55`)

- **Messenger**: mã nguồn ở `src/messenger/com/zsplit/msg/` (`MSplit.java`, `MDock.java`, `MGlass.java`, `PrefSplit.java`, `TabFx.java`). Biên dịch `javac --release 11 -encoding UTF-8` + `d8 --min-api 28` thành `classes15.dex`, thay vào APK Messenger gốc bằng `rezip.py`, ký bằng `Sign.java`.
- **Facebook**: mã nguồn ở `src/facebook/com/zsplit/fb/` (`FSplit.java`, `FGlass.java`, `TabFx.java`) kèm compile-only stubs ở `src/facebook/stubs/` (không đóng gói stubs vào dex cuối). Xem chi tiết lệnh trong `build-facebook.sh`.

---

## 5. Mẹo debug & kiểm thử nhanh trên máy gập (cho Antigravity)

1. **Kéo APK hiện tại từ máy**:
   ```sh
   adb shell pm path <package_name>
   adb pull <path>/base.apk pulled.apk
   ```
2. **Kiểm tra chữ ký trước khi cài đè**:
   ```sh
   adb shell "dumpsys package <package_name> | grep -E 'versionName|versionCode|signatures'"
   ```
3. **Cài đè an toàn**:
   - Chạy `adb install -r out.apk` (không bấm chạm tự động trong lúc cài vì các máy OriginOS/vivo có thể hiện hộp thoại xác nhận cài qua USB).
4. **Kiểm tra bố cục trực tiếp sau khi cài**:
   - Xem log mod: `adb logcat -d -s YGlass ZSplit`
   - Dump cây UI thật: `adb shell "uiautomator dump /sdcard/ui.xml && cat /sdcard/ui.xml"`
   - Xem kích thước các màn hình (màn trong / màn ngoài) và Activity đang focus:
     `adb shell "dumpsys window displays | grep -E 'cur=|mCurrentFocus'"`
