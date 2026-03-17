// Lab 10.2 – DummyJSON Auth Response Model
// POST https://dummyjson.com/auth/login

class AuthResponse {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String token;
  final String refreshToken;

  const AuthResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.token,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      token: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  String get fullName => '$firstName $lastName';
}
