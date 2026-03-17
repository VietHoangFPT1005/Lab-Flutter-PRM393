// Lab 10.3 – Auto Login & Logout using SharedPreferences
// SplashScreen checks token → routes to Home or Login automatically

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() => runApp(const AutoLoginApp());

class AutoLoginApp extends StatelessWidget {
  const AutoLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.3 – Auto Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
