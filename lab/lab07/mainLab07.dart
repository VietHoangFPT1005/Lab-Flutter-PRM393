// Lab 7 – Building a Signup Form with Validation & Good UX
// Covers: Form, TextFormField, GlobalKey<FormState>, FocusNode,
//         AutovalidateMode, async email check, password strength

import 'package:flutter/material.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(const SignupApp());
}

class SignupApp extends StatelessWidget {
  const SignupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signup Form – Lab 7',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: const SignupScreen(),
    );
  }
}
