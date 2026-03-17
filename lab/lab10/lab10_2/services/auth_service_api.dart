// Lab 10.2 – Real API Authentication Service
// Uses DummyJSON: POST https://dummyjson.com/auth/login
//
// ✅ Offline-safe: if DummyJSON is unreachable (emulator/firewall),
//    falls back to mock credential check so the demo still works.

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';

class AuthServiceApi {
  static const String _loginUrl = 'https://dummyjson.com/auth/login';
  static const Duration _timeout = Duration(seconds: 10);

  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(_loginUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
              'expiresInMins': 30,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return AuthResponse.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception('Invalid credentials. Try: emilys / emilyspass');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // If it's already a meaningful auth error, re-throw it
      if (e.toString().contains('Invalid credentials') ||
          e.toString().contains('Server error')) {
        rethrow;
      }

      // Network unavailable → fallback to offline demo login
      debugPrint('[Lab10.2] Network unavailable – using offline demo: $e');
      return _offlineLogin(username, password);
    }
  }

  /// Offline demo: validates against known DummyJSON test accounts
  AuthResponse _offlineLogin(String username, String password) {
    // DummyJSON test accounts (from https://dummyjson.com/docs/auth)
    const accounts = {
      'emilys': ('emilyspass', 'Emily', 'Johnson', 'emily.johnson@x.dummyjson.com'),
      'michaelw': ('michaelwpass', 'Michael', 'Williams', 'michael.williams@x.dummyjson.com'),
      'sophiab': ('sophiabpass', 'Sophia', 'Brown', 'sophia.brown@x.dummyjson.com'),
      'jamesd': ('jamesdpass', 'James', 'Davis', 'james.davis@x.dummyjson.com'),
    };

    if (accounts.containsKey(username) &&
        accounts[username]!.$1 == password) {
      final info = accounts[username]!;
      return AuthResponse(
        id: 1,
        username: username,
        email: info.$4,
        firstName: info.$2,
        lastName: info.$3,
        token: 'offline_demo_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'offline_refresh_token',
      );
    }
    throw Exception(
        'Invalid credentials. Try: emilys / emilyspass');
  }
}
