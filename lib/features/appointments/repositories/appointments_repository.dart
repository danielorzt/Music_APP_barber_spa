// lib/features/appointments/repositories/appointments_repository.dart
import '../../../core/services/api_service.dart';
import '../models/appointment_model.dart';

class AppointmentsRepository {
  final ApiService _apiService = ApiService();

  Future<List<Appointment>> getUserAppointments(int userId) async {
    try {
      final response = await _apiService.get('/appointments/user/$userId');
      return (response as List).map((item) => Appointment.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    try {
      final response = await _apiService.post(
        '/appointments',
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
        '/appointments/$appointmentId/status',
        data: {'status': status},
      );
      return Appointment.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}