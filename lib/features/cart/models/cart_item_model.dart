// lib/features/cart/models/cart_item_model.dart

enum CartItemType { service, product }

class CartItem {
  final int id;
  final String name;
  final double price;
  final CartItemType type;
  final int quantity;
  final int? serviceId;
  final int? productId;
  final DateTime? appointmentDateTime;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    this.quantity = 1,
    this.serviceId,
    this.productId,
    this.appointmentDateTime,
  });

  factory CartItem.fromService(Service service, {DateTime? appointmentDateTime}) {
    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch, // ID temporal para el carrito
      name: service.name,
      price: service.price,
      type: CartItemType.service,
      serviceId: service.id,
      appointmentDateTime: appointmentDateTime,
    );
  }

  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      id: DateTime.now().millisecondsSinceEpoch, // ID temporal para el carrito
      name: product.name,
      price: product.price,
      type: CartItemType.product,
      quantity: quantity,
      productId: product.id,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      type: json['type'] == 'service' ? CartItemType.service : CartItemType.product,
      quantity: json['quantity'] ?? 1,
      serviceId: json['serviceId'],
      productId: json['productId'],
      appointmentDateTime: json['appointmentDateTime'] != null
          ? DateTime.parse(json['appointmentDateTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type == CartItemType.service ? 'service' : 'product',
      'quantity': quantity,
      'serviceId': serviceId,
      'productId': productId,
      'appointmentDateTime': appointmentDateTime?.toIso8601String(),
    };
  }

  double get total => price * quantity;

  CartItem copyWith({
    int? id,
    String? name,
    double? price,
    CartItemType? type,
    int? quantity,
    int? serviceId,
    int? productId,
    DateTime? appointmentDateTime,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      serviceId: serviceId ?? this.serviceId,
      productId: productId ?? this.productId,
      appointmentDateTime: appointmentDateTime ?? this.appointmentDateTime,
    );
  }
}