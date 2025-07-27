// lib/features/profile/models/user_model.dart
// import 'package:json_annotation/json_annotation.dart';

// part 'user_model.g.dart';

// @JsonSerializable()
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String nombre;
  final String email;
  final String? telefono;
  final String? direccion;
  final String? role; // 'client' o 'admin'
  final String? avatarUrl;
  final DateTime? fechaRegistro;

  const User({
    this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.direccion,
    this.role = 'client',
    this.avatarUrl,
    this.fechaRegistro,
  });

  @override
  List<Object?> get props => [
        id,
        nombre,
        email,
        telefono,
        direccion,
        role,
        avatarUrl,
        fechaRegistro,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      role: json['role'] as String? ?? 'client',
      avatarUrl: json['avatarUrl'] as String?,
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'role': role,
      'avatarUrl': avatarUrl,
      'fechaRegistro': fechaRegistro?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    String? direccion,
    String? role,
    String? avatarUrl,
    DateTime? fechaRegistro,
  }) {
    return User(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isClient => role == 'client';
}