// ============================================================
// Feature 02 Model – PaymentOrder
// ============================================================

enum PaymentStatus { pending, checking, success, failed }

class PaymentOrder {
  final String orderId;
  final int amount; // VND, e.g. 50000
  final String description;
  PaymentStatus status;

  PaymentOrder({
    required this.orderId,
    required this.amount,
    required this.description,
    this.status = PaymentStatus.pending,
  });

  // Nội dung chuyển khoản (embeds orderId for matching)
  String get transferContent => '$orderId $description';

  // VietQR image URL (dùng trực tiếp trong Image.network)
  String get qrImageUrl {
    final encoded = Uri.encodeComponent(transferContent);
    const name    = 'NGUYEN%20VIET%20HOANG';
    return 'https://img.vietqr.io/image/ICB-102876493175-compact2.png'
        '?amount=$amount&addInfo=$encoded&accountName=$name';
  }

  String get amountFormatted {
    // Format: 50,000 đ
    final parts = <String>[];
    final s = amount.toString();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) parts.add(',');
      parts.add(s[i]);
    }
    return '${parts.join()} đ';
  }
}
