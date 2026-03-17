// ============================================================
// Feature 02 Entry Point – SePay Payment
// Run: flutter run --target=exam_features/feature_02_sepay/mainSePay.dart
//
// SETUP TRƯỚC KHI CHẠY:
//   1. Mở file config/sepay_config.dart
//   2. Thay 'YOUR_SEPAY_API_KEY' bằng API key thật của bạn
// ============================================================
import 'package:flutter/material.dart';
import 'screens/payment_screen.dart';

void main() => runApp(const SePayApp());

class SePayApp extends StatelessWidget {
  const SePayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SePay Payment Demo',
      debugShowCheckedModeBanner: false,
      home: PaymentScreen(),
    );
  }
}
