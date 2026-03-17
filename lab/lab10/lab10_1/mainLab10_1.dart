// Lab 10.1 – Mock Login (Backend Simulation)
// Simulates authentication with a fake token, form validation & loading state

import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() => runApp(const MockLoginApp());

class MockLoginApp extends StatelessWidget {
  const MockLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.1 – Mock Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true),
      home: const LoginScreen(),
    );
  }
}
