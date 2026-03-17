// ============================================================
// Feature 05 Screen – Gemini Chat AI
// ============================================================

import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _inputCtrl   = TextEditingController();
  final _scrollCtrl  = ScrollController();
  final _gemini      = GeminiService();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(ChatMessage(
      text: 'Xin chào! Tôi là trợ lý AI của bạn. Tôi có thể giúp gì cho bạn? 😊',
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Send message ──────────────────────────────────────────
  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _isTyping) return;

    _inputCtrl.clear();

    // Add user message
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messages.add(ChatMessage.loading()); // typing indicator
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final reply = await _gemini.sendMessage(text);

      setState(() {
        _messages.removeLast(); // remove loading
        _messages.add(ChatMessage(text: reply, isUser: false));
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.removeLast(); // remove loading
        _messages.add(ChatMessage(
          text: '⚠️ Lỗi: ${e.toString().replaceAll('Exception: ', '')}',
          isUser: false,
        ));
        _isTyping = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _gemini.clearHistory();
      _messages.add(ChatMessage(
        text: 'Cuộc trò chuyện đã được xoá. Tôi có thể giúp gì cho bạn?',
        isUser: false,
      ));
    });
  }

  // ── UI ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Text('AI', style: TextStyle(fontSize: 11, color: Colors.white,
                  fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gemini AI', style: TextStyle(fontSize: 16)),
                Text('Powered by Google', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Xoá lịch sử chat',
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildBubble(_messages[i]),
            ),
          ),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  // Message bubble
  Widget _buildBubble(ChatMessage msg) {
    if (msg.isLoading) return _buildTypingIndicator();

    final isUser = msg.isUser;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // AI avatar
          if (!isUser) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.teal,
              child: Text('AI', style: TextStyle(fontSize: 9, color: Colors.white,
                  fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 6),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.teal : Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  msg.timeText,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),

          // User avatar
          if (isUser) ...[
            const SizedBox(width: 6),
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  // Typing dots animation
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Colors.teal,
            child: Text('AI', style: TextStyle(fontSize: 9, color: Colors.white,
                fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: 0),
                SizedBox(width: 4),
                _TypingDot(delay: 150),
                SizedBox(width: 4),
                _TypingDot(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Input bar
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputCtrl,
              maxLines: null,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: _isTyping ? Colors.grey : Colors.teal,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _isTyping ? null : _send,
            ),
          ),
        ],
      ),
    );
  }
}

// Animated typing dot
class _TypingDot extends StatefulWidget {
  final int delay; // milliseconds
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
            color: Colors.teal, shape: BoxShape.circle),
      ),
    );
  }
}
