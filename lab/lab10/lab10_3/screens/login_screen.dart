// Lab 10.3 – Login with Session Persistence

import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final SessionService sessionService;

  const LoginScreen({super.key, required this.sessionService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  // Mock credentials (replace with real API in production)
  static const _validUsername = 'emilys';
  static const _validPassword = 'emilyspass';

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (_usernameCtrl.text.trim() == _validUsername &&
        _passwordCtrl.text == _validPassword) {
      const token = 'session_token_lab10_3_xyz';
      // Persist session
      await widget.sessionService.saveSession(
        token: token,
        username: _usernameCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            username: _usernameCtrl.text.trim(),
            token: token,
            sessionService: widget.sessionService,
          ),
        ),
      );
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Invalid credentials. Try: emilys / emilyspass'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login – Lab 10.3'), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.save_outlined, size: 72, color: Colors.deepPurple),
                  const SizedBox(height: 24),
                  const Text('Auto-Login Demo',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Session persists across restarts',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Username is required' : null,
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
                        icon: Icon(_obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
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
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : const Text('Login & Save Session',
                              style: TextStyle(fontSize: 15)),
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
