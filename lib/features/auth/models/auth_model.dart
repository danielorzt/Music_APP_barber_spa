// lib/features/auth/models/auth_model.dart
// import 'package:json_annotation/json_annotation.dart';

// part 'auth_model.g.dart';

// @JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  // Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

// @JsonSerializable()
class RegisterRequest {
  final String nombre;
  final String email;
  final String password;
  final String direccion;
  final String? telefono;

  RegisterRequest({
    required this.nombre,
    required this.email,
    required this.password,
    required this.direccion,
    this.telefono,
  });

  // Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'email': email,
    'password': password,
    'direccion': direccion,
    'telefono': telefono,
  };
}

// @JsonSerializable()
class AuthResponse {
  final int id;
  final String nombre;
  final String email;
  final String? tipo;
  final String? direccion;
  final String? telefono;

  AuthResponse({
    required this.id,
    required this.nombre,
    required this.email,
    this.tipo,
    this.direccion,
    this.telefono,
  });

  // factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      tipo: json['tipo'],
      direccion: json['direccion'],
      telefono: json['telefono'],
    );
  }
}