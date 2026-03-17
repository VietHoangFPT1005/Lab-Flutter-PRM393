// Lab 10.2 – Real REST API Login (DummyJSON)
// POST https://dummyjson.com/auth/login → parse token → navigate to Home

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() => runApp(const RealApiLoginApp());

class RealApiLoginApp extends StatelessWidget {
  const RealApiLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.2 – Real API Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
