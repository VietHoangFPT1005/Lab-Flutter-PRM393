// ============================================================
// Feature 04 Entry Point – Notification Screen
// Run: flutter run --target=exam_features/feature_04_notifications/mainNotifications.dart
//
// Tính năng:
//   - Danh sách thông báo (tất cả / chưa đọc)
//   - Badge số thông báo chưa đọc
//   - Swipe xoá thông báo
//   - Nhấn để đánh dấu đã đọc
//   - Gửi local notification ngay lập tức
//   - Gửi local notification hẹn 5 giây
// ============================================================
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/notification_service.dart';
import 'screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(const NotificationsApp());
}

class NotificationsApp extends StatelessWidget {
  const NotificationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notification Demo',
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}
