import 'package:equatable/equatable.dart';

class Agendamiento extends Equatable {
  final int id;
  final DateTime fechaHora;
  final int usuarioId;
  final int servicioId;
  final int sucursalId;
  final String estado; // e.g., 'PENDIENTE', 'CONFIRMADO', 'CANCELADO'

  const Agendamiento({
    required this.id,
    required this.fechaHora,
    required this.usuarioId,
    required this.servicioId,
    required this.sucursalId,
    required this.estado,
  });

  @override
  List<Object?> get props => [id, fechaHora, usuarioId, servicioId, sucursalId, estado];

  factory Agendamiento.fromJson(Map<String, dynamic> json) {
    return Agendamiento(
      id: json['id'] as int,
      fechaHora: DateTime.parse(json['fechaHora'] as String),
      usuarioId: json['usuarioId'] as int,
      servicioId: json['servicioId'] as int,
      sucursalId: json['sucursalId'] as int,
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fechaHora': fechaHora.toIso8601String(),
      'usuarioId': usuarioId,
      'servicioId': servicioId,
      'sucursalId': sucursalId,
      'estado': estado,
    };
  }
}