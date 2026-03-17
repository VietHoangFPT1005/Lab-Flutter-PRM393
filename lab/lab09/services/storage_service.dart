// Lab 9.2 & 9.3 – StorageService
// Handles read/write JSON from device app documents directory

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String _fileName = 'products.json';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Read JSON list from local storage. Returns raw JSON string.
  Future<String?> readJson() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        return await file.readAsString();
      }
    } catch (e) {
      // File not found or read error
    }
    return null;
  }

  /// Write JSON string to local storage.
  Future<void> writeJson(String jsonContent) async {
    final file = await _getFile();
    await file.writeAsString(jsonContent);
  }

  /// Encode list of maps and write to storage.
  Future<void> saveList(List<Map<String, dynamic>> data) async {
    final encoded = jsonEncode(data);
    await writeJson(encoded);
  }
}
