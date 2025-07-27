// lib/features/appointments/providers/appointments_provider.dart
import 'package:flutter/foundation.dart';
import '../models/appointment_model.dart';
import '../repositories/appointments_repository.dart';

class AppointmentsProvider with ChangeNotifier {
  final AppointmentsRepository _repository = AppointmentsRepository();

  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserAppointments(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // El repositorio espera un int, así que hacemos la conversión aquí
      final intUserId = int.tryParse(userId);
      if (intUserId != null) {
        _appointments = await _repository.getUserAppointments(intUserId);
      } else {
        throw Exception('ID de usuario inválido');
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createAppointment(Appointment appointment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.createAppointment(appointment);
      // Recargar las citas después de crear una nueva
      await fetchUserAppointments(appointment.usuarioId);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateAppointmentStatus(appointmentId, 'CANCELADA');
      // Actualizar la lista local
      _appointments = _appointments.map((appointment) {
        if (appointment.id == appointmentId) {
          return Appointment(
            id: appointment.id,
            fechaHora: appointment.fechaHora,
            estado: 'CANCELADA',
            mensaje: appointment.mensaje,
            usuarioId: appointment.usuarioId,
            serviceId: appointment.serviceId,
            branchId: appointment.branchId,
            servicio: appointment.servicio,
            sucursal: appointment.sucursal,
          );
        }
        return appointment;
      }).toList();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}