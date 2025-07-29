// lib/core/models/user_model.dart
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
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.direccion,
    this.role = 'client',
    this.avatarUrl,
    this.fechaRegistro,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
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
        emailVerifiedAt,
        createdAt,
        updatedAt,
      ];

  /// Constructor desde JSON (compatible con Laravel)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      telefono: json['telefono'] ?? json['phone'] ?? json['telefono'],
      direccion: json['direccion'] ?? json['address'],
      role: json['role'] ?? json['tipo'] ?? 'client',
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'] ?? json['profile_photo_url'],
      fechaRegistro: json['fecha_registro'] != null 
          ? DateTime.tryParse(json['fecha_registro']) 
          : null,
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.tryParse(json['email_verified_at']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at']) 
          : null,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'direccion': direccion,
      'role': role,
      'avatarUrl': avatarUrl,
      'fecha_registro': fechaRegistro?.toIso8601String(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Crear copia con cambios
  User copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    String? direccion,
    String? role,
    String? avatarUrl,
    DateTime? fechaRegistro,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
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
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Verificar si el usuario tiene un rol específico
  bool hasRole(String targetRole) {
    return role?.toLowerCase() == targetRole.toLowerCase();
  }

  /// Verificar si es administrador
  bool get isAdmin => hasRole('admin');

  /// Verificar si es cliente
  bool get isClient => hasRole('client');

  /// Verificar si el email está verificado
  bool get isEmailVerified => emailVerifiedAt != null;

  /// Obtener iniciales del nombre
  String get initials {
    final words = nombre.trim().split(' ');
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return (words.first.substring(0, 1) + words.last.substring(0, 1)).toUpperCase();
  }

  /// Representación de string para debug
  @override
  String toString() {
    return 'User{id: $id, nombre: $nombre, email: $email, role: $role}';
  }
} 