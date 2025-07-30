// lib/features/appointments/providers/appointments_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/services/appointments_real_api_service.dart';

class AppointmentsProvider with ChangeNotifier {
  final AppointmentsRealApiService _apiService = AppointmentsRealApiService();
  
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = false;
  String? _error;
  bool _hasLoaded = false; // Flag para evitar cargas múltiples

  // Getters
  List<Map<String, dynamic>> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLoaded => _hasLoaded;

  // Obtener todas las citas del usuario (solo una vez)
  Future<void> fetchAppointments() async {
    // Evitar cargas múltiples
    if (_isLoading || _hasLoaded) {
      print('⚠️ AppointmentsProvider: Ya está cargando o ya se cargó');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔍 AppointmentsProvider: Cargando agendamientos...');
      final result = await _apiService.getAgendamientos();
      
      if (result['success'] == true && result['data'] != null) {
        _appointments = List<Map<String, dynamic>>.from(result['data']);
        _hasLoaded = true;
        print('✅ AppointmentsProvider: ${_appointments.length} citas cargadas');
      } else {
        _error = result['error'] ?? 'Error al cargar las citas';
        print('❌ AppointmentsProvider: ${result['error']}');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ AppointmentsProvider: Error cargando citas: $e');
    }

    _isLoading = false;
    notifyListeners();
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
  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> appointmentData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔍 AppointmentsProvider: Creando nueva cita...');
      final result = await _apiService.createAgendamiento(appointmentData);
      
      if (result['success'] == true) {
        // Recargar las citas después de crear una nueva
        await refreshAppointments();
        print('✅ AppointmentsProvider: Cita creada exitosamente');
      } else {
        _error = result['error'] ?? 'Error al crear la cita';
        print('❌ AppointmentsProvider: ${result['error']}');
      }
      
      return result;
    } catch (e) {
      _error = e.toString();
      print('❌ AppointmentsProvider: Error creando cita: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancelar una cita
  Future<Map<String, dynamic>> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔍 AppointmentsProvider: Cancelando cita $appointmentId...');
      final result = await _apiService.cancelAgendamiento(appointmentId);
      
      if (result['success'] == true) {
        // Recargar las citas después de cancelar
        await refreshAppointments();
        print('✅ AppointmentsProvider: Cita cancelada exitosamente');
      } else {
        _error = result['error'] ?? 'Error al cancelar la cita';
        print('❌ AppointmentsProvider: ${result['error']}');
      }
      
      return result;
    } catch (e) {
      _error = e.toString();
      print('❌ AppointmentsProvider: Error cancelando cita: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener horarios disponibles
  Future<Map<String, dynamic>> getAvailableSlots({
    required String servicioId,
    required String sucursalId,
    required String fecha,
  }) async {
    try {
      print('🔍 AppointmentsProvider: Obteniendo horarios disponibles...');
      final result = await _apiService.getHorariosDisponibles(
        servicioId: servicioId,
        sucursalId: sucursalId,
        fecha: fecha,
      );
      
      if (result['success'] == true) {
        print('✅ AppointmentsProvider: Horarios obtenidos exitosamente');
      } else {
        print('❌ AppointmentsProvider: Error obteniendo horarios');
      }
      
      return result;
    } catch (e) {
      print('❌ AppointmentsProvider: Error obteniendo horarios: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Obtener personal disponible
  Future<Map<String, dynamic>> getAvailableStaff({
    required String servicioId,
    required String sucursalId,
    required String fecha,
    required String hora,
  }) async {
    try {
      print('🔍 AppointmentsProvider: Obteniendo personal disponible...');
      final result = await _apiService.getPersonalDisponible(
        servicioId: servicioId,
        sucursalId: sucursalId,
        fecha: fecha,
        hora: hora,
      );
      
      if (result['success'] == true) {
        print('✅ AppointmentsProvider: Personal obtenido exitosamente');
      } else {
        print('❌ AppointmentsProvider: Error obteniendo personal');
      }
      
      return result;
    } catch (e) {
      print('❌ AppointmentsProvider: Error obteniendo personal: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Limpiar datos (para logout)
  void clearData() {
    _appointments = [];
    _isLoading = false;
    _error = null;
    _hasLoaded = false;
    notifyListeners();
  }

  // Obtener citas próximas
  List<Map<String, dynamic>> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments.where((appointment) {
      final appointmentDate = DateTime.tryParse(appointment['fecha_hora'] ?? '') ?? DateTime.now();
      return appointmentDate.isAfter(now) && 
             appointment['estado'] != 'CANCELADA_CLIENTE' &&
             appointment['estado'] != 'CANCELADA_PERSONAL';
    }).toList();
  }

  // Obtener citas pasadas
  List<Map<String, dynamic>> get pastAppointments {
    final now = DateTime.now();
    return _appointments.where((appointment) {
      final appointmentDate = DateTime.tryParse(appointment['fecha_hora'] ?? '') ?? DateTime.now();
      return appointmentDate.isBefore(now) || 
             appointment['estado'] == 'COMPLETADA';
    }).toList();
  }
}