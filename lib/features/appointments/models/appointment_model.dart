// lib/features/appointments/models/appointment_model.dart

enum AppointmentStatus { pending, confirmed, completed, cancelled }

class Appointment {
  final int id;
  final int userId;
  final int serviceId;
  final DateTime dateTime;
  final int durationMinutes;
  final AppointmentStatus status;
  final String notes;
  final int? staffId;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.dateTime,
    required this.durationMinutes,
    this.status = AppointmentStatus.pending,
    this.notes = '',
    this.staffId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userId: json['userId'],
      serviceId: json['serviceId'],
      dateTime: DateTime.parse(json['dateTime']),
      durationMinutes: json['durationMinutes'],
      status: _parseAppointmentStatus(json['status']),
      notes: json['notes'] ?? '',
      staffId: json['staffId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceId': serviceId,
      'dateTime': dateTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status.toString().split('.').last,
      'notes': notes,
      'staffId': staffId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Appointment copyWith({
    int? id,
    int? userId,
    int? serviceId,
    DateTime? dateTime,
    int? durationMinutes,
    AppointmentStatus? status,
    String? notes,
    int? staffId,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      dateTime: dateTime ?? this.dateTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      staffId: staffId ?? this.staffId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static AppointmentStatus _parseAppointmentStatus(String? statusStr) {
    if (statusStr == null) return AppointmentStatus.pending;

    switch (statusStr.toLowerCase()) {
      case 'confirmed': return AppointmentStatus.confirmed;
      case 'completed': return AppointmentStatus.completed;
      case 'cancelled': return AppointmentStatus.cancelled;
      default: return AppointmentStatus.pending;
    }
  }
}