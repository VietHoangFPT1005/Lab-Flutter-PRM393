// ============================================================
// Feature 05 Service – Gemini API (HTTP, no extra package)
// Uses http package (already in pubspec.yaml)
// ============================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/gemini_config.dart';

class GeminiService {
  // Conversation history for context
  final List<Map<String, dynamic>> _history = [];

  // ── Send message and get AI reply ─────────────────────────
  Future<String> sendMessage(String userText) async {
    // Add user message to history
    _history.add({
      'role': 'user',
      'parts': [{'text': userText}],
    });

    try {
      final response = await http.post(
        Uri.parse(GeminiConfig.endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          // System instruction
          'system_instruction': {
            'parts': [{'text': GeminiConfig.systemInstruction}]
          },
          // Full conversation history
          'contents': _history,
          // Generation settings
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 1024,
            'topP': 0.95,
          },
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final aiText = data['candidates'][0]['content']['parts'][0]['text'] as String;

        // Add AI reply to history for context
        _history.add({
          'role': 'model',
          'parts': [{'text': aiText}],
        });

        return aiText.trim();
      } else {
        // Remove the user message we just added (since it failed)
        _history.removeLast();
        final error = jsonDecode(response.body);
        final msg = error['error']?['message'] ?? 'Lỗi ${response.statusCode}';
        throw Exception(msg);
      }
    } catch (e) {
      // Remove failed user message from history
      if (_history.isNotEmpty && _history.last['role'] == 'user') {
        _history.removeLast();
      }
      rethrow;
    }
  }

  // ── Clear conversation history ────────────────────────────
  void clearHistory() => _history.clear();

  // ── Get history length ────────────────────────────────────
  int get historyLength => _history.length;
}
