// Lab 12 – Performance Optimization & App Deployment
//
// Optimizations applied:
//   Ex 12.1: Extracted TaskTile widget, Selector<TaskProvider>, ValueKey, const
//   Ex 12.2: precacheImage in initState
//   Ex 12.3: App size analysis – run: flutter build apk --analyze-size
//   Ex 12.4: Release build – run: flutter build apk --release
//            Or AppBundle:  flutter build appbundle --release
//
// How to run in Profile mode (Ex 12.4):
//   flutter run --profile
//
// How to run flutter clean before release:
//   flutter clean && flutter pub get

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lib/providers/task_provider.dart';
import 'lib/screens/task_list_screen.dart';

void main() {
  // Remove all debug print statements for release (Ex 12.4)
  runApp(const TasklyOptimizedApp());
}

class TasklyOptimizedApp extends StatelessWidget {
  const TasklyOptimizedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MaterialApp(
        title: 'Taskly – Lab 12',
        debugShowCheckedModeBanner: false, // Hide debug banner for release
        home: TaskListScreen(),
      ),
    );
  }
}
