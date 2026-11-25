# Hướng dẫn build & vá (Android Duo 2.0)

## Chuẩn bị
- Java 17+, Python 3, Android SDK (`android-35/android.jar`, `r8.jar` / D8, `apksig.jar`), `smali.jar`, `adb`.
- `morphe-desktop-2.3.0-all.jar` — chứa smali/dexlib2, apksig và ARSCLib cho các công cụ trong `tools/`.
- `zsplit.jks` — khóa ký (PKCS12, alias `zsplit`). **Không có trong repo.** Phải dùng đúng khóa này thì mới cài đè được bản cũ.

## Công cụ (`tools/`)
| Công cụ | Việc làm | Tham số |
|---|---|---|
| `Asm.java` | Dịch các file `.smali` thành một `.dex` | `out.dex a.smali b.smali ...` |
| `Dump.java` | Xuất một lớp trong dex ra smali để đọc | xem nguồn |
| `Patch.java` | Sửa một method: `false` = cho trả về `false`; `norecreate` = xoá các lời gọi `Activity.recreate()` | `in.dex out.dex LKiểu; method mode` |
| `Prefix.java` | Chèn `invoke-static {p0}, Lớp->hàm(Kiểu)V` vào đầu các method | `in out LKiểu; m1,m2 LLớpTĩnh; tênHàm` |
| `Redirect.java` | Đổi `ViewGroup.addView/removeView` trong một lớp thành gọi hàm tĩnh `zs_addView/zs_removeView` | `in out LKiểu; LLớpTĩnh;` |
| `Combine.java` | Gộp nhiều dex thành một | `out.dex a.dex b.dex ...` |
| `Verify.java` | Kiểm tra bytecode các lớp `zsplit` (bắt lỗi thanh ghi/kiểu trước khi cài) | `mine.dex framework/app dex ...` |
| `Ver.java` | In thông tin phiên bản dex | |
| `rezip.py` | Đóng gói lại APK, thay file: `tên=đường_dẫn`, xoá file: `tên=-`; giữ căn lề `.so` 16 KB | `in.apk out.apk classes.dex=x.dex ...` |
| `axml.py` | Đọc `AndroidManifest.xml` nhị phân, liệt kê activity + `configChanges`, `resizeableActivity`... | `app.apk [lọc,tên]` |
| `MergeApk.java` | Gộp `base.apk` + `split_*.apk` trong một thư mục thành một APK | `thư_mục out.apk` |
| `Sign.java` | Ký v2+v3 bằng `zsplit.jks`, tự kiểm tra và in SHA-256 cert | `in.apk out.apk zsplit.jks` |

## Dựng lại Zalo (v2.0)
- Mã nguồn: `src/zalo/` gồm `ZGlass.java` (biên dịch bằng `javac --release 11 -encoding UTF-8` + D8) và các lớp smali (`ZSplit.smali`, `ZBack.smali`, `ZFore.smali`, `ZDrag.smali`, `ZFix.smali`, `ZOutline.smali`, `ZRetry.smali`).
- `ZSplit.smali` đã móc `ZGlass.prePosition(...)` trên cả 3 overload `zs_addView` để định vị khung chat trước khi gắn view.
- Gộp 2 dex thành `classes10.dex`, cập nhật `versionCode` (`261101901` → `261102902`), xóa `assets/dexopt/baseline.prof*`, đóng gói bằng `rezip.py` và ký bằng `Sign.java`.

## Dựng lại Messenger (v2.0)
- Mã nguồn: `src/messenger/com/zsplit/msg/` (`MSplit.java`, `MDock.java`, `MGlass.java`, `PrefSplit.java`).
- Biên dịch bằng `javac --release 11 -encoding UTF-8` + D8 (`--min-api 28`) thành `classes15.dex`.
- Chèn `classes15.dex` vào APK Messenger gốc đã hook điểm vào bằng `rezip.py`, sau đó ký bằng `Sign.java`.

## Dựng lại Facebook (v2.0)
- Mã nguồn: `src/facebook/com/zsplit/fb/` (`FSplit.java`, `FGlass.java`) kèm compile-only stubs tại `src/facebook/stubs/` (không đưa stubs vào dex cuối).
- Biên dịch stubs trước, sau đó biên dịch `FSplit.java` + `FGlass.java` và chạy D8 (`--min-api 28 --classpath stubs`) để tạo `classes32.dex`.
- Thay `classes32.dex` vào APK Facebook 588 đã gộp split & có hook `X.01Bu` bằng `rezip.py`, sau đó ký bằng `Sign.java`.

## Quy trình vá một ứng dụng mới
1. **Lấy APK từ máy**: `adb shell pm path <package>` rồi `adb pull` toàn bộ `base.apk` và `split_*.apk`.
2. **Kiểm tra Activity & configChanges**: `python3 tools/axml.py base.apk Main,Thread`.
3. **Tìm điểm hook**: tìm lớp kiểm tra màn rộng / `smallestScreenWidthDp` hoặc `Activity.recreate()` bằng `Dump.java`.
4. **Viết lớp vá** bằng Java (`--release 11 -encoding UTF-8`) hoặc smali, đặt trong package riêng và dịch thành `classesN.dex` mới.
5. **Chèn hook vào dex gốc** bằng `Prefix.java`, `Patch.java`, `Redirect.java`, rồi kiểm tra bằng `Verify.java`.
6. **Đóng gói & ký**: `rezip.py` → `MergeApk.java` (nếu có splits) → `Sign.java`.
