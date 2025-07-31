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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nombre: json['nombre']?.toString() ?? json['name']?.toString() ?? 'Servicio',
      descripcion: json['descripcion']?.toString() ?? json['description']?.toString() ?? '',
      precio: double.tryParse(json['precio_base']?.toString() ?? json['precio']?.toString() ?? '0') ?? 0.0,
      duracionEnMinutos: int.tryParse(json['duracion_minutos']?.toString() ?? json['duracionEnMinutos']?.toString() ?? '60') ?? 60,
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