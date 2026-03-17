// ============================================================
// Feature 03 Service – OTP via Gmail SMTP (mailer package)
// ============================================================

import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../config/email_config.dart';

class OtpService {
  // In-memory store: email → {otp, expiresAt}
  static final Map<String, _OtpRecord> _store = {};

  // ── Generate & send OTP ────────────────────────────────────
  static Future<OtpResult> sendOtp(String toEmail) async {
    final otp = _generateOtp();
    final expiresAt = DateTime.now()
        .add(Duration(minutes: EmailConfig.otpExpiryMinutes));

    // Store OTP
    _store[toEmail] = _OtpRecord(otp: otp, expiresAt: expiresAt);

    try {
      await _sendEmail(toEmail: toEmail, otp: otp);
      return OtpResult.success;
    } on MailerException catch (e) {
      _store.remove(toEmail);
      return OtpResult.smtpError(e.toString());
    } catch (e) {
      _store.remove(toEmail);
      return OtpResult.smtpError(e.toString());
    }
  }

  // ── Verify OTP ────────────────────────────────────────────
  static OtpVerifyResult verifyOtp(String email, String enteredOtp) {
    final record = _store[email];

    if (record == null) return OtpVerifyResult.notFound;
    if (DateTime.now().isAfter(record.expiresAt)) {
      _store.remove(email);
      return OtpVerifyResult.expired;
    }
    if (record.otp != enteredOtp.trim()) {
      record.attempts++;
      if (record.attempts >= 3) {
        _store.remove(email);
        return OtpVerifyResult.tooManyAttempts;
      }
      return OtpVerifyResult.wrong;
    }

    // Success – remove used OTP
    _store.remove(email);
    return OtpVerifyResult.correct;
  }

  // ── Internal helpers ──────────────────────────────────────
  static String _generateOtp() =>
      (100000 + Random().nextInt(900000)).toString();

  static Future<void> _sendEmail({
    required String toEmail,
    required String otp,
  }) async {
    final smtpServer = gmail(
      EmailConfig.gmailAddress,
      EmailConfig.gmailAppPassword,
    );

    final message = Message()
      ..from = Address(EmailConfig.gmailAddress, EmailConfig.senderName)
      ..recipients.add(toEmail)
      ..subject = 'Mã OTP xác minh tài khoản của bạn'
      ..html = '''
<!DOCTYPE html>
<html>
<body style="font-family:Arial,sans-serif;background:#f4f4f4;padding:20px">
  <div style="max-width:480px;margin:auto;background:white;
              border-radius:12px;padding:32px;box-shadow:0 2px 8px rgba(0,0,0,.1)">
    <h2 style="color:#6200EE;margin-bottom:8px">Xác minh tài khoản</h2>
    <p style="color:#555">Mã OTP của bạn là:</p>
    <div style="font-size:42px;font-weight:bold;letter-spacing:12px;
                color:#6200EE;text-align:center;padding:16px 0">
      $otp
    </div>
    <p style="color:#888;font-size:13px">
      Mã có hiệu lực trong <strong>${EmailConfig.otpExpiryMinutes} phút</strong>.<br>
      Không chia sẻ mã này với bất kỳ ai.
    </p>
    <hr style="border:none;border-top:1px solid #eee;margin:16px 0">
    <p style="color:#aaa;font-size:11px">
      Email này được gửi tự động, vui lòng không trả lời.
    </p>
  </div>
</body>
</html>
''';

    await send(message, smtpServer);
  }
}

// ── Helper classes ─────────────────────────────────────────

class _OtpRecord {
  final String otp;
  final DateTime expiresAt;
  int attempts = 0;
  _OtpRecord({required this.otp, required this.expiresAt});
}

class OtpResult {
  final bool ok;
  final String? errorMessage;
  const OtpResult._(this.ok, this.errorMessage);

  static const success = OtpResult._(true, null);
  static OtpResult smtpError(String msg) => OtpResult._(false, msg);
}

enum OtpVerifyResult {
  correct,
  wrong,
  expired,
  notFound,
  tooManyAttempts,
}
