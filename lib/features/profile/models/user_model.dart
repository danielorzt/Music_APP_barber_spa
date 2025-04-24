// lib/features/profile/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final int? id;
  final String nombre;
  final String email;
  final String? direccion;
  final String? telefono;
  final String? tipo;
  final String? estado;
  final String? imagen;

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
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}