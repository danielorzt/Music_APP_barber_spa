// lib/features/appointments/repositories/appointments_repository.dart
import '../../../core/services/api_service.dart';
import '../models/appointment_model.dart';

class AppointmentsRepository {
  final ApiService _apiService = ApiService();

  Future<List<Appointment>> getUserAppointments(int userId) async {
    try {
      final response = await _apiService.get('/agendamientos/usuario/$userId');
      return (response as List).map((item) => Appointment.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final response = await _apiService.post(
        '/agendamientos',
        data: appointment.toJson(),
      );
      return Appointment.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Appointment> updateAppointmentStatus(int appointmentId, String status) async {
    try {
      final response = await _apiService.put(
        '/agendamientos/$appointmentId/status',
        data: {'estado': status},
      );
      return Appointment.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}