// Lab 10.5 – Local Notification (MANDATORY – LO7)
// Uses flutter_local_notifications: request permission, show notifications

import 'package:flutter/material.dart';
import 'screens/notification_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const NotificationApp());
}

class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.5 – Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true),
      home: const NotificationScreen(),
    );
  }
}
