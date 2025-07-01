// lib/features/products/models/product_model.dart
// import 'package:json_annotation/json_annotation.dart';

// part 'product_model.g.dart';

// @JsonSerializable()
class Product {
  final int id;
  final String nombreproducto;
  final String descripcion;
  final double precio;
  final int stock;
  final String? imagen;
  final String categoria;
  final String? marca;
  final bool activo;

  Product({
    required this.id,
    required this.nombreproducto,
    required this.descripcion,
    required this.precio,
    required this.stock,
    this.imagen,
    required this.categoria,
    this.marca,
    required this.activo,
  });

  // factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  // Map<String, dynamic> toJson() => _$ProductToJson(this);
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      nombreproducto: json['nombreproducto'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      imagen: json['imagen'],
      categoria: json['categoria'] ?? '',
      marca: json['marca'],
      activo: json['activo'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreproducto': nombreproducto,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
      'categoria': categoria,
      'marca': marca,
      'activo': activo,
    };
  }
}