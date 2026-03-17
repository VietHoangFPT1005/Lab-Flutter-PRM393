import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String token;
  final SessionService sessionService;

  const HomeScreen({
    super.key,
    required this.username,
    required this.token,
    required this.sessionService,
  });

  Future<void> _logout(BuildContext context) async {
    await sessionService.clearSession();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => LoginScreen(sessionService: sessionService)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 56, color: Colors.white)),
              const SizedBox(height: 20),
              Text('Welcome back, $username!',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Session is saved. Restart the app to test auto-login.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text('Token:',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(token,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout (Clear Session)'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
