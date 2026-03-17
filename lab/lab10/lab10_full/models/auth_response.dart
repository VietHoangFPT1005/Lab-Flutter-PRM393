class AuthResponse {
  final String username;
  final String email;
  final String firstName;
  final String token;

  const AuthResponse({
    required this.username,
    required this.email,
    required this.firstName,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> j) => AuthResponse(
        username: j['username'] as String,
        email: j['email'] as String,
        firstName: j['firstName'] as String,
        token: j['accessToken'] as String,
      );
}
