// Lab 12.1 – Exercise 12.1: Extracted TaskTile Widget
// Optimization: extracted from TaskListScreen to minimize rebuilds
// Uses ValueKey(task.id) for efficient list diffing

import 'package:flutter/material.dart';
import '../models/task.dart';

/// Extracted reusable TaskTile widget.
/// Only rebuilds when its own task data changes (not the full list).
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskTile({
    required Key key, // ValueKey(task.id) passed from parent
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) => onToggle(),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
              task.completed ? TextDecoration.lineThrough : null,
          color: task.completed ? Colors.grey : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: onDelete,
      ),
      onTap: onTap,
    );
  }
}
