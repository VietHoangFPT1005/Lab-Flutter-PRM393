// Lab 10.3 – Session Service using SharedPreferences
// Persists auth token across app restarts

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'auth_username';

  /// Save token and username after successful login
  Future<void> saveSession({required String token, required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
  }

  /// Load token from storage. Returns null if not logged in.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Load saved username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Clear session (logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
  }

  /// Check if a session exists
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
