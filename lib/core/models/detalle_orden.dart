import 'package:equatable/equatable.dart';

class DetalleOrden extends Equatable {
  final int id;
  final int productoId;
  final int cantidad;
  final double precioUnitario;

  const DetalleOrden({
    required this.id,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
  });

  @override
  List<Object?> get props => [id, productoId, cantidad, precioUnitario];

  factory DetalleOrden.fromJson(Map<String, dynamic> json) {
    return DetalleOrden(
      id: json['id'] as int,
      productoId: json['productoId'] as int,
      cantidad: json['cantidad'] as int,
      precioUnitario: (json['precioUnitario'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productoId': productoId,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    };
  }
}
