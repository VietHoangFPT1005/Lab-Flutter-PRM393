// Lab 8 – Optional: POST Request Screen
// Demonstrates sending data to API via http.post

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  final ApiService apiService;

  const CreatePostScreen({super.key, required this.apiService});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final created = await widget.apiService.createPost(
        userId: 1,
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop(created);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Post')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Body is required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit POST Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
