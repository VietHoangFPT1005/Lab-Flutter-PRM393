// ============================================================
// Feature 05 Entry Point – Gemini Chat AI
// Run: flutter run --target=exam_features/feature_05_chat_ai/mainChatAI.dart
//
// SETUP TRƯỚC KHI CHẠY:
//   1. Vào aistudio.google.com → Get API key → Create API key
//   2. Mở file config/gemini_config.dart
//   3. Thay 'YOUR_GEMINI_API_KEY' bằng key thật của bạn
//
// Tính năng:
//   - Chat với Gemini AI (gemini-1.5-flash)
//   - Duy trì lịch sử cuộc trò chuyện (context)
//   - Typing indicator (3 dots animation)
//   - Xoá lịch sử chat
// ============================================================
import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() => runApp(const ChatAIApp());

class ChatAIApp extends StatelessWidget {
  const ChatAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gemini Chat AI',
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
