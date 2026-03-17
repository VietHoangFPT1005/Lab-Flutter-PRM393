// ============================================================
// Feature 03 Screen 1 – Register Form + Send OTP
// ============================================================

import 'package:flutter/material.dart';
import '../services/otp_service.dart';
import 'otp_verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _nameCtrl      = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _passCtrl      = TextEditingController();
  final _confirmCtrl   = TextEditingController();

  bool _showPass    = false;
  bool _showConfirm = false;
  bool _loading     = false;

  // ── Submit ─────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _loading = true);

    final email  = _emailCtrl.text.trim();
    final result = await OtpService.sendOtp(email);

    if (!mounted) return;
    setState(() => _loading = false);

    if (result.ok) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerifyScreen(
            email: email,
            fullName: _nameCtrl.text.trim(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gửi OTP thất bại: ${result.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký tài khoản'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Icon(Icons.person_add, size: 64, color: Colors.purple),
              const SizedBox(height: 8),
              const Text(
                'Tạo tài khoản mới',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mã OTP sẽ được gửi đến email của bạn',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 28),

              // Full name
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 2) ? 'Nhập họ tên (ít nhất 2 ký tự)' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nhập email';
                  final emailRegex = RegExp(r'^[\w.+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(v.trim())) return 'Email không hợp lệ';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passCtrl,
                obscureText: !_showPass,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showPass = !_showPass),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.length < 8) return 'Mật khẩu tối thiểu 8 ký tự';
                  if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Cần ít nhất 1 chữ hoa';
                  if (!RegExp(r'[0-9]').hasMatch(v)) return 'Cần ít nhất 1 số';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm password
              TextFormField(
                controller: _confirmCtrl,
                obscureText: !_showConfirm,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _showConfirm = !_showConfirm),
                  ),
                ),
                validator: (v) => v != _passCtrl.text ? 'Mật khẩu không khớp' : null,
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('Gửi mã OTP',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
