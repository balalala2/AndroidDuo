# Android Duo 2.2

Bộ bản vá giúp các ứng dụng phổ biến **tối ưu toàn diện cho điện thoại gập**: chia đôi màn hình 40/60 tận dụng màn trong rộng, thanh điều hướng nổi **Liquid Glass** (tự động kích hoạt engine kính lỏng phần cứng trên OriginOS và tự fallback sang AGSL shader trên các thiết bị gập khác), chuyển mượt giữa màn ngoài và màn trong.

| Ứng dụng | Dựa trên | Tải về (v2.2) |
|---|---|---|
| **Zalo Duo** | Zalo 26.11.02 | [ZaloDuo-2.2_26.11.02.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.2/ZaloDuo-2.2_26.11.02.apk) |
| **YouTube Duo** | YouTube 21.30.216 (Morphe) | [YouTubeDuo-2.2_21.30.216.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.2/YouTubeDuo-2.2_21.30.216.apk) |
| **Messenger Duo** | Messenger 576.0.0.47.92 | [MessengerDuo-2.2_576.0.0.47.92.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.2/MessengerDuo-2.2_576.0.0.47.92.apk) |
| **Facebook Duo** | Facebook 588.0.0.42.55 | [FacebookDuo-2.2_588.0.0.42.55.apk](https://github.com/balalala2/AndroidDuo/releases/download/v2.2/FacebookDuo-2.2_588.0.0.42.55.apk) |

Từ bản 2.2, mỗi ứng dụng mang tên riêng **Zalo Duo, YouTube Duo, Messenger Duo, Facebook Duo** để dễ phân biệt với bản gốc.

---

## Tính năng nổi bật

### Engine Liquid Glass phần cứng + AGSL Fallback
- **Tự động nhận diện phần cứng**: ưu tiên engine kính lỏng phần cứng (chế độ Sáng / Tối đồng bộ theo giao diện hệ thống), tự động chuyển sang shader AGSL + `RenderEffect` trên các thiết bị Android 13+ khác.
- **Vật lý lò xo 120Hz độc lập tốc độ khung hình**: chuyển tab và kéo thanh dock mượt mà, phóng đại thấu kính khi kéo tay và thả bật về tab tự nhiên.
- **Chống tối nền / nháy bóng**: tối ưu cờ vẽ lớp phần cứng, loại bỏ hoàn toàn hiện tượng tối dần khi con trỏ nhập liệu nhấp nháy hoặc bóng mờ dưới thanh dock.

### Zalo Duo (`26.11.02`) — Nâng cấp lớn trong v2.2
- **Chia đôi màn trong 40/60 thông minh theo từng tab (không còn màn chờ "Chọn một cuộc trò chuyện")**:
  - **Tab Tin nhắn**: danh sách hội thoại bên trái, khung chat bên phải; tự mở sẵn cuộc trò chuyện mặc định khi vào app.
  - **Tab Danh bạ**: danh sách danh bạ bên trái hiển thị ngay (hết lỗi kẹt vòng xoay loading), tự mở sẵn **Cloud của tôi** bên phải.
  - **Tab Tường nhà (Nhật ký)**: vô hiệu hóa hoàn toàn **Zalo Video** (`Lovu`), mở thẳng bảng tin Nhật ký bên trái và tự mở bảng **Thông báo** bên phải; nhấn Back từ Thông báo giữ đúng bố cục 2 cột và trạng thái chọn Tab 3.
  - **Tab Cá nhân**: tự mở sẵn **Cloud của tôi** bên phải.
- **Giữ nguyên trải nghiệm máy thanh ở màn ngoài**: khi gập về màn ngoài (`< 550dp`), chia đôi và auto-open panel phải tự tắt hoàn toàn, Zalo hoạt động đúng như máy thanh bình thường.
- **Dock Liquid Glass nổi** (cả màn trong và màn ngoài): vị trí, tỉ lệ và trạng thái chọn tab chuẩn xác trên cả 4 tab kể cả khi chuyển qua lại Nhật ký / Thông báo.
- **Cửa sổ nổi Liquid Glass**: cài đặt, hồ sơ và màn hình phụ mở dạng thẻ nổi bo góc ở giữa, chạm ra ngoài để đóng.
- **Trang `Cài đặt khác` hợp nhất**: gom toàn bộ tùy chỉnh nâng cao vào một trang tiếng Việt sạch sẽ, không quảng cáo hay thương hiệu bên thứ ba.

### YouTube Duo (`21.30.216`, bản Morphe) — Gập mở không mất video
- **2 cột màn trong ↔ 1 cột màn ngoài KHÔNG reload feed**: luôn dùng `LARGE_FORM_FACTOR (2)` để YouTube nhận bảng breakpoint responsive gốc (`Lauam`) và tắt hoàn toàn `SwipeRefreshLayout` tự động khi gập/mở.
  - Mở màn trong (`>= 580dp`): **2 cột** thẻ dọc chuẩn.
  - Gập vào màn ngoài (`< 580dp`): tự thu về **1 cột** kiểu máy thanh, không tải lại.
  - Mở ra lại màn trong: bật ngay về **2 cột** với **y nguyên danh sách video và vị trí cuộn cũ**, không còn bị biến thành 1 cột tiêu đề bên phải hay mất video đang định xem.
- **Dock Liquid Glass nổi**: đồng bộ lò xo & giọt nước theo Zalo, tự hạ gọn ở tab Shorts. Cần MicroG / GmsCore.

### Messenger Duo (`576.0.0.47.92`)
- **Icon Liquid Glass kiểu iOS 26** (mới trong v2.2).
- **Chia đôi màn trong 40/60 cho cả Tin nhắn và Cài đặt**: tích hợp `ActivityEmbeddingComponent` gốc của Android để chia đôi cả trang Cài đặt mượt mà.
- **Dock Liquid Glass toàn vẹn** và tự nâng vị trí nút nổi Meta AI trên mọi tab.

### Facebook Duo (`588.0.0.42.55`)
- **Icon Liquid Glass kiểu iOS 26** (mới trong v2.2), chữ "f" đúng tỉ lệ bản gốc, viền kính ôm sát bốn cạnh.
- **Dock và giọt nước bo đồng tâm**: viên chọn tab cách đều viền dock 4dp ở mọi góc.
- **Dock Liquid Glass thích ứng hai màn hình** (ngang ở màn ngoài, dọc cố định bên trái ở màn trong), mở khóa tab Reels màn trong, cắt viền phần cứng cho ViewPager.

---

## Changelog

### v2.2 — "Mở ra là xong"
- **Đổi tên**: các bản vá giờ mang tên **Zalo Duo, YouTube Duo, Messenger Duo, Facebook Duo**; file APK đặt theo dạng `<Tên>Duo-<phiên bản Duo>_<phiên bản gốc>.apk`.
- **Zalo (`26.11.02`)**:
  - Cập nhật lên Zalo `26.11.02` và vá triệt để 4 tab màn trong: không còn hiện màn hình trống *"Chọn một cuộc trò chuyện"*, tự mở nội dung panel phải phù hợp từng tab (Cloud của tôi cho Danh bạ/Cá nhân, Thông báo cho Tường nhà).
  - Gỡ bỏ hoàn toàn **Zalo Video** (`Lovu`) để vào Tab Tường nhà luôn hiển thị Nhật ký ngay lập tức.
  - Chặn vòng đời `zview.b.n0` (`keepMainState`) + sửa `ContactTabZaloView.Y6` giúp Panel trái (Tin nhắn & Danh bạ) **không bao giờ bị kẹt loading** khi panel phải đang mở.
  - Sửa lỗi thanh Dock bị tràn ngang và mất trạng thái chọn Tab 3 khi mở/đóng Thông báo trong Tường nhà, sửa lỗi văng app khi mở nhanh panel phải.
  - Khôi phục 100% hành vi gốc kiểu máy thanh khi gập về màn ngoài.
- **YouTube (`21.30.216`)**:
  - Sửa triệt để lỗi gập màn trong → màn ngoài → mở lại màn trong bị biến thành **1 cột tiêu đề bên phải** hoặc bị **tự reload mất video định xem**.
  - Bỏ `triggerSwipeRefresh()` trong `YGlass.checkFoldRefresh()` và luôn trả về `LARGE_FORM_FACTOR (2)` trong `YGlass.getDynamicFormFactor()` để tận dụng engine lưới responsive gốc (`Lauam`) của YouTube chuyển `2 cột ↔ 1 cột` 100% phía client không cần tải lại mạng.
- **Facebook (`588.0.0.42.55`)**:
  - Cập nhật icon ứng dụng **iOS 26 Liquid Glass** chuẩn Adaptive Icon (`mipmap/icon_katana_foreground` + legacy PNG).
  - Tinh chỉnh hình học đồng tâm cho thanh Dock và giọt nước (`FGlass.geom()`): viên chọn tab bo cong đồng tâm chuẩn xác (`r_inner = r_outer - 4dp`, khoảng hở đều `4dp` mọi góc), giọt nước lướt thon gọn với viền sáng khớp sát mép SDF, bỏ bóng mờ thừa khi bật kính lỏng phần cứng Vivo.
  - Trang chủ: dòng *"Bạn đang nghĩ gì?"* không còn bị thanh tiêu đề che mất nửa trên (`FSplit`: mọi tab trừ Reels đều nhận `topMargin` = chiều cao thanh tiêu đề, kể cả Home).
  - Trang cá nhân: tự động phát hiện và loại bỏ dải xám `#A6A6A6` trên ảnh bìa (cả màn trong và màn ngoài) bằng `PixelCopy` + khóa tỉ lệ `onPreDraw`, giúp ảnh bìa khít sát mép trên màn hình.
  - Đồng bộ màu nền cột trái đúng mã màu nền tối gốc `#252728`.
- **Messenger (`576.0.0.47.92`)**:
  - Cập nhật icon ứng dụng **iOS 26 Liquid Glass** chuẩn Adaptive Icon (`mipmap/launcher_icon_foreground` + legacy PNG).
- **Tài liệu & Công cụ**:
  - Bổ sung `tools/RebuildDex.java`, `tools/SplitDex.java` và viết lại toàn diện [BUILD.md](BUILD.md) sẵn sàng cho quy trình build/vá bằng Antigravity ở cả Windows PowerShell và Linux/macOS.

### v2.1
- **Mới**: thêm **YouTube (`21.30.216`, bản Morphe)**: 2 cột màn trong, dock Liquid Glass, tự hạ dock ở tab Shorts. Cần MicroG / GmsCore.
- **Dock YouTube, Messenger, Facebook đồng bộ theo Zalo**: lò xo và giọt nước giống Zalo, giọt phình ~1,4 ô tab; icon tô kín và đổi màu thương hiệu bên trong giọt; tab đang chọn chuyển xám khi giọt rời đi; viên kính đứng yên nằm sau icon.
- **Giao diện tối**: dock theo chế độ tối của chính app; tên tab trắng trên nền tối; viên kính và giọt nước sáng hơn.
- **Facebook**: viên chọn tab không còn phủ mờ lên icon.
- **Messenger**: bỏ bóng đổ quanh viên kính; tên tab cũ hết xanh ngay khi đổi tab.

### v2.0
- **Mới**: Bổ sung **Messenger (`v576.0.0.47.92`)** với chia đôi 40/60 (Tin nhắn + Cài đặt), dock Liquid Glass đồng bộ và tự nâng nút Meta AI trên mọi tab.
- **Nâng cấp lớn — Liquid Glass Engine**: chuyển sang engine kính lỏng phần cứng (kèm fallback AGSL), hoạt ảnh lò xo 120Hz, xử lý triệt để lỗi tối dần khi nháy con trỏ và nháy bóng dock.
- **Zalo (`26.11.01`)** & **Facebook (`588.0.0.42.55`)**: hợp nhất trang `Cài đặt khác`, nâng thanh `Hoàn tác`/`Khôi phục`, sửa nháy khung chat (`prePosition`), mở khóa Reels màn trong.

### v1.0
- Phát hành đầu tiên cho **Zalo (`26.11.01`)** và **Facebook (`588.0.0.42.55`)**.

---

## Cài đặt
```sh
adb install -r ZaloDuo-2.2_26.11.02.apk
adb install -r YouTubeDuo-2.2_21.30.216.apk
adb install -r MessengerDuo-2.2_576.0.0.47.92.apk
adb install -r FacebookDuo-2.2_588.0.0.42.55.apk
```
- Tất cả APK đều được ký cùng khóa dự án (cert SHA-256 `8c3408403a657900eab0ba56d2a5871b3d9e2eb002bad73f0993f7084f8d21db`), cài đè trực tiếp lên các bản Android Duo trước mà **không mất dữ liệu**.
- Nếu đang dùng bản chính thức từ CH Play (hoặc YouTube ký bằng khóa khác), cần gỡ bản cũ trước khi cài.
- Yêu cầu Android 10+; hiệu ứng kính lỏng đầy đủ yêu cầu Android 13+ (hoặc thiết bị hỗ trợ engine kính lỏng phần cứng).

## Mã nguồn
```
src/zalo/       lớp com.zing.zalo.zsplit.* (ZSplit.smali, ZTL.smali, ZGlass.java, ...)
src/messenger/  lớp com.zsplit.msg.* (MSplit, MDock, MGlass, PrefSplit, TabFx)
src/facebook/   lớp com.zsplit.fb.* (FSplit, FGlass, TabFx) + compile stubs
src/youtube/    lớp com.zsplit.yt.* (YGlass, TabFx)
tools/          công cụ build: RebuildDex, SplitDex, Asm, Verify, Sign, rezip, axml, MergeApk
```
Hướng dẫn build chi tiết (bao gồm toàn bộ điểm hook bytecode & lệnh dựng trên Windows/Linux cho Antigravity): xem [BUILD.md](BUILD.md).

> Dự án cá nhân, không liên quan tới VNG, Google hay Meta. Dùng với rủi ro của riêng bạn.
