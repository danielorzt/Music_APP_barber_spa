// lib/features/products/models/product_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Product {
  final int? id;
  final String nombreproducto;
  final String? descripcion;
  final String? imagen;
  final double precio;
  final int cantidad;
  final int usuarioId;

  Product({
    this.id,
    required this.nombreproducto,
    this.descripcion,
    this.imagen,
    required this.precio,
    required this.cantidad,
    required this.usuarioId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}