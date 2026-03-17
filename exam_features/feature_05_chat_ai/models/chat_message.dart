// ============================================================
// Feature 05 Model – ChatMessage
// ============================================================

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;       // true = user, false = AI
  final DateTime timestamp;
  final bool isLoading;    // true = AI đang trả lời

  ChatMessage({
    String? id,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
    this.isLoading = false,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now();

  // Loading placeholder (shown while waiting for AI)
  factory ChatMessage.loading() => ChatMessage(
        text: '',
        isUser: false,
        isLoading: true,
      );

  String get timeText {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
