// Lab 10 Full – Integrated Authentication App
// Combines: Mock Login → Real API → Auto-Login → Google Sign-In stub → Notifications
//
// Features:
//   ✅ SplashScreen with auto-login routing
//   ✅ Real API login via DummyJSON
//   ✅ Session persistence with SharedPreferences
//   ✅ Logout clears session
//   ✅ Local notification on login/logout (LO7)

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(const Lab10FullApp());
}

class Lab10FullApp extends StatelessWidget {
  const Lab10FullApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 Full',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
