import 'package:flutter/material.dart';
import '../models/auth_response.dart';

class HomeScreen extends StatelessWidget {
  final AuthResponse auth;

  const HomeScreen({super.key, required this.auth});

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
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.person, size: 48, color: Colors.white)),
                  const SizedBox(height: 16),
                  Text(auth.fullName,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('@${auth.username}',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(auth.email,
                      style: const TextStyle(color: Colors.teal)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text('Token (truncated):',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text(
                    '${auth.token.substring(0, auth.token.length.clamp(0, 40))}...',
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
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
