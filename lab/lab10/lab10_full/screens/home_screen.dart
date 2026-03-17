import 'package:flutter/material.dart';
import '../services/session_service.dart';
import '../services/notification_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  final String token;

  const HomeScreen({super.key, required this.username, required this.token});

  Future<void> _logout(BuildContext context) async {
    await NotificationService().notifyLogout();
    await SessionService().clearSession();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home – Lab 10 Full'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, size: 60, color: Colors.white)),
              const SizedBox(height: 20),
              Text('Welcome, $username!',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                '✅ Real API login\n✅ Session saved (auto-login on restart)\n✅ Notification sent on login',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.6),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
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
