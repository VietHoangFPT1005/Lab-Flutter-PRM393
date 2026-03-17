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
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final session = SessionService();
    final loggedIn = await session.isLoggedIn();
    if (!mounted) return;
    if (loggedIn) {
      final username = await session.getUsername() ?? '';
      final token = await session.getToken() ?? '';
      if (!mounted) return;
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => HomeScreen(username: username, token: token)));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, size: 80, color: Colors.deepPurple),
              SizedBox(height: 20),
              Text('AuthApp Full',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
}
