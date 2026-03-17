// Lab 8.4 – ApiService (Service Layer Pattern)
// Separates all networking logic from the UI

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ── Lab 8.1 & 8.2 – GET all posts ───────────────────────────────────────
  Future<List<Post>> fetchPosts() async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load posts. Status: ${response.statusCode}');
    }
  }

  // ── Optional – POST a new post ───────────────────────────────────────────
  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    final uri = Uri.parse('$_baseUrl/posts');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'userId': userId,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create post. Status: ${response.statusCode}');
    }
  }

  void dispose() {
    _client.close();
  }
}
