// ============================================================
// Feature 02 Config – SePay Payment
// !! Điền API Key của bạn vào đây trước khi chạy !!
// Lấy tại: sepay.vn → Đăng nhập → Tích hợp → API
// ============================================================

class SePayConfig {
  // ─── ĐIỀN VÀO ĐÂY ───────────────────────────────────────
  static const String apiKey = 'YOUR_SEPAY_API_KEY'; // ← thay thế

  // ─── Thông tin tài khoản ngân hàng ──────────────────────
  static const String bankCode      = 'ICB';                // VietinBank
  static const String accountNumber = '102876493175';
  static const String accountName   = 'NGUYEN VIET HOANG';

  // ─── SePay API endpoint ──────────────────────────────────
  static const String transactionListUrl =
      'https://my.sepay.vn/userapi/transactions/list';

  // ─── VietQR base URL (free, no auth) ────────────────────
  static String vietQrUrl({
    required int amount,
    required String content,
  }) {
    final encoded = Uri.encodeComponent(content);
    final name    = Uri.encodeComponent(accountName);
    return 'https://img.vietqr.io/image/$bankCode-$accountNumber-compact2.png'
        '?amount=$amount&addInfo=$encoded&accountName=$name';
  }
}
