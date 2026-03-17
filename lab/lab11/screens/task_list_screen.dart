// Lab 11 – TaskListScreen
// Referenced by widget tests and navigation tests

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../repository/task_repository.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _textController.text.trim();
    if (title.isEmpty) return;
    setState(() {
      widget.repository.addTask(
        Task(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
        ),
      );
      _textController.clear();
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.toggle();
    });
  }

  void _deleteTask(String id) {
    setState(() => widget.repository.deleteTask(id));
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ── Add task row ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('taskInputField'),
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task...',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: const Key('addTaskButton'),
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // ── Task list ─────────────────────────────────────────────────
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    key: Key('emptyState'),
                    child: Text(
                      'No tasks yet. Add one!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return ListTile(
                        key: ValueKey(task.id),
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (_) => _toggleTask(task),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.completed ? Colors.grey : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () => _deleteTask(task.id),
                        ),
                        onTap: () async {
                          final updated = await Navigator.push<Task>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                          if (updated != null) {
                            setState(() => widget.repository.updateTask(updated));
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
