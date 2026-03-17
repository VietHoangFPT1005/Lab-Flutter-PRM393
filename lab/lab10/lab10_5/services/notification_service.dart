// Lab 10.5 – Local Notification Service
// Uses flutter_local_notifications package

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification plugin (call once in main)
  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initSettings);
  }

  /// Request notification permission (Android 13+ / iOS)
  Future<bool> requestPermission() async {
    final android =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return true; // iOS permission handled in initialize()
  }

  /// Show an instant local notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'lab10_channel',       // channel id
      'Lab 10 Notifications', // channel name
      channelDescription: 'Notifications for Lab 10 demo',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _plugin.show(id, title, body, details);
  }

  /// Show login success notification
  Future<void> notifyLoginSuccess(String username) async {
    await showNotification(
      id: 1001,
      title: '✅ Login Successful!',
      body: 'Welcome back, $username! You are now logged in.',
    );
  }

  /// Show logout notification
  Future<void> notifyLogout() async {
    await showNotification(
      id: 1002,
      title: '👋 Logged Out',
      body: 'You have been signed out successfully.',
    );
  }
}
