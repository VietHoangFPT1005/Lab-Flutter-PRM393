import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      // Named Routes Configuration
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const MovieDetailScreen(),
      },
    );
  }
}