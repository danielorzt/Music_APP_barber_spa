import 'package:equatable/equatable.dart';
import 'package:music_app/core/models/detalle_orden.dart';

class Orden extends Equatable {
  final int id;
  final int usuarioId;
  final DateTime fecha;
  final double total;
  final String estado; // e.g., 'PENDIENTE_PAGO', 'PAGADO', 'ENVIADO', 'COMPLETADO'
  final List<DetalleOrden> detalles;

  const Orden({
    required this.id,
    required this.usuarioId,
    required this.fecha,
    required this.total,
    required this.estado,
    required this.detalles,
  });

  @override
  List<Object?> get props => [id, usuarioId, fecha, total, estado, detalles];

  factory Orden.fromJson(Map<String, dynamic> json) {
    var detallesList = json['detalles'] as List;
    List<DetalleOrden> detalles = detallesList.map((i) => DetalleOrden.fromJson(i)).toList();

    return Orden(
      id: json['id'] as int,
      usuarioId: json['usuarioId'] as int,
      fecha: DateTime.parse(json['fecha'] as String),
      total: (json['total'] as num).toDouble(),
      estado: json['estado'] as String,
      detalles: detalles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'fecha': fecha.toIso8601String(),
      'total': total,
      'estado': estado,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}