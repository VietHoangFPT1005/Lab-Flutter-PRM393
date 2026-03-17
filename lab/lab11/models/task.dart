// Lab 11 – Task Model
// Used by unit tests: test/lab11/unit/task_model_test.dart

class Task {
  final String id;
  String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.completed = false, // Default: not completed
  });

  /// Toggle completed state (true ↔ false)
  void toggle() {
    completed = !completed;
  }

  /// Create a copy with optional overrides
  Task copyWith({String? id, String? title, bool? completed}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() => 'Task(id: $id, title: $title, completed: $completed)';
}
