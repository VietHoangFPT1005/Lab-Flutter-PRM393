// Lab 8B – Practical REST API Integration: Weather Companion App
// Scenario A – Uses Open-Meteo API (free, no API key required)
// Covers: http, JSON parsing, FutureBuilder, service layer, purpose-driven UI

import 'package:flutter/material.dart';
import 'screens/weather_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Companion – Lab 8B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const WeatherScreen(),
    );
  }
}
