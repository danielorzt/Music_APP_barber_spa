import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para gestionar agendamientos/citas
class AppointmentsApiService extends BaseApiService {
  
  /// Obtener todas las citas del usuario autenticado
  Future<Map<String, dynamic>> getUserAppointments({
    int? page,
    int? limit,
    String? estado,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (estado != null) params['estado'] = estado;
    if (fechaInicio != null) params['fecha_inicio'] = fechaInicio;
    if (fechaFin != null) params['fecha_fin'] = fechaFin;
    
    final endpoint = buildEndpointWithParams(ApiConfig.agendamientosEndpoint, params);
    
    print('🔍 Obteniendo citas del usuario...');
    final result = await get(endpoint);
    
    if (result['success']) {
      final citas = extractList(result['data'], 'agendamientos');
      print('✅ ${citas.length} citas obtenidas');
      
      return {
        'success': true,
        'citas': citas,
        'total': result['data']['total'] ?? citas.length,
        'current_page': result['data']['current_page'] ?? 1,
        'last_page': result['data']['last_page'] ?? 1,
      };
    }
    
    return result;
  }
  
  /// Obtener una cita específica por ID
  Future<Map<String, dynamic>> getAppointment(String id) async {
    print('🔍 Obteniendo cita ID: $id');
    final result = await get('${ApiConfig.agendamientosEndpoint}/$id');
    
    if (result['success']) {
      final cita = extractData(result['data'], 'agendamiento') ?? result['data'];
      print('✅ Cita obtenida: ${cita['fecha_hora_inicio'] ?? 'Sin fecha'}');
      
      return {
        'success': true,
        'cita': cita,
      };
    }
    
    return result;
  }
  
  /// Crear una nueva cita
  Future<Map<String, dynamic>> createAppointment({
    required String servicioId,
    required String sucursalId,
    required String fechaHoraInicio,
    required String fechaHoraFin,
    String? personalId,
    String? notasCliente,
  }) async {
    final data = {
      'servicio_id': servicioId,
      'sucursal_id': sucursalId,
      'fecha_hora_inicio': fechaHoraInicio,
      'fecha_hora_fin': fechaHoraFin,
      if (personalId != null) 'personal_id': personalId,
      if (notasCliente != null) 'notas_cliente': notasCliente,
    };
    
    print('📅 Creando nueva cita...');
    final result = await post(ApiConfig.agendamientosEndpoint, data);
    
    if (result['success']) {
      final cita = extractData(result['data'], 'agendamiento') ?? result['data'];
      print('✅ Cita creada exitosamente');
      
      return {
        'success': true,
        'cita': cita,
        'message': 'Cita agendada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Actualizar una cita existente
  Future<Map<String, dynamic>> updateAppointment(
    String id, {
    String? fechaHoraInicio,
    String? fechaHoraFin,
    String? personalId,
    String? notasCliente,
    String? estado,
  }) async {
    final data = <String, dynamic>{};
    if (fechaHoraInicio != null) data['fecha_hora_inicio'] = fechaHoraInicio;
    if (fechaHoraFin != null) data['fecha_hora_fin'] = fechaHoraFin;
    if (personalId != null) data['personal_id'] = personalId;
    if (notasCliente != null) data['notas_cliente'] = notasCliente;
    if (estado != null) data['estado'] = estado;
    
    print('📝 Actualizando cita ID: $id');
    final result = await put('${ApiConfig.agendamientosEndpoint}/$id', data);
    
    if (result['success']) {
      final cita = extractData(result['data'], 'agendamiento') ?? result['data'];
      print('✅ Cita actualizada exitosamente');
      
      return {
        'success': true,
        'cita': cita,
        'message': 'Cita actualizada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Cancelar una cita
  Future<Map<String, dynamic>> cancelAppointment(String id, {String? motivoCancelacion}) async {
    final data = {
      'estado': 'CANCELADA',
      if (motivoCancelacion != null) 'notas_internas': motivoCancelacion,
    };
    
    print('❌ Cancelando cita ID: $id');
    final result = await put('${ApiConfig.agendamientosEndpoint}/$id', data);
    
    if (result['success']) {
      print('✅ Cita cancelada exitosamente');
      return {
        'success': true,
        'message': 'Cita cancelada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Eliminar una cita completamente
  Future<Map<String, dynamic>> deleteAppointment(String id) async {
    print('🗑️ Eliminando cita ID: $id');
    final result = await delete('${ApiConfig.agendamientosEndpoint}/$id');
    
    if (result['success']) {
      print('✅ Cita eliminada exitosamente');
      return {
        'success': true,
        'message': 'Cita eliminada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Obtener citas próximas (siguientes 30 días)
  Future<Map<String, dynamic>> getUpcomingAppointments() async {
    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 30));
    
    return getUserAppointments(
      fechaInicio: now.toIso8601String(),
      fechaFin: futureDate.toIso8601String(),
      estado: 'PROGRAMADA',
    );
  }
  
  /// Obtener historial de citas (citas pasadas)
  Future<Map<String, dynamic>> getAppointmentHistory() async {
    return getUserAppointments(
      fechaFin: DateTime.now().toIso8601String(),
    );
  }
  
  /// Obtener citas por estado
  Future<Map<String, dynamic>> getAppointmentsByStatus(String estado) async {
    return getUserAppointments(estado: estado);
  }
  
  /// Verificar disponibilidad de horarios
  Future<Map<String, dynamic>> checkAvailability({
    required String servicioId,
    required String sucursalId,
    required String fecha,
    String? personalId,
  }) async {
    final params = {
      'servicio_id': servicioId,
      'sucursal_id': sucursalId,
      'fecha': fecha,
      if (personalId != null) 'personal_id': personalId,
    };
    
    final endpoint = buildEndpointWithParams(
      '${ApiConfig.agendamientosEndpoint}/availability', 
      params
    );
    
    print('🔍 Verificando disponibilidad...');
    final result = await get(endpoint);
    
    if (result['success']) {
      final horariosDisponibles = extractList(result['data'], 'horarios_disponibles');
      print('✅ ${horariosDisponibles.length} horarios disponibles');
      
      return {
        'success': true,
        'horarios_disponibles': horariosDisponibles,
        'fecha': fecha,
      };
    }
    
    return result;
  }
  
  /// Obtener personal disponible para un servicio
  Future<Map<String, dynamic>> getAvailableStaff({
    required String servicioId,
    required String sucursalId,
  }) async {
    final params = {
      'servicio_id': servicioId,
      'sucursal_id': sucursalId,
    };
    
    final endpoint = buildEndpointWithParams(
      '${ApiConfig.agendamientosEndpoint}/staff', 
      params
    );
    
    print('🔍 Obteniendo personal disponible...');
    final result = await get(endpoint);
    
    if (result['success']) {
      final personal = extractList(result['data'], 'personal');
      print('✅ ${personal.length} miembros del personal disponibles');
      
      return {
        'success': true,
        'personal': personal,
      };
    }
    
    return result;
  }
} 