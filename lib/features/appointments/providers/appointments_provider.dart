// lib/features/appointments/providers/appointments_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/services/appointments_api_service.dart';
import '../../../core/models/agendamiento.dart';

enum AppointmentsState { initial, loading, loaded, error }

class AppointmentsProvider with ChangeNotifier {
  final AppointmentsApiService _apiService = AppointmentsApiService();
  
  List<Agendamiento> _appointments = [];
  AppointmentsState _state = AppointmentsState.initial;
  String? _error;
  bool _hasLoaded = false; // Flag para evitar cargas múltiples

  // Getters
  List<Agendamiento> get appointments => _appointments;
  AppointmentsState get state => _state;
  String? get error => _error;
  bool get isLoading => _state == AppointmentsState.loading;
  bool get hasLoaded => _hasLoaded;

  // Obtener todas las citas del usuario (solo una vez)
  Future<void> fetchAppointments() async {
    // Evitar cargas múltiples
    if (_state == AppointmentsState.loading || _hasLoaded) {
      print('⚠️ AppointmentsProvider: Ya está cargando o ya se cargó');
      return;
    }

    _setState(AppointmentsState.loading);

    try {
      print('🔍 AppointmentsProvider: Cargando agendamientos...');
      final agendamientos = await _apiService.getMisAgendamientos();
      
      _appointments = agendamientos;
      _hasLoaded = true;
      _setState(AppointmentsState.loaded);
      print('✅ AppointmentsProvider: ${_appointments.length} citas cargadas');
    } catch (e) {
      _error = e.toString();
      _setState(AppointmentsState.error);
      print('❌ AppointmentsProvider: Error cargando citas: $e');
    }
  }

  // Obtener citas de un usuario específico (alias para fetchAppointments)
  Future<void> fetchUserAppointments(String userId) async {
    print('🔍 AppointmentsProvider: Cargando citas para usuario $userId');
    await fetchAppointments();
  }

  // Forzar recarga de citas (para pull-to-refresh)
  Future<void> refreshAppointments() async {
    print('🔄 AppointmentsProvider: Recargando citas...');
    _hasLoaded = false; // Resetear flag para permitir nueva carga
    await fetchAppointments();
  }

  // Crear una nueva cita
  Future<bool> createAppointment(Agendamiento appointmentData) async {
    _setState(AppointmentsState.loading);

    try {
      print('🔍 AppointmentsProvider: Creando nueva cita...');
      final agendamientoCreado = await _apiService.crearAgendamiento(appointmentData);
      
      // Agregar la nueva cita a la lista
      _appointments.add(agendamientoCreado);
      _setState(AppointmentsState.loaded);
      print('✅ AppointmentsProvider: Cita creada exitosamente');
      return true;
    } catch (e) {
      _error = e.toString();
      _setState(AppointmentsState.error);
      print('❌ AppointmentsProvider: Error creando cita: $e');
      return false;
    }
  }

