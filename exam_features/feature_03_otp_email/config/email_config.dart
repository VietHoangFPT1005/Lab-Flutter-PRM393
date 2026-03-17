// ============================================================
// Feature 03 Config – OTP via Gmail SMTP
//
// !! ĐIỀN VÀO ĐÂY TRƯỚC KHI CHẠY !!
//
// Cách lấy Gmail App Password:
//   1. Vào myaccount.google.com → Bảo mật
//   2. Bật Xác minh 2 bước (nếu chưa bật)
//   3. Tìm "Mật khẩu ứng dụng" → Tạo mới
//   4. Chọn "Thư" → "Thiết bị khác"
//   5. Copy 16 ký tự (dạng: xxxx xxxx xxxx xxxx)
// ============================================================

class EmailConfig {
  // ─── ĐIỀN VÀO ĐÂY ───────────────────────────────────────
  static const String gmailAddress    = 'your.gmail@gmail.com'; // ← Gmail của bạn
  static const String gmailAppPassword = 'xxxx xxxx xxxx xxxx'; // ← App Password
  static const String senderName      = 'App Verification';
  // ────────────────────────────────────────────────────────

  // OTP expiry in minutes
  static const int otpExpiryMinutes = 5;
}
