// ============================================================
// Feature 01 Entry Point – OpenStreetMap
// Run: flutter run --target=exam_features/feature_01_openstreetmap/mainOSM.dart
// ============================================================
import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() => runApp(const OSMApp());

class OSMApp extends StatelessWidget {
  const OSMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'OpenStreetMap Demo',
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}
