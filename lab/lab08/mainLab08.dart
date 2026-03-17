// Lab 8 – Building an API-powered List Screen
// Covers: http package, JSON parsing, FutureBuilder, ApiService, GET + POST

import 'package:flutter/material.dart';
import 'screens/post_list_screen.dart';

void main() {
  runApp(const ApiApp());
}

class ApiApp extends StatelessWidget {
  const ApiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API List – Lab 8',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PostListScreen(),
    );
  }
}
