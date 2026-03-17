// Lab 10.2 – Real API Authentication Service
// Uses DummyJSON: POST https://dummyjson.com/auth/login

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';

class AuthServiceApi {
  static const String _loginUrl = 'https://dummyjson.com/auth/login';

  Future<AuthResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return AuthResponse.fromJson(json);
    } else if (response.statusCode == 400) {
      throw Exception('Invalid credentials. Try: emilys / emilyspass');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
