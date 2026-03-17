import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _i = NotificationService._();
  factory NotificationService() => _i;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  Future<void> show(int id, String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'lab10_full', 'Lab10 Full',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(id, title, body, details);
  }

  Future<void> notifyLogin(String name) =>
      show(1, '✅ Login Successful', 'Welcome back, $name!');

  Future<void> notifyLogout() =>
      show(2, '👋 Logged Out', 'See you next time!');
}
