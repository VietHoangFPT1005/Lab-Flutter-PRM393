// Lab 12.1 – TaskProvider using ChangeNotifier
// Exercise 12.1: Use Selector to prevent unnecessary rebuilds

import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(String title) {
    _tasks.add(Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    ));
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(completed: !task.completed);
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void updateTitle(String id, String newTitle) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(title: newTitle);
      notifyListeners();
    }
  }
}
