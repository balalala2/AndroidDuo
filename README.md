# Android Duo 2.0

Bộ bản vá giúp các ứng dụng phổ biến **tối ưu toàn diện cho điện thoại gập**: chia đôi màn hình 40/60 tận dụng màn trong rộng, thanh điều hướng nổi **Liquid Glass** (tự động kích hoạt engine kính lỏng phần cứng trên OriginOS và tự fallback sang AGSL shader trên các thiết bị gập khác), chuyển mượt giữa màn ngoài và màn trong.

| Ứng dụng | Phiên bản gốc | Tải về (v2.0) |
|---|---|---|
| **Zalo** | 26.11.01 | [Zalo-v26.11.01-AndroidDuo-2.0.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.0/Zalo-v26.11.01-AndroidDuo-2.0.apk) |
| **Messenger** | 576.0.0.47.92 | [Messenger-v576.0.0.47.92-AndroidDuo-2.0.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.0/Messenger-v576.0.0.47.92-AndroidDuo-2.0.apk) |
| **Facebook** | 588.0.0.42.55 | [Facebook-v588.0.0.42.55-AndroidDuo-2.0.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.0/Facebook-v588.0.0.42.55-AndroidDuo-2.0.apk) |

---

## Tính năng nổi bật

### Engine Liquid Glass phần cứng + AGSL Fallback (cả 3 ứng dụng)
- **Tự động nhận diện phần cứng**: ưu tiên engine kính lỏng phần cứng (chế độ Sáng / Tối đồng bộ theo giao diện hệ thống), tự động chuyển sang shader AGSL + `RenderEffect` trên các thiết bị Android 13+ khác.
- **Vật lý lò xo 120Hz độc lập tốc độ khung hình**: chuyển tab và kéo thanh dock mượt mà, phóng đại thấu kính khi kéo tay và thả bật về tab tự nhiên.
- **Chống tối nền / nháy bóng**: tối ưu cờ vẽ lớp phần cứng, loại bỏ hoàn toàn hiện tượng tối dần khi con trỏ nhập liệu nhấp nháy hoặc bóng mờ dưới thanh dock.

### Zalo (`v26.11.01`)
- **Chia đôi màn trong 40/60**: danh sách hội thoại bên trái, khung chat bên phải; giữ nguyên trạng thái chia đôi khi quay lại từ đa nhiệm.
- **Dock Liquid Glass nổi** (cả màn trong và màn ngoài): viên kính chọn tab nằm phía sau icon/badge giúp màu sắc và chấm thông báo luôn rõ nét; kéo tay để phóng đại thấu kính.
- **Cửa sổ nổi Liquid Glass**: cài đặt, hồ sơ và màn hình phụ mở dạng thẻ nổi bo góc ở giữa, chạm ra ngoài để đóng.
- **Trang `Cài đặt khác` hợp nhất**: gom toàn bộ tùy chỉnh nâng cao vào một trang tiếng Việt sạch sẽ, có dấu đầy đủ, không quảng cáo hay thương hiệu bên thứ ba.
- **Tối ưu bố cục & tương tác**:
  - Tự đẩy thanh thông báo `Hoàn tác` / `Khôi phục` (khi xóa hội thoại) lên gọn phía trên thanh dock, không che thanh nhập chat.
  - Tự thêm khoảng đệm đáy cho danh sách để dòng cuối không bị dock che khuất.
  - Định vị khung chat ngay trước khi gắn view, loại bỏ hiện tượng nháy 1 khung hình dưới dock.
  - Xử lý tức thì khi gập từ màn trong về màn ngoài và vuốt quay lại, tránh lỗi khung chat bị ép hẹp.

### Messenger (`v576.0.0.47.92`) — Mới trong v2.0
- **Chia đôi màn trong 40/60 cho cả Tin nhắn và Cài đặt**: tích hợp `ActivityEmbeddingComponent` gốc của Android để chia đôi cả trang Cài đặt mượt mà.
- **Dock Liquid Glass toàn vẹn**: thu nhỏ đồng bộ icon, chấm đỏ thông báo và nhãn tiếng Việt bên trong viên kính bo tròn hoàn toàn; không còn vệt nền chữ nhật hay bóng đè mặc định.
- **Nút Meta AI hiển thị đúng trên mọi tab**: tự động nâng vị trí nút nổi Meta AI ở cả tab Tin nhắn, Danh bạ, Thông báo và Menu để không bị thanh dock che khuất.

### Facebook (`v588.0.0.42.55`)
- **Dock Liquid Glass thích ứng hai màn hình**:
  - **Màn ngoài**: thanh dock nổi ở đáy, tự động ẩn khi cuộn xuống và hiện lại khi cuộn lên, cân bằng độ trong suốt khi xem video.
  - **Màn trong**: thanh điều hướng dọc dạng viên thuốc nổi bên cạnh trái, vị trí cố định đồng nhất trên cả 6 tab, hiển thị đủ toàn bộ icon kể cả ở Chế độ tối.
