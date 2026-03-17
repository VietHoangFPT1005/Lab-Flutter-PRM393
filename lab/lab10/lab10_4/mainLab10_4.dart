// Lab 10.4 – Firebase Authentication (Google Sign-In)
//
// ✅ Firebase is configured. See google_signin_screen.dart for full setup steps.
// Run: flutter run --target=lab/lab10/lab10_4/mainLab10_4.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/google_signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FirebaseAuthApp());
}

class FirebaseAuthApp extends StatelessWidget {
  const FirebaseAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.4 – Firebase Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true),
      home: const GoogleSignInScreen(),
    );
  }
}
