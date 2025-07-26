import 'package:equatable/equatable.dart';

class Servicio extends Equatable {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int duracionEnMinutos;

  const Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracionEnMinutos,
  });

  @override
  List<Object?> get props => [id, nombre, descripcion, precio, duracionEnMinutos];

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
      duracionEnMinutos: json['duracionEnMinutos'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'duracionEnMinutos': duracionEnMinutos,
    };
  }
}