- **Hỗ trợ tab Reels trên màn trong**: hiển thị toàn màn hình nền đen chuẩn với thanh kính tối.
- **Cắt viền phần cứng cho ViewPager**: loại bỏ hoàn toàn hiện tượng nội dung tab tràn sang phía sau thanh dock dọc.
- **Chuyển đổi màn trong / màn ngoài sạch sẽ**: tự động làm mới bố cục một lần duy nhất khi gập/mở vượt ngưỡng 600dp, loại bỏ lỗi lệch kích thước thẻ Tin (Stories).
- **Loại bỏ khung xám vuông khi nhấn tab**.

---

## Changelog

### v2.0
- **Mới**: Bổ sung **Messenger (`v576.0.0.47.92`)** với chia đôi 40/60 (Tin nhắn + Cài đặt), dock Liquid Glass đồng bộ và tự nâng nút Meta AI trên mọi tab.
- **Nâng cấp lớn — Liquid Glass Engine**: chuyển sang engine kính lỏng phần cứng (kèm fallback AGSL), hoạt ảnh lò xo 120Hz, xử lý triệt để lỗi tối dần khi nháy con trỏ và nháy bóng dock.
- **Zalo**:
  - Hợp nhất trang **`Cài đặt khác`** tiếng Việt đầy đủ, loại bỏ hoàn toàn tên/nhãn mod cũ.
  - Nâng thanh `Hoàn tác` / `Khôi phục` lên trên dock; thêm đệm đáy cho toàn bộ danh sách cuộn.
  - Sửa lỗi nháy khung chat ở cạnh trái 1 khung hình khi mở hội thoại (`prePosition`).
  - Sửa lỗi khung chat bị bóp hẹp khi gập từ màn trong về màn ngoài rồi vuốt Back.
  - Tăng `versionCode` để cài đè giữ nguyên dữ liệu từ bản v1.0.
- **Facebook**:
  - Thêm thanh dock nổi Liquid Glass (ngang ở màn ngoài, dọc cố định ở màn trong) + tự ẩn khi cuộn ở màn ngoài.
  - Mở khóa và tối ưu tab **Reels** trên màn trong.
  - Sửa lệch vị trí dock giữa các tab, sửa viền rỗng ở Chế độ tối và sửa lỗi ẩn mất icon cài đặt cuối cùng.
  - Sửa lỗi tràn nội dung tab qua thanh dock và lỗi lệch thẻ Stories khi gập/mở.
  - Bỏ khung xám vuông mặc định khi bấm tab.

### v1.0
- Phát hành đầu tiên cho **Zalo (`26.11.01`)** (chia đôi màn trong, thẻ nổi, dock AGSL) và **Facebook (`588.0.0.42.55`)** (giao diện màn rộng màn trong, gập/mở không khởi động lại).

---

## Cài đặt
```sh
adb install -r Zalo-v26.11.01-AndroidDuo-2.0.apk
adb install -r Messenger-v576.0.0.47.92-AndroidDuo-2.0.apk
adb install -r Facebook-v588.0.0.42.55-AndroidDuo-2.0.apk
```
- Các APK được ký cùng khóa của dự án (cert SHA-256 `8c3408403a657900eab0ba56d2a5871b3d9e2eb002bad73f0993f7084f8d21db`), cài đè trực tiếp lên bản Android Duo 1.0 mà **không mất dữ liệu**.
- Nếu đang dùng bản chính thức từ CH Play, cần **gỡ bản đó trước** (khác chữ ký). Hãy sao lưu tin nhắn Zalo trước khi gỡ.
- Yêu cầu Android 10+; hiệu ứng kính lỏng đầy đủ yêu cầu Android 13+ (hoặc thiết bị hỗ trợ engine kính lỏng phần cứng).
- **Lưu ý nhỏ với Facebook → Messenger**: do ứng dụng chính thức của Meta kiểm tra chữ ký số cứng khi chuyển chéo ứng dụng, nút mở nhanh Messenger bên trong Facebook có thể không tự chuyển app — vui lòng mở Messenger trực tiếp từ màn hình chính hoặc đa nhiệm.

## Mã nguồn
```
src/zalo/       lớp com.zing.zalo.zsplit.* (ZGlass.java + smali + classes.patched.dex)
src/messenger/  lớp com.zsplit.msg.* (MSplit, MDock, MGlass, PrefSplit)
src/facebook/   lớp com.zsplit.fb.* (FSplit, FGlass) + compile stubs
tools/          công cụ build: dịch smali, vá dex, đóng gói, gộp split, ký
```
Hướng dẫn build và cách vá thêm ứng dụng khác: xem [BUILD.md](BUILD.md).

> Dự án cá nhân, không liên quan tới VNG hay Meta. Dùng với rủi ro của riêng bạn.
