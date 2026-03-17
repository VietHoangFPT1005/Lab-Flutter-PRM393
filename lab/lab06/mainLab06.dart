// Lab 6 – Building a Responsive Movie Genre Browsing Screen
// Covers: MediaQuery, LayoutBuilder, Wrap, GridView, ListView, FilterChip

import 'package:flutter/material.dart';
import 'screens/genre_screen.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser – Lab 6',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: GenreScreen(),
      ),
    );
  }
}
