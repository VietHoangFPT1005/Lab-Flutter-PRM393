// ============================================================
// Feature 03 Entry Point – OTP Email Verification
// Run: flutter run --target=exam_features/feature_03_otp_email/mainOTP.dart
//
// SETUP TRƯỚC KHI CHẠY:
//   1. Mở file config/email_config.dart
//   2. Điền gmailAddress (Gmail của bạn)
//   3. Điền gmailAppPassword (App Password 16 ký tự)
// ============================================================
import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

void main() => runApp(const OTPApp());

class OTPApp extends StatelessWidget {
  const OTPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OTP Email Demo',
      debugShowCheckedModeBanner: false,
      home: RegisterScreen(),
    );
  }
}
