// ============================================================
// Feature 05 Config – Gemini AI Chat
//
// !! ĐIỀN API KEY VÀO ĐÂY TRƯỚC KHI CHẠY !!
//
// Cách lấy Gemini API Key (MIỄN PHÍ):
//   1. Vào aistudio.google.com
//   2. Đăng nhập bằng Google Account
//   3. Click "Get API key" → "Create API key"
//   4. Copy key và dán vào bên dưới
// ============================================================

class GeminiConfig {
  // ─── ĐIỀN VÀO ĐÂY ───────────────────────────────────────
  static const String apiKey = 'YOUR_GEMINI_API_KEY'; // ← thay thế

  // Model (gemini-1.5-flash = nhanh + miễn phí)
  static const String model = 'gemini-1.5-flash';

  // System prompt (tính cách của AI)
  static const String systemInstruction =
      'Bạn là trợ lý AI thân thiện, hữu ích và ngắn gọn. '
      'Trả lời bằng tiếng Việt trừ khi người dùng hỏi bằng ngôn ngữ khác. '
      'Giữ câu trả lời súc tích và dễ hiểu.';

  static String get endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey';
}
