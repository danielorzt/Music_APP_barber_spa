// lib/features/cart/models/cart_item_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItem {
  final int? id;
  final String nombre;
  final double cantidad;
  final double precio;
  final double total;
  final int productoId;

  CartItem({
    this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
    required this.total,
    required this.productoId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}