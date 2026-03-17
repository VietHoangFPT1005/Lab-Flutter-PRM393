// ============================================================
// Feature 04 Model – NotificationItem
// ============================================================

enum NotificationType { info, success, warning, promo }

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.type = NotificationType.info,
    DateTime? createdAt,
    this.isRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  // Icon for each type
  static const Map<NotificationType, ({String icon, int colorValue})> typeStyle = {
    NotificationType.info:    (icon: '📢', colorValue: 0xFF2196F3),
    NotificationType.success: (icon: '✅', colorValue: 0xFF4CAF50),
    NotificationType.warning: (icon: '⚠️', colorValue: 0xFFFF9800),
    NotificationType.promo:   (icon: '🎁', colorValue: 0xFF9C27B0),
  };

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inSeconds < 60)  return 'Vừa xong';
    if (diff.inMinutes < 60)  return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24)    return '${diff.inHours} giờ trước';
    return '${diff.inDays} ngày trước';
  }
}
