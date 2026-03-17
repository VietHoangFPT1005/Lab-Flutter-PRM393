// ============================================================
// Feature 03 Screen 2 – OTP Verification
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/otp_service.dart';
import '../config/email_config.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String fullName;

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.fullName,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  // 6 OTP digit controllers
  final List<TextEditingController> _digitCtrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = EmailConfig.otpExpiryMinutes * 60;
  bool _resending  = false;
  bool _verifying  = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus first digit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _timerText {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get _enteredOtp =>
      _digitCtrls.map((c) => c.text).join();

  // ── Verify ────────────────────────────────────────────────
  Future<void> _verify() async {
    final otp = _enteredOtp;
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập đủ 6 chữ số OTP')),
      );
      return;
    }

    setState(() => _verifying = true);
    // Small delay for UX
    await Future.delayed(const Duration(milliseconds: 400));

    final result = OtpService.verifyOtp(widget.email, otp);
    if (!mounted) return;
    setState(() => _verifying = false);

    switch (result) {
      case OtpVerifyResult.correct:
        _timer?.cancel();
        _showSuccessDialog();
        break;
      case OtpVerifyResult.wrong:
        _showError('Mã OTP không đúng. Vui lòng thử lại.');
        _clearOtp();
        break;
      case OtpVerifyResult.expired:
        _showError('Mã OTP đã hết hạn. Nhấn "Gửi lại OTP".');
        _clearOtp();
        break;
      case OtpVerifyResult.tooManyAttempts:
        _showError('Nhập sai quá 3 lần. Vui lòng yêu cầu mã mới.');
        _clearOtp();
        break;
      case OtpVerifyResult.notFound:
        _showError('Không tìm thấy OTP. Vui lòng yêu cầu mã mới.');
        break;
    }
  }

  // ── Resend OTP ───────────────────────────────────────────
  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _secondsLeft = EmailConfig.otpExpiryMinutes * 60;
    });
    _clearOtp();

    final result = await OtpService.sendOtp(widget.email);
    if (!mounted) return;
    setState(() => _resending = false);

    if (result.ok) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP mới đã được gửi!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gửi lại thất bại: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearOtp() {
    for (final c in _digitCtrls) c.clear();
    _focusNodes[0].requestFocus();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 72),
            const SizedBox(height: 12),
            const Text('Đăng ký thành công!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Chào mừng ${widget.fullName}!',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Về trang chủ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _digitCtrls) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác minh OTP'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.mark_email_unread, size: 72, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'Nhập mã OTP',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Mã gồm 6 chữ số đã được gửi đến\n${widget.email}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 32),

            // 6 digit boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) => _digitBox(i)),
            ),
            const SizedBox(height: 24),

            // Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timer,
                  color: _secondsLeft < 60 ? Colors.red : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Hết hạn sau: $_timerText',
                  style: TextStyle(
                    color: _secondsLeft < 60 ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Verify button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _verifying ? null : _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _verifying
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.5))
                    : const Text('Xác nhận', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),

            // Resend button
            TextButton.icon(
              onPressed: (_resending || _secondsLeft > 0) ? null : _resend,
              icon: _resending
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh),
              label: Text(
                _secondsLeft > 0
                    ? 'Gửi lại OTP sau $_timerText'
                    : 'Gửi lại OTP',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _digitBox(int index) {
    return Container(
      width: 46,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        controller: _digitCtrls[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.purple, width: 2),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (v) {
          if (v.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (v.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          // Auto verify when last digit entered
          if (index == 5 && v.isNotEmpty) {
            Future.microtask(_verify);
          }
        },
      ),
    );
  }
}
