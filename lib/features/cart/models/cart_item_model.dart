// lib/features/cart/models/cart_item_model.dart
// import 'package:json_annotation/json_annotation.dart';

// part 'cart_item_model.g.dart';

// @JsonSerializable()
class CartItem {
  final int id;
  final String nombre;
  final double precio;
  final int cantidad;
  final String? imagen;
  final int productoId; // ID del producto original
  final double total; // Precio total (precio * cantidad)

  CartItem({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.cantidad,
    this.imagen,
    required this.productoId,
    required this.total,
  });

  // factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  // Map<String, dynamic> toJson() => _$CartItemToJson(this);
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    final precio = (json['precio'] ?? 0.0).toDouble();
    final cantidad = json['cantidad'] ?? 1;
    return CartItem(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      precio: precio,
      cantidad: cantidad,
      imagen: json['imagen'],
      productoId: json['productoId'] ?? json['id'] ?? 0,
      total: precio * cantidad,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'imagen': imagen,
      'productoId': productoId,
      'total': total,
    };
  }
}