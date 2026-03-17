import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  final String token;

  const HomeScreen({super.key, required this.email, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text('Login Successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Welcome: $email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Text('Token: $token',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
