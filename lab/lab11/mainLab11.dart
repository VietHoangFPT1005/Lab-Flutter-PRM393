// Lab 11 – Taskly App (Testing & Debugging)
// Entry point for running the app manually

import 'package:flutter/material.dart';
import 'repository/task_repository.dart';
import 'screens/task_list_screen.dart';

void main() => runApp(const TasklyApp());

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly – Lab 11',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      home: TaskListScreen(repository: TaskRepository()),
    );
  }
}
