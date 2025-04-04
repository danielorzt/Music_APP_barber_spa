// lib/features/auth/models/auth_model.dart

class AuthRequest {
  final String email;
  final String password;
  final String? name;
  final String? phone;

  AuthRequest({
    required this.email,
    required this.password,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;

    return data;
  }
}

class AuthResponse {
  final String token;
  final String message;
  final bool success;

  AuthResponse({
    required this.token,
    required this.message,
    required this.success,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? '',
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}