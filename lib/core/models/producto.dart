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
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nombre: json['nombre']?.toString() ?? json['name']?.toString() ?? 'Producto',
      descripcion: json['descripcion']?.toString() ?? json['description']?.toString() ?? '',
      precio: double.tryParse(json['precio']?.toString() ?? '0') ?? 0.0,
      urlImagen: json['urlImagen']?.toString() ?? 
                json['imagen']?.toString() ?? 
                json['image']?.toString() ?? 
                '', // Empty string to force ImageMapper to use dynamic Unsplash images
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