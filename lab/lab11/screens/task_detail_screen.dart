// Lab 11 – TaskDetailScreen
// Referenced by navigation tests

import 'package:flutter/material.dart';
import '../models/task.dart';

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
    final updated = widget.task.copyWith(
      title: _titleCtrl.text.trim().isEmpty ? widget.task.title : _titleCtrl.text.trim(),
      completed: _completed,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              key: const Key('detailTitleField'),
              controller: _titleCtrl,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Completed'),
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
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
