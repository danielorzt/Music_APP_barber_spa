import 'package:equatable/equatable.dart';

class Agendamiento extends Equatable {
  final int id;
  final DateTime fechaHora;
  final int usuarioId;
  final int servicioId;
  final int sucursalId;
  final String estado; // e.g., 'PENDIENTE', 'CONFIRMADO', 'CANCELADO'
  
  // Campos opcionales que pueden venir de la API
  final int? personalId;
  final String? notas;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;
  final String? motivoCancelacion;
  final double? precio;
  final int? duracionMinutos;
  
  // Relaciones (pueden ser nulas si no se incluyen en la respuesta)
  final String? nombreServicio;
  final String? nombreSucursal;
  final String? nombrePersonal;
  final String? nombreUsuario;

  const Agendamiento({
    required this.id,
    required this.fechaHora,
    required this.usuarioId,
    required this.servicioId,
    required this.sucursalId,
    required this.estado,
    this.personalId,
    this.notas,
    this.fechaCreacion,
    this.fechaActualizacion,
    this.motivoCancelacion,
    this.precio,
    this.duracionMinutos,
    this.nombreServicio,
    this.nombreSucursal,
    this.nombrePersonal,
    this.nombreUsuario,
  });

  @override
  List<Object?> get props => [
    id, 
    fechaHora, 
    usuarioId, 
    servicioId, 
    sucursalId, 
    estado,
    personalId,
    notas,
    fechaCreacion,
    fechaActualizacion,
    motivoCancelacion,
    precio,
    duracionMinutos,
    nombreServicio,
    nombreSucursal,
    nombrePersonal,
    nombreUsuario,
  ];

  factory Agendamiento.fromJson(Map<String, dynamic> json) {
    return Agendamiento(
      id: json['id'] as int,
      fechaHora: DateTime.parse(json['fecha_hora'] ?? json['fechaHora'] as String),
      usuarioId: json['usuario_id'] ?? json['usuarioId'] ?? json['cliente_usuario_id'] as int,
      servicioId: json['servicio_id'] ?? json['servicioId'] as int,
      sucursalId: json['sucursal_id'] ?? json['sucursalId'] as int,
      estado: json['estado'] as String,
      
      // Campos opcionales con manejo de nulabilidad
      personalId: json['personal_id'] ?? json['personalId'] as int?,
      notas: json['notas'] as String?,
      fechaCreacion: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      fechaActualizacion: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
      motivoCancelacion: json['motivo_cancelacion'] ?? json['motivoCancelacion'] as String?,
      precio: (json['precio'] as num?)?.toDouble(),
      duracionMinutos: json['duracion_minutos'] ?? json['duracionMinutos'] as int?,
      
      // Relaciones
      nombreServicio: json['servicio']?['nombre'] ?? json['nombreServicio'] as String?,
      nombreSucursal: json['sucursal']?['nombre'] ?? json['nombreSucursal'] as String?,
      nombrePersonal: json['personal']?['nombre'] ?? json['nombrePersonal'] as String?,
      nombreUsuario: json['usuario']?['nombre'] ?? json['nombreUsuario'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_hora': fechaHora.toIso8601String(),
      'cliente_usuario_id': usuarioId, // Cambiar a cliente_usuario_id para la API
      'servicio_id': servicioId,
      'sucursal_id': sucursalId,
      'estado': estado,
      'personal_id': personalId,
      'notas': notas,
      'motivo_cancelacion': motivoCancelacion,
      'precio': precio,
      'duracion_minutos': duracionMinutos,
    };
  }

  // Método para crear una copia con cambios
  Agendamiento copyWith({
    int? id,
    DateTime? fechaHora,
    int? usuarioId,
    int? servicioId,
    int? sucursalId,
    String? estado,
    int? personalId,
    String? notas,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    String? motivoCancelacion,
    double? precio,
    int? duracionMinutos,
    String? nombreServicio,
    String? nombreSucursal,
    String? nombrePersonal,
    String? nombreUsuario,
  }) {
    return Agendamiento(
      id: id ?? this.id,
      fechaHora: fechaHora ?? this.fechaHora,
      usuarioId: usuarioId ?? this.usuarioId,
      servicioId: servicioId ?? this.servicioId,
      sucursalId: sucursalId ?? this.sucursalId,
      estado: estado ?? this.estado,
      personalId: personalId ?? this.personalId,
      notas: notas ?? this.notas,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
      motivoCancelacion: motivoCancelacion ?? this.motivoCancelacion,
      precio: precio ?? this.precio,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      nombreServicio: nombreServicio ?? this.nombreServicio,
      nombreSucursal: nombreSucursal ?? this.nombreSucursal,
      nombrePersonal: nombrePersonal ?? this.nombrePersonal,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
    );
  }

  // Método para verificar si el agendamiento está activo
  bool get isActive => estado == 'PENDIENTE' || estado == 'CONFIRMADO';
  
  // Método para verificar si el agendamiento está cancelado
  bool get isCancelled => estado == 'CANCELADO';
  
  // Método para verificar si el agendamiento está completado
  bool get isCompleted => estado == 'COMPLETADO';
}