  // Cancelar una cita
  Future<bool> cancelAppointment(int appointmentId, {String? motivo}) async {
    _setState(AppointmentsState.loading);

    try {
      print('🔍 AppointmentsProvider: Cancelando cita $appointmentId...');
      final success = await _apiService.cancelarAgendamiento(appointmentId);
      
      if (success) {
        // Actualizar el estado de la cita en la lista local
        final index = _appointments.indexWhere((a) => a.id == appointmentId);
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            estado: 'CANCELADO',
            motivoCancelacion: motivo,
          );
        }
        _setState(AppointmentsState.loaded);
        print('✅ AppointmentsProvider: Cita cancelada exitosamente');
        return true;
      } else {
        _error = 'No se pudo cancelar la cita';
        _setState(AppointmentsState.error);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setState(AppointmentsState.error);
      print('❌ AppointmentsProvider: Error cancelando cita: $e');
      return false;
    }
  }

  // Actualizar una cita
  Future<bool> updateAppointment(int appointmentId, Map<String, dynamic> data) async {
    _setState(AppointmentsState.loading);

    try {
      print('🔍 AppointmentsProvider: Actualizando cita $appointmentId...');
      final agendamientoActualizado = await _apiService.actualizarAgendamiento(appointmentId, data);
      
      // Actualizar la cita en la lista local
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = agendamientoActualizado;
      }
      _setState(AppointmentsState.loaded);
      print('✅ AppointmentsProvider: Cita actualizada exitosamente');
      return true;
    } catch (e) {
      _error = e.toString();
      _setState(AppointmentsState.error);
      print('❌ AppointmentsProvider: Error actualizando cita: $e');
      return false;
    }
  }

  // Obtener horarios disponibles
  Future<List<Map<String, dynamic>>> getAvailableSlots({
    required DateTime fecha,
    required int servicioId,
  }) async {
    try {
      print('🔍 AppointmentsProvider: Obteniendo horarios disponibles...');
      final disponibilidad = await _apiService.getDisponibilidad(fecha, servicioId);
      print('✅ AppointmentsProvider: Horarios obtenidos exitosamente');
      return disponibilidad;
    } catch (e) {
      print('❌ AppointmentsProvider: Error obteniendo horarios: $e');
      return [];
    }
  }

  // Obtener una cita específica
  Future<Agendamiento?> getAppointment(int appointmentId) async {
    try {
      print('🔍 AppointmentsProvider: Obteniendo cita $appointmentId...');
      final agendamiento = await _apiService.getAgendamiento(appointmentId);
      print('✅ AppointmentsProvider: Cita obtenida exitosamente');
      return agendamiento;
    } catch (e) {
      print('❌ AppointmentsProvider: Error obteniendo cita: $e');
      return null;
    }
  }

  void clearError() {
    _error = null;
    if (_state == AppointmentsState.error) {
      _setState(AppointmentsState.loaded);
    }
  }

  // Limpiar datos (para logout)
  void clearData() {
    _appointments = [];
    _state = AppointmentsState.initial;
    _error = null;
    _hasLoaded = false;
    notifyListeners();
  }

  // Método privado para actualizar el estado
  void _setState(AppointmentsState newState) {
    _state = newState;
    notifyListeners();
  }

  // Obtener citas próximas
  List<Agendamiento> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments.where((appointment) {
      return appointment.fechaHora.isAfter(now) && appointment.isActive;
    }).toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  // Obtener citas pasadas
  List<Agendamiento> get pastAppointments {
    final now = DateTime.now();
    return _appointments.where((appointment) {
      return appointment.fechaHora.isBefore(now) || appointment.isCompleted;
    }).toList()
      ..sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
  }

  // Obtener citas canceladas
  List<Agendamiento> get cancelledAppointments {
    return _appointments.where((appointment) => appointment.isCancelled).toList()
      ..sort((a, b) => b.fechaHora.compareTo(a.fechaHora));
  }

  // Obtener citas para hoy
  List<Agendamiento> get todayAppointments {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _appointments.where((appointment) {
      return appointment.fechaHora.isAfter(today) && 
             appointment.fechaHora.isBefore(tomorrow) &&
             appointment.isActive;
    }).toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  // Obtener citas para esta semana
  List<Agendamiento> get thisWeekAppointments {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return _appointments.where((appointment) {
      return appointment.fechaHora.isAfter(startOfWeek) && 
             appointment.fechaHora.isBefore(endOfWeek) &&
             appointment.isActive;
    }).toList()
      ..sort((a, b) => a.fechaHora.compareTo(b.fechaHora));
  }

  // Obtener estadísticas
  Map<String, int> get statistics {
    return {
      'total': _appointments.length,
      'upcoming': upcomingAppointments.length,
      'past': pastAppointments.length,
      'cancelled': cancelledAppointments.length,
      'today': todayAppointments.length,
      'thisWeek': thisWeekAppointments.length,
    };
  }
}