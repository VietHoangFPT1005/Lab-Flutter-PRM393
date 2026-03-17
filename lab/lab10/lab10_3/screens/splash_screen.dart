// Lab 10.3 – Splash Screen with Auto-Login Routing

import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _sessionService = SessionService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Small delay for splash visibility
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final loggedIn = await _sessionService.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      final username = await _sessionService.getUsername() ?? 'User';
      final token = await _sessionService.getToken() ?? '';
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            username: username,
            token: token,
            sessionService: _sessionService,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(sessionService: _sessionService),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shield_outlined, size: 80, color: Colors.deepPurple),
            SizedBox(height: 20),
            Text('AuthApp',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text('Checking session...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
