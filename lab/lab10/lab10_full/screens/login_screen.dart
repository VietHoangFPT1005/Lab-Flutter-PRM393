// Lab 10 Full – Login Screen (Real API + Session + Notification)

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';
import '../services/session_service.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // Real API login (Lab 10.2)
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameCtrl.text.trim(),
          'password': _passwordCtrl.text,
          'expiresInMins': 30,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final auth = AuthResponse.fromJson(jsonDecode(response.body));

        // Save session (Lab 10.3)
        await SessionService().saveSession(
          token: auth.token,
          username: auth.username,
        );

        // Show notification (Lab 10.5 – LO7)
        await NotificationService().notifyLogin(auth.firstName);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => HomeScreen(username: auth.username, token: auth.token)),
        );
      } else {
        throw Exception('Invalid credentials. Try: emilys / emilyspass');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.security, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 24),
                  const Text('AuthApp – Full Lab 10',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Features: API Login + Session + Notification',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Try: emilys / emilyspass',
                      style: TextStyle(color: Colors.teal, fontSize: 12)),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Username is required'
                        : null,
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
