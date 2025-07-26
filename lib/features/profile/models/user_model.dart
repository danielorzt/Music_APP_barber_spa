// lib/features/profile/models/user_model.dart
// import 'package:json_annotation/json_annotation.dart';

// part 'user_model.g.dart';

// @JsonSerializable()
class User {
  final int? id;
  final String nombre;
  final String email;
  final String? direccion;
  final String? telefono;
  final String? tipo;
  final String? estado;
  final String? imagen;

  // Propiedades adicionales para compatibilidad con la UI
  String get name => nombre;
  String get imageUrl => imagen ?? '';
  bool get isPremium => tipo == 'premium';

  // No incluimos password en el modelo para mayor seguridad

  User({
    this.id,
    required this.nombre,
    required this.email,
    this.direccion,
    this.telefono,
    this.tipo,
    this.estado,
    this.imagen,
    String? name,
    String? phone,
  }) : 
    _tempName = name,
    _tempPhone = phone;

  final String? _tempName;
  final String? _tempPhone;

  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  // Map<String, dynamic> toJson() => _$UserToJson(this);
  
  // Implementación temporal sin json_serializable
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      direccion: json['direccion'],
      telefono: json['telefono'],
      tipo: json['tipo'],
      estado: json['estado'],
      imagen: json['imagen'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'direccion': direccion,
      'telefono': telefono,
      'tipo': tipo,
      'estado': estado,
      'imagen': imagen,
    };
  }
}