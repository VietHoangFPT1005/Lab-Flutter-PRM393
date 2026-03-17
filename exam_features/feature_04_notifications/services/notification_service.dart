// ============================================================
// Feature 04 Service – Local Notifications
// Uses: flutter_local_notifications (already in pubspec.yaml)
// ============================================================

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  // ── Initialize (call once in main or initState) ───────────
  static Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap here if needed
      },
    );

    // Request permission (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  // ── Show immediate notification ───────────────────────────
  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Thông báo chính',
      channelDescription: 'Kênh thông báo mặc định',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, details, payload: payload);
  }

  // ── Schedule notification (after delay in seconds) ────────
  // Note: uses Future.delayed – works while app is running
  static void scheduleAfter({
    required int id,
    required String title,
    required String body,
    required int delaySeconds,
  }) {
    Future.delayed(Duration(seconds: delaySeconds), () {
      showNow(id: id, title: title, body: body);
    });
  }

  // ── Cancel a notification ─────────────────────────────────
  static Future<void> cancel(int id) => _plugin.cancel(id);

  // ── Cancel all ───────────────────────────────────────────
  static Future<void> cancelAll() => _plugin.cancelAll();
}
