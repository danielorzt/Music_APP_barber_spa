// lib/features/services/models/service_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable()
class Service {
  final int? id;
  final String nombre;
  final String? descripcion;
  final String? imagen;
  final double precio;
  final int duracion;
  final int usuarioId;

  Service({
    this.id,
    required this.nombre,
    this.descripcion,
    this.imagen,
    required this.precio,
    required this.duracion,
    required this.usuarioId,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}