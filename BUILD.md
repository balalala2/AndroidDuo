# Hướng dẫn build & vá

## Chuẩn bị
- Java 17+, Python 3, `adb` (platform-tools).
- `morphe-desktop-2.3.0-all.jar` — chứa smali/dexlib2, apksig và ARSCLib; mọi công cụ trong `tools/` chạy bằng
  `java -cp morphe-desktop-2.3.0-all.jar tools/<Tool>.java ...` (Java chạy thẳng file nguồn, không cần biên dịch).
- `zsplit.jks` — khóa ký (PKCS12, alias `zsplit`). **Không có trong repo.** Phải dùng đúng khóa này thì mới cài đè được bản cũ.
- Các script `.sh` chạy trên Linux/macOS hoặc Git Bash/WSL trên Windows.

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

## Dựng lại Zalo
```sh
BASE=Zalo-v26.11.01-ZSplit-v0.6.apk sh build-zalo.sh   # -> Zalo-AndroidDuo-build.apk
```
- `src/zalo/classes.patched.dex` là `classes.dex` của Zalo đã chèn hook vào `com.zing.zalo.zview.b`
  (`b.C0`/`b.r0` gọi sang `ZSplit`, `addView/removeView` được chuyển hướng bằng `Redirect.java`).
- Các lớp `src/zalo/*.smali` được dịch thành `classes10.dex` mới. Script tự bỏ các dòng ghi log debug.
- `baseline.prof` bị xoá để ART không dùng profile cũ.

## Dựng lại Facebook
```sh
BASE=base.v1.apk SPLITS=fb-splits sh build-facebook.sh   # -> Facebook-AndroidDuo-build.apk
```
- `base.v1.apk`: base Facebook 588.0.0.42.55 đã có hook trong `X.01Bu` (`A04`/`A0A` gọi `FSplit.install`, `A0B`/`A0D` gọi `FSplit.isWide`).
- Thêm 2 bản vá chống tạo lại Activity khi gập/mở:
  - `FbMainTabActivityDelegate.shouldRecreateOnWindowResize` → luôn `false`
  - `X.0AkX.onConfigurationChanged` → bỏ `Activity.recreate()`
- `src/facebook/*.smali` → `classes32.dex`, sau đó gộp với các split và ký.

## Quy trình vá một ứng dụng mới (ví dụ Messenger)
1. **Lấy APK từ máy**
   ```sh
   adb shell pm path com.facebook.orca          # Messenger
   adb pull <từng đường dẫn base.apk / split_*.apk> msg/
   ```
2. **Tìm Activity chính & hành vi khi đổi cấu hình**: `python3 tools/axml.py msg/base.apk Main,Thread`.
   Nếu thiếu `configChanges` cho `screenSize|smallestScreenSize|screenLayout` thì app sẽ bị tạo lại khi gập/mở.
3. **Tìm điểm hook**: tìm lớp quyết định bố cục điện thoại/máy tính bảng (thường kiểm tra `smallestScreenWidthDp`/`isTablet`),
   các nơi gọi `Activity.recreate()` và các hàm kiểu `shouldRecreate...`. Dùng `Dump.java` để xem smali.
4. **Viết lớp vá** bằng smali (theo mẫu `ZSplit`/`FSplit`: hàm tĩnh `install(Activity)`, `isWide(Context)`...),
   đặt trong package riêng, ví dụ `com.zsplit.msg.MSplit`, rồi `Asm.java` thành `classesN.dex` mới (N = số dex hiện có + 1).
5. **Chèn hook vào dex gốc**: `Prefix.java` (gọi hàm của mình ở đầu method), `Patch.java` (`false`/`norecreate`), `Redirect.java` nếu cần can thiệp `addView`.
6. **Kiểm tra**: `Verify.java mine.dex <các dex của app>` — phải không còn lỗi trước khi cài.
7. **Đóng gói**: `rezip.py` thay các dex đã sửa → `MergeApk.java` gộp split → `Sign.java`.
8. **Cài & đọc log**: `adb install -r out.apk`, `adb logcat -s ZSplit AndroidRuntime` (FSplit ghi log ra file bằng hàm `flog`).

> Mã nguồn Messenger đang làm dở (`src-messenger`, lớp `MSplit`) nằm ở máy nhà, chưa có trong repo này.
