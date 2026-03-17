// Lab 10.1 – Mock Login Screen

import 'package:flutter/material.dart';
import '../services/auth_service_mock.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _authService = MockAuthService();
  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final token =
        await _authService.login(_emailCtrl.text, _passwordCtrl.text);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            email: _emailCtrl.text,
            token: token,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Try user@example.com / password123'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login – Lab 10.1'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.lock_outline, size: 72, color: Colors.indigo),
                  const SizedBox(height: 24),
                  const Text('Mock Authentication',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Use: user@example.com / password123',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Email is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Password is required' : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
