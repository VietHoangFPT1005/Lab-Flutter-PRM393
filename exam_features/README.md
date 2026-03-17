# 📚 EXAM FEATURES – Hướng dẫn thi Flutter

> Folder này chứa source code **hoàn chỉnh** cho 5 tính năng thi.
> Mỗi feature có thể chạy **độc lập** hoặc **copy vào project bất kỳ**.

---

## ⚡ Cách chạy nhanh từng feature

```bash
# Feature 01 – OpenStreetMap
flutter run --target=exam_features/feature_01_openstreetmap/mainOSM.dart

# Feature 02 – SePay Payment
flutter run --target=exam_features/feature_02_sepay/mainSePay.dart

# Feature 03 – OTP Email
flutter run --target=exam_features/feature_03_otp_email/mainOTP.dart

# Feature 04 – Notification Screen
flutter run --target=exam_features/feature_04_notifications/mainNotifications.dart

# Feature 05 – Gemini Chat AI
flutter run --target=exam_features/feature_05_chat_ai/mainChatAI.dart
```

---

## 🗂️ Cấu trúc folder

```
exam_features/
├── feature_01_openstreetmap/   ← Bản đồ OSM
├── feature_02_sepay/           ← Thanh toán VietQR + SePay
├── feature_03_otp_email/       ← Đăng ký + OTP qua Gmail
├── feature_04_notifications/   ← Màn hình thông báo
└── feature_05_chat_ai/         ← Chat với Gemini AI
```

---

## 🔧 SETUP 1 LẦN (BẮT BUỘC trước khi thi)

### Bước 1: Packages đã được thêm vào `pubspec.yaml`
```yaml
flutter_map: ^7.0.2    # OSM
latlong2: ^0.9.1        # OSM
geolocator: ^13.0.1    # GPS
mailer: ^6.2.0         # Gmail SMTP
```
Chạy: `flutter pub get`

---

## 📋 Chi tiết từng Feature

---

### Feature 01 – OpenStreetMap 🗺️

**Files:**
```
feature_01_openstreetmap/
├── mainOSM.dart
└── screens/map_screen.dart
```

**Tính năng:**
- Hiển thị bản đồ OpenStreetMap (miễn phí, không cần API key)
- Nhấn vào bản đồ để đặt marker đỏ
- Hiển thị tọa độ lat/lng
- Nút GPS → nhảy đến vị trí thật của thiết bị

**Không cần cấu hình gì thêm** – chạy được ngay!

**Copy vào project:**
1. Copy folder `screens/map_screen.dart`
2. Import và dùng: `Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()))`

---

### Feature 02 – SePay Payment 💳

**Files:**
```
feature_02_sepay/
├── mainSePay.dart
├── config/sepay_config.dart    ← ĐIỀN API KEY
├── models/payment_order.dart
├── services/sepay_service.dart
└── screens/payment_screen.dart
```

**SETUP:**
1. Mở `config/sepay_config.dart`
2. Thay `YOUR_SEPAY_API_KEY` bằng key từ **sepay.vn → Tích hợp → API**

**Tính năng:**
- Nhập số tiền + nội dung chuyển khoản
- Tự tạo mã QR VietQR (ảnh từ img.vietqr.io)
- Tự động kiểm tra giao dịch qua SePay API mỗi 5 giây
- Hiện dialog thành công/thất bại

**Flow:**
```
Nhập tiền → [Tạo QR] → Hiện QR code → Auto-check 5s → ✅ Thành công
```

**Thông tin tài khoản đã cấu hình:**
- Ngân hàng: VietinBank
- STK: 102876493175
- Chủ TK: NGUYEN VIET HOANG

---

### Feature 03 – OTP Email (Gmail) 🔐

**Files:**
```
feature_03_otp_email/
├── mainOTP.dart
├── config/email_config.dart    ← ĐIỀN GMAIL + APP PASSWORD
├── services/otp_service.dart
└── screens/
    ├── register_screen.dart
    └── otp_verify_screen.dart
```

