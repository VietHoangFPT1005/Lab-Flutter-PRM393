// Lab 12 – TaskDetailScreen (optimized version)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TextEditingController _titleCtrl;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.task.title);
    _completed = widget.task.completed;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final newTitle = _titleCtrl.text.trim();
    if (newTitle.isNotEmpty && newTitle != widget.task.title) {
      context.read<TaskProvider>().updateTitle(widget.task.id, newTitle);
    }
    if (_completed != widget.task.completed) {
      context.read<TaskProvider>().toggleTask(widget.task.id);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'), // const
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), // const
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title',
                style: TextStyle(fontWeight: FontWeight.bold)), // const
            const SizedBox(height: 8), // const
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(border: OutlineInputBorder()), // const
            ),
            const SizedBox(height: 20), // const
            SwitchListTile(
              title: const Text('Completed'), // const
              value: _completed,
              onChanged: (v) => setState(() => _completed = v),
              contentPadding: EdgeInsets.zero,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white),
                child: const Text('Save Changes'), // const
              ),
            ),
          ],
        ),
      ),
    );
  }
}
