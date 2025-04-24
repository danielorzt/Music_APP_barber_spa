// lib/features/appointments/models/appointment_model.dart
import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable()
class Appointment {
  final int? id;
  final DateTime fechaHora;
  final String estado;
  final String? mensaje;
  final int usuarioId;
  final int servicioId;
  final int sucursalId;

  // Campos para mostrar información adicional (opcional)
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? servicio;

  @JsonKey(includeIfNull: false)
  final Map<String, dynamic>? sucursal;

  Appointment({
    this.id,
    required this.fechaHora,
    required this.estado,
    this.mensaje,
    required this.usuarioId,
    required this.servicioId,
    required this.sucursalId,
    this.servicio,
    this.sucursal,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => _$AppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}