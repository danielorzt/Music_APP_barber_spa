// lib/features/appointments/models/appointment_model.dart

class Appointment {
  final String? id;
  final String usuarioId;
  final String serviceId;
  final String branchId;
  final DateTime fechaHora;
  final String estado;
  final Map<String, dynamic>? servicio;
  final Map<String, dynamic>? sucursal;
  final String? mensaje;

  Appointment({
    this.id,
    required this.usuarioId,
    required this.serviceId,
    required this.branchId,
    required this.fechaHora,
    required this.estado,
    this.servicio,
    this.sucursal,
    this.mensaje,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id']?.toString(),
      usuarioId: json['usuarioId']?.toString() ?? json['userId']?.toString() ?? '',
      serviceId: json['serviceId']?.toString() ?? '',
      branchId: json['branchId']?.toString() ?? '',
      fechaHora: json['fechaHora'] != null 
          ? DateTime.parse(json['fechaHora'].toString())
          : json['date'] != null 
              ? DateTime.parse(json['date'].toString())
              : DateTime.now(),
      estado: json['estado']?.toString() ?? json['status']?.toString() ?? 'PENDIENTE',
      servicio: json['servicio'] as Map<String, dynamic>?,
      sucursal: json['sucursal'] as Map<String, dynamic>?,
      mensaje: json['mensaje']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'serviceId': serviceId,
      'branchId': branchId,
      'fechaHora': fechaHora.toIso8601String(),
      'estado': estado,
      'servicio': servicio,
      'sucursal': sucursal,
      'mensaje': mensaje,
    };
  }
}