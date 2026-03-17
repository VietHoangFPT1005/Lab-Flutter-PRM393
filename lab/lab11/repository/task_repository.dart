// Lab 11 – Task Repository
// In-memory CRUD operations used by widget and unit tests

import '../models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  /// Returns an unmodifiable view of all tasks
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Add a new task to the list
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Delete a task by id
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  /// Update an existing task (by matching id)
  void updateTask(Task updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _tasks[index] = updated;
    }
  }

  /// Clear all tasks (useful for test teardown)
  void clear() => _tasks.clear();

  /// Find task by id
  Task? findById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
