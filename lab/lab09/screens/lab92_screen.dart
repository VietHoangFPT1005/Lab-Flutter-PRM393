// Lab 9.2 – Save & Load JSON From Device Storage
// Persists a list of simple string items across app restarts

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final List<String> _items = [];
  final _textController = TextEditingController();
  bool _isSaving = false;

  static const String _fileName = 'lab92_items.json';

  @override
  void initState() {
    super.initState();
    _loadFromStorage(); // Lab 9.2 – Step 3: Load at startup
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  // Lab 9.2 – Step 2: Read JSON file from storage
  Future<void> _loadFromStorage() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> decoded = jsonDecode(content);
        setState(() {
          _items.addAll(decoded.map((e) => e.toString()));
        });
      }
    } catch (e) {
      // First launch – no file yet
    }
  }

  // Lab 9.2 – Step 5: Save to JSON file
  Future<void> _saveToStorage() async {
    setState(() => _isSaving = true);
    try {
      final file = await _getFile();
      final encoded = jsonEncode(_items);
      await file.writeAsString(encoded);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Saved to local storage!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _addItem() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() => _items.add(text));
    _textController.clear();
  }

  void _removeItem(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2 – Device Storage'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveToStorage,
            tooltip: 'Save to storage',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Storage info banner ────────────────────────────────────
          Container(
            width: double.infinity,
            color: Colors.teal[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              '💾 Data is saved to device storage and reloads after restart',
              style: TextStyle(color: Colors.teal, fontSize: 12),
            ),
          ),

          // ── Add item row ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter item name...',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),

          // ── Item list ──────────────────────────────────────────────
          Expanded(
            child: _items.isEmpty
                ? const Center(
                    child: Text('No items yet. Add some above!',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _items.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Text('${index + 1}',
                                style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(_items[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ── Save button ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveToStorage,
                icon: const Icon(Icons.save_alt),
                label: Text(_isSaving ? 'Saving...' : 'Save to Device Storage'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,
                    foregroundColor: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
