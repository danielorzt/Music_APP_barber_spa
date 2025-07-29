import 'dart:convert';
import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para APIs de agendamientos y citas
class AppointmentsApiService extends BaseApiService {
  
  /// Verificar disponibilidad
  Future<Map<String, dynamic>> checkAvailability({
    required String servicioId,
    required String sucursalId,
    required String fecha,
  }) async {
    print('🔍 Verificando disponibilidad...');
    
    try {
      final response = await get(
        '${ApiConfig.disponibilidadEndpoint}?servicio_id=$servicioId&sucursal_id=$sucursalId&fecha=$fecha',
      );
      print('✅ Disponibilidad verificada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error verificando disponibilidad: $e');
      rethrow;
    }
  }
  
  /// Crear agendamiento
  Future<Map<String, dynamic>> createAppointment({
    required String servicioId,
    required String sucursalId,
    String? personalId,
    required String fechaHoraInicio,
    String? notasCliente,
  }) async {
    print('📅 Creando agendamiento...');
    
    try {
      final data = {
        'servicio_id': servicioId,
        'sucursal_id': sucursalId,
        'fecha_hora_inicio': fechaHoraInicio,
        if (personalId != null) 'personal_id': personalId,
        if (notasCliente != null) 'notas_cliente': notasCliente,
      };
      
      final response = await post(ApiConfig.agendamientosEndpoint, data);
      print('✅ Agendamiento creado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error creando agendamiento: $e');
      rethrow;
    }
  }
  
  /// Obtener agendamientos del usuario
  Future<Map<String, dynamic>> getUserAppointments() async {
    print('📋 Obteniendo agendamientos del usuario...');
    
    try {
      final response = await get(ApiConfig.agendamientosEndpoint);
      print('✅ Agendamientos obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo agendamientos: $e');
      rethrow;
    }
  }

  /// Obtener agendamientos próximos (método faltante)
  Future<Map<String, dynamic>> getUpcomingAppointments() async {
    print('📋 Obteniendo agendamientos próximos...');
    
    try {
      final response = await get('${ApiConfig.agendamientosEndpoint}?estado=CONFIRMADA&fecha_desde=${DateTime.now().toIso8601String()}');
      print('✅ Agendamientos próximos obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo agendamientos próximos: $e');
      rethrow;
    }
  }

  /// Obtener historial de agendamientos (método faltante)
  Future<Map<String, dynamic>> getAppointmentHistory() async {
    print('📋 Obteniendo historial de agendamientos...');
    
    try {
      final response = await get('${ApiConfig.agendamientosEndpoint}?estado=COMPLETADA&fecha_hasta=${DateTime.now().toIso8601String()}');
      print('✅ Historial de agendamientos obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo historial de agendamientos: $e');
      rethrow;
    }
  }
  
  /// Cancelar agendamiento
  Future<Map<String, dynamic>> cancelAppointment(String appointmentId) async {
    print('❌ Cancelando agendamiento $appointmentId...');
    
    try {
      final response = await put(
        '${ApiConfig.agendamientosEndpoint}/$appointmentId',
        {'estado': 'CANCELADA'},
      );
      print('✅ Agendamiento cancelado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error cancelando agendamiento: $e');
      rethrow;
    }
  }
  
  /// Obtener personal disponible
  Future<Map<String, dynamic>> getAvailableStaff({
    required String servicioId,
    required String sucursalId,
    required String fechaHora,
  }) async {
    print('👥 Obteniendo personal disponible...');
    
    try {
      final response = await get(
        '${ApiConfig.personalDisponibleEndpoint}?servicio_id=$servicioId&sucursal_id=$sucursalId&fecha_hora=$fechaHora',
      );
      print('✅ Personal disponible obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo personal disponible: $e');
      rethrow;
    }
  }
  
  /// Obtener horarios de sucursal
  Future<Map<String, dynamic>> getBranchHours(String sucursalId) async {
    print('🕐 Obteniendo horarios de sucursal $sucursalId...');
    
    try {
      final response = await get('${ApiConfig.horariosSucursalEndpoint}?sucursal_id=$sucursalId');
      print('✅ Horarios obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo horarios: $e');
      rethrow;
    }
  }
} 