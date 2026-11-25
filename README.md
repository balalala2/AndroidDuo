# Android Duo 1.0

Bộ bản vá giúp các ứng dụng phổ biến **tối ưu cho điện thoại gập**: tận dụng màn trong rộng, chuyển mượt giữa màn ngoài và màn trong mà không khởi động lại ứng dụng.

| Ứng dụng | Phiên bản gốc | Tải về |
|---|---|---|
| Zalo | 26.11.01 | [Zalo-v26.11.01-AndroidDuo-1.0.apk](https://github.com/balalala2/AndroidDuo/releases/download/v1.0/Zalo-v26.11.01-AndroidDuo-1.0.apk) |
| Facebook | 588.0.0.42.55 | [Facebook-v588.0.0.42.55-AndroidDuo-1.0.apk](https://github.com/balalala2/AndroidDuo/releases/download/v1.0/Facebook-v588.0.0.42.55-AndroidDuo-1.0.apk) |

## Zalo
- **Chia đôi màn trong**: danh sách chat bên trái, đoạn chat bên phải. Giữ chia đôi khi mở lại từ đa nhiệm và khi app bị hệ thống khôi phục.
- **Cửa sổ nổi liquid glass**: cài đặt, hồ sơ và các màn phụ mở thành một thẻ nổi bo góc ở giữa, nền phía sau làm mờ. Chạm ra ngoài để đóng.
- **Dock liquid glass** (cả màn trong lẫn màn ngoài): thanh 4 tab dạng viên thuốc nổi, danh sách cuộn được bên dưới.
  - Viên kính đánh dấu tab đang chọn, có khúc xạ mép, tách màu và bóng.
  - Kéo được bằng tay: viên kính phình thành thấu kính, phóng to icon, thả ra bật về tab như lò xo.
  - Đã tắt hiệu ứng gợn sóng xám mặc định của tab.

## Facebook
- **Giao diện màn rộng trên màn trong**, tự trở về giao diện điện thoại khi dùng màn ngoài.
- **Gập/mở không khởi động lại ứng dụng**: tắt cơ chế tạo lại Activity khi đổi kích thước cửa sổ, giữ nguyên bảng tin đang xem.
- APK đã gộp sẵn các split, cài bằng một file duy nhất.

## Cài đặt
```
adb install -r Zalo-v26.11.01-AndroidDuo-1.0.apk
adb install -r Facebook-v588.0.0.42.55-AndroidDuo-1.0.apk
```
- Các APK được ký bằng khóa riêng của dự án (cert SHA-256 `8c3408403a657900eab0ba56d2a5871b3d9e2eb002bad73f0993f7084f8d21db`), cài đè được lên các bản thử nghiệm trước (ZSplit/FSplit).
- Nếu đang dùng bản chính thức từ CH Play, cần **gỡ bản đó trước** (khác chữ ký). Hãy sao lưu tin nhắn Zalo trước khi gỡ.
- Yêu cầu Android 10+; hiệu ứng khúc xạ của dock cần Android 13+.

## Mã nguồn
```
src/zalo/       lớp com.zing.zalo.zsplit.* (smali) + classes.patched.dex
src/facebook/   lớp com.zsplit.fb.FSplit* (smali)
tools/          công cụ build: dịch smali, vá dex, đóng gói, gộp split, ký
build-zalo.sh   dựng lại APK Zalo
build-facebook.sh dựng lại APK Facebook
```
Hướng dẫn build và cách vá thêm ứng dụng khác: xem [BUILD.md](BUILD.md).

> Dự án cá nhân, không liên quan tới VNG hay Meta. Dùng với rủi ro của riêng bạn.