**SETUP:**
1. Mở `config/email_config.dart`
2. Điền `gmailAddress` = địa chỉ Gmail của bạn
3. Điền `gmailAppPassword` = App Password (xem hướng dẫn bên dưới)

**Cách lấy Gmail App Password:**
```
myaccount.google.com
→ Bảo mật
→ Xác minh 2 bước (bật nếu chưa có)
→ Mật khẩu ứng dụng
→ Tạo mới → Chọn "Thư" → Thiết bị khác
→ Copy 16 ký tự (dạng: abcd efgh ijkl mnop)
```

**Tính năng:**
- Form đăng ký: Họ tên + Email + Mật khẩu (validation đầy đủ)
- Gửi OTP 6 số đến email thật qua Gmail SMTP
- Màn hình nhập 6 ô OTP (tự chuyển focus)
- Đếm ngược 5 phút, nút Gửi lại OTP
- Tự verify khi nhập xong ô cuối
- Giới hạn 3 lần nhập sai

**Flow:**
```
Form đăng ký → [Gửi OTP] → Email gửi OTP → Nhập 6 số → ✅ Đăng ký thành công
```

---

### Feature 04 – Notification Screen 🔔

**Files:**
```
feature_04_notifications/
├── mainNotifications.dart
├── models/notification_item.dart
├── services/notification_service.dart
└── screens/notification_screen.dart
```

**Không cần cấu hình gì** – dùng `flutter_local_notifications` đã có sẵn.

**Tính năng:**
- Danh sách thông báo với 2 tab: Tất cả / Chưa đọc
- Badge số thông báo chưa đọc trên AppBar
- 4 loại thông báo: 📢 Info, ✅ Success, ⚠️ Warning, 🎁 Promo
- Nhấn thông báo → toggle đọc/chưa đọc
- Swipe trái → xoá thông báo
- Nút "Đọc tất cả"
- Nút test: Gửi local notification ngay lập tức
- Nút test: Hẹn 5 giây

---

### Feature 05 – Gemini Chat AI 🤖

**Files:**
```
feature_05_chat_ai/
├── mainChatAI.dart
├── config/gemini_config.dart    ← ĐIỀN API KEY
├── models/chat_message.dart
├── services/gemini_service.dart
└── screens/chat_screen.dart
```

**SETUP:**
1. Vào **aistudio.google.com** → Đăng nhập Google
2. Click **"Get API key"** → **"Create API key"**
3. Mở `config/gemini_config.dart`
4. Thay `YOUR_GEMINI_API_KEY` bằng key vừa tạo

**Tính năng:**
- Chat UI với bubble (user bên phải, AI bên trái)
- Duy trì context cuộc hội thoại (AI nhớ lịch sử chat)
- Typing indicator (3 chấm nhảy)
- Xử lý lỗi (hiện thông báo lỗi trong bubble)
- Nút xoá lịch sử chat
- Không cần cài thêm package (dùng `http` sẵn có)

**Model:** `gemini-1.5-flash` (miễn phí, nhanh)

---

## 📋 Checklist trước khi thi

- [ ] `flutter pub get` (sau khi thêm packages)
- [ ] Feature 02: Điền SePay API key vào `sepay_config.dart`
- [ ] Feature 03: Điền Gmail + App Password vào `email_config.dart`
- [ ] Feature 05: Điền Gemini API key vào `gemini_config.dart`
- [ ] Feature 01 & 04: Không cần cấu hình gì

---

## 🔀 Copy nhanh vào project exam

Nếu đề thi yêu cầu tích hợp vào app của bạn:

**Bước 1:** Copy nguyên folder feature vào project exam của bạn

**Bước 2:** Thêm packages vào `pubspec.yaml` của project đó:
```yaml
# OSM
flutter_map: ^7.0.2
latlong2: ^0.9.1
geolocator: ^13.0.1

# OTP
mailer: ^6.2.0
```

**Bước 3:** Chạy `flutter pub get`

**Bước 4:** Navigate đến screen:
```dart
// Mở màn hình bất kỳ
Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()));
Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
```

**Bước 5:** Fix đường dẫn import nếu cần (thay đổi relative path)

---

*Chúc bạn thi tốt! 🎯*
