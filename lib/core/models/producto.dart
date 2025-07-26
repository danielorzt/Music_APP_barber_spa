import 'package:equatable/equatable.dart';

class Producto extends Equatable {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String urlImagen;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.urlImagen,
  });

  @override
  List<Object?> get props => [id, nombre, descripcion, precio, urlImagen];

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
      urlImagen: json['urlImagen'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'urlImagen': urlImagen,
    };
  }
}