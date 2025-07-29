import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:music_app/core/api/api_client.dart';
import 'package:music_app/core/config/api_config.dart';

/// Servicio para APIs de agendamientos (citas, disponibilidad, horarios)
class AppointmentsRealApiService {
  final ApiClient _apiClient = ApiClient();

  /// Obtener todas las citas del usuario
  Future<Map<String, dynamic>> getAgendamientos() async {
    print('🔍 Obteniendo agendamientos del usuario...');
    
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.agendamientosEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['data'] != null) {
          print('✅ Agendamientos obtenidos exitosamente');
          return data;
        } else {
          print('❌ Formato de respuesta inválido');
          return _getMockAgendamientos();
        }
      } else {
        print('❌ Error en la respuesta: ${response.statusCode}');
        return _getMockAgendamientos();
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      print('📋 Usando datos mock...');
      return _getMockAgendamientos();
    } catch (e) {
      print('❌ Error inesperado: $e');
      return _getMockAgendamientos();
    }
  }

  /// Crear una nueva cita
  Future<Map<String, dynamic>> createAgendamiento(Map<String, dynamic> appointmentData) async {
    print('🔍 Creando agendamiento...');
    print('📤 Data: ${json.encode(appointmentData)}');
    
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.agendamientosEndpoint,
        data: appointmentData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Agendamiento creado exitosamente');
        return response.data;
      } else {
        print('❌ Error al crear agendamiento: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Error al crear la cita',
        };
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      print('❌ Error inesperado: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Obtener horarios disponibles
  Future<Map<String, dynamic>> getHorariosDisponibles({
    required String servicioId,
    required String sucursalId,
    required String fecha,
  }) async {
    print('🔍 Obteniendo horarios disponibles...');
    print('📤 Parámetros: servicio=$servicioId, sucursal=$sucursalId, fecha=$fecha');
    
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.disponibilidadEndpoint,
        queryParameters: {
          'servicio_id': servicioId,
          'sucursal_id': sucursalId,
          'fecha': fecha,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        print('✅ Horarios obtenidos exitosamente');
        return response.data;
      } else {
        print('❌ Error al obtener horarios: ${response.statusCode}');
        return _getMockHorarios();
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      print('📋 Usando datos mock...');
      return _getMockHorarios();
    } catch (e) {
      print('❌ Error inesperado: $e');
      return _getMockHorarios();
    }
  }

  /// Obtener personal disponible
  Future<Map<String, dynamic>> getPersonalDisponible({
    required String servicioId,
    required String sucursalId,
    required String fecha,
    required String hora,
  }) async {
    print('🔍 Obteniendo personal disponible...');
    
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.personalDisponibleEndpoint,
        queryParameters: {
          'servicio_id': servicioId,
          'sucursal_id': sucursalId,
          'fecha': fecha,
          'hora': hora,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        print('✅ Personal obtenido exitosamente');
        return response.data;
      } else {
        print('❌ Error al obtener personal: ${response.statusCode}');
        return _getMockPersonal();
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      print('📋 Usando datos mock...');
      return _getMockPersonal();
    } catch (e) {
      print('❌ Error inesperado: $e');
      return _getMockPersonal();
    }
  }

  /// Cancelar una cita
  Future<Map<String, dynamic>> cancelAgendamiento(String appointmentId) async {
    print('🔍 Cancelando agendamiento $appointmentId...');
    
    try {
      final response = await _apiClient.dio.put(
        '${ApiConfig.agendamientosEndpoint}/$appointmentId',
        data: {
          'estado': 'CANCELADA_CLIENTE',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        print('✅ Agendamiento cancelado exitosamente');
        return response.data;
      } else {
        print('❌ Error al cancelar agendamiento: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Error al cancelar la cita',
        };
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      print('❌ Error inesperado: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  // Datos mock como fallback
  Map<String, dynamic> _getMockAgendamientos() {
    return {
      'success': true,
      'data': [
        {
          'id': 1,
          'servicio': {
            'id': 1,
            'nombre': 'Corte Clásico',
            'precio': 25000.0,
          },
          'sucursal': {
            'id': 1,
            'nombre': 'Sucursal Centro',
            'direccion': 'Calle Principal 123',
          },
          'personal': {
            'id': 1,
            'nombre': 'Carlos Rodriguez',
          },
          'fecha': '2025-07-30',
          'hora': '14:00',
          'estado': 'CONFIRMADA',
          'notas': 'Corte clásico con acabado profesional',
        },
        {
          'id': 2,
          'servicio': {
            'id': 2,
            'nombre': 'Afeitado Tradicional',
            'precio': 18000.0,
          },
          'sucursal': {
            'id': 1,
            'nombre': 'Sucursal Centro',
            'direccion': 'Calle Principal 123',
          },
          'personal': {
            'id': 2,
            'nombre': 'Maria Gonzalez',
          },
          'fecha': '2025-08-02',
          'hora': '16:30',
          'estado': 'PROGRAMADA',
          'notas': 'Afeitado con navaja',
        },
      ],
      'message': 'Datos mock - API no disponible',
    };
  }

  Map<String, dynamic> _getMockHorarios() {
    return {
      'success': true,
      'data': [
        '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
        '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
        '17:00', '17:30', '18:00', '18:30',
      ],
      'message': 'Datos mock - API no disponible',
    };
  }

  Map<String, dynamic> _getMockPersonal() {
    return {
      'success': true,
      'data': [
        {
          'id': 1,
          'nombre': 'Carlos Rodriguez',
          'especialidad': 'Cortes Clásicos',
          'disponible': true,
        },
        {
          'id': 2,
          'nombre': 'Maria Gonzalez',
          'especialidad': 'Afeitado Tradicional',
          'disponible': true,
        },
        {
          'id': 3,
          'nombre': 'Juan Perez',
          'especialidad': 'Masajes',
          'disponible': false,
        },
      ],
      'message': 'Datos mock - API no disponible',
    };
  }
}