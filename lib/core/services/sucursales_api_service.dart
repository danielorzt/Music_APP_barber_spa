import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/dev_config.dart';

class SucursalesApiService {
  final Dio _dio = Dio();

  SucursalesApiService() {
    _dio.options.baseUrl = DevConfig.apiBaseUrl;
    _dio.options.connectTimeout = DevConfig.defaultTimeout;
    _dio.options.receiveTimeout = DevConfig.defaultTimeout;
  }

  /// Obtener todas las sucursales
  Future<List<Map<String, dynamic>>> getSucursales() async {
    try {
      print('🔍 Obteniendo sucursales...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('sucursales')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('📡 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<Map<String, dynamic>> sucursales = [];
        
        if (data is List) {
          sucursales = data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (data is Map && data['data'] is List) {
          sucursales = (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        }
        
        print('✅ Sucursales obtenidas: ${sucursales.length}');
        return sucursales;
      } else {
        print('❌ Error obteniendo sucursales: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      return [];
    } catch (e) {
      print('❌ Error inesperado: $e');
      return [];
    }
  }

  /// Obtener personal por sucursal
  Future<List<Map<String, dynamic>>> getPersonalPorSucursal(int sucursalId) async {
    try {
      print('🔍 Obteniendo personal de sucursal $sucursalId...');
      
      final response = await _dio.get(
        '${DevConfig.getEndpoint('personal')}?sucursal_id=$sucursalId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('📡 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<Map<String, dynamic>> personal = [];
        
        if (data is List) {
          personal = data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (data is Map && data['data'] is List) {
          personal = (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        }
        
        print('✅ Personal obtenido: ${personal.length}');
        return personal;
      } else {
        print('❌ Error obteniendo personal: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      return [];
    } catch (e) {
      print('❌ Error inesperado: $e');
      return [];
    }
  }

  /// Obtener horarios por sucursal
  Future<List<Map<String, dynamic>>> getHorariosPorSucursal(int sucursalId) async {
    try {
      print('🔍 Obteniendo horarios de sucursal $sucursalId...');
      
      final response = await _dio.get(
        '/Agendamiento_horarios/horarios?sucursal_id=$sucursalId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('📡 Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<Map<String, dynamic>> horarios = [];
        
        if (data is List) {
          horarios = data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (data is Map && data['data'] is List) {
          horarios = (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        }
        
        print('✅ Horarios obtenidos: ${horarios.length}');
        return horarios;
      } else {
        print('❌ Error obteniendo horarios: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      return [];
    } catch (e) {
      print('❌ Error inesperado: $e');
      return [];
    }
  }
} 