import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _tokenKey = 'full_token';
  static const _usernameKey = 'full_username';

  Future<void> saveSession({required String token, required String username}) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_tokenKey, token);
    await p.setString(_usernameKey, username);
  }

  Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);

  Future<String?> getUsername() async =>
      (await SharedPreferences.getInstance()).getString(_usernameKey);

  Future<bool> isLoggedIn() async {
    final t = await getToken();
    return t != null && t.isNotEmpty;
  }

  Future<void> clearSession() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_tokenKey);
    await p.remove(_usernameKey);
  }
}
