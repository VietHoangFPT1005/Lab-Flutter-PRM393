// Lab 12.1 – Optimized TaskListScreen
// Optimizations applied:
//   ✅ Extracted TaskTile widget (reduces rebuild scope)
//   ✅ Selector<TaskProvider, List<Task>> instead of Consumer (avoids full rebuild)
//   ✅ const widgets for static UI elements
//   ✅ ValueKey(task.id) for efficient ListView diffing
//   ✅ precacheImage in initState (Exercise 12.2)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Exercise 12.2 – Pre-cache icon image to avoid jank on first render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      precacheImage(
        const AssetImage('lab/lab12/assets/taskly_icon.png'),
        context,
      );
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addTask(BuildContext context) {
    final title = _textController.text.trim();
    if (title.isEmpty) return;
    context.read<TaskProvider>().addTask(title);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskly – Lab 12 Optimized'), // const
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // ── Add task row (const decoration) ──────────────────────────
          Padding(
            padding: const EdgeInsets.all(12), // const
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration( // const
                      hintText: 'Add a new task...',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addTask(context),
                  ),
                ),
                const SizedBox(width: 8), // const
                ElevatedButton(
                  onPressed: () => _addTask(context),
                  child: const Text('Add'), // const
                ),
              ],
            ),
          ),

          // ── Optimized task list using Selector ────────────────────────
          // Selector only rebuilds when tasks list changes, not all Provider state
          Expanded(
            child: Selector<TaskProvider, List<Task>>(
              selector: (_, provider) => provider.tasks,
              builder: (context, tasks, _) {
                if (tasks.isEmpty) {
                  return const Center( // const
                    child: Text(
                      'No tasks yet. Add one!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    // ValueKey for efficient diffing (Exercise 12.1)
                    return TaskTile(
                      key: ValueKey(task.id),
                      task: task,
                      onToggle: () =>
                          context.read<TaskProvider>().toggleTask(task.id),
                      onDelete: () =>
                          context.read<TaskProvider>().deleteTask(task.id),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
                    );
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
