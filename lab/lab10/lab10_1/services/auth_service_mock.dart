// Lab 10.1 – Mock Authentication Service
// Simulates backend authentication with a hardcoded user

class MockAuthService {
  // Fake credentials
  static const String _validEmail = 'user@example.com';
  static const String _validPassword = 'password123';

  /// Simulates a backend login. Returns a token on success, null on failure.
  Future<String?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (email.trim() == _validEmail && password == _validPassword) {
      return 'mock_token_abc123xyz';
    }
    return null;
  }
}
