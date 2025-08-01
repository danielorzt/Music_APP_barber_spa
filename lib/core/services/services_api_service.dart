import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/dev_config.dart';

class ServicesApiService {
  final Dio _dio = Dio();

  ServicesApiService() {
    _dio.options.baseUrl = DevConfig.apiBaseUrl;
    _dio.options.connectTimeout = DevConfig.defaultTimeout;
    _dio.options.receiveTimeout = DevConfig.defaultTimeout;
  }

  /// Obtener todos los servicios
  Future<List<Map<String, dynamic>>> getServicios() async {
    try {
      print('🔍 Obteniendo servicios...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('servicios')!,
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
        List<Map<String, dynamic>> servicios = [];
        
        if (data is List) {
          servicios = data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (data is Map && data['data'] is List) {
          servicios = (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        }
        
        print('✅ Servicios obtenidos: ${servicios.length}');
        return servicios;
      } else {
        print('❌ Error obteniendo servicios: ${response.statusCode}');
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

  /// Obtener servicios por categoría
  Future<List<Map<String, dynamic>>> getServiciosPorCategoria(int categoriaId) async {
    try {
      print('🔍 Obteniendo servicios de categoría $categoriaId...');
      
      final response = await _dio.get(
        '${DevConfig.getEndpoint('servicios')}?categoria_id=$categoriaId',
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
        List<Map<String, dynamic>> servicios = [];
        
        if (data is List) {
          servicios = data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (data is Map && data['data'] is List) {
          servicios = (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        }
        
        print('✅ Servicios de categoría obtenidos: ${servicios.length}');
        return servicios;
      } else {
        print('❌ Error obteniendo servicios de categoría: ${response.statusCode}');
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

  /// Obtener un servicio específico
  Future<Map<String, dynamic>?> getServicio(int id) async {
    try {
      print('🔍 Obteniendo servicio $id...');
      
      final response = await _dio.get(
        '${DevConfig.getEndpoint('servicio')!.replaceAll('{id}', id.toString())}',
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
        Map<String, dynamic>? servicio;
        
        if (data is Map<String, dynamic>) {
          servicio = data;
        } else if (data is Map && data['data'] is Map<String, dynamic>) {
          servicio = data['data'] as Map<String, dynamic>;
        } else if (data is Map) {
          // Convertir Map<dynamic, dynamic> a Map<String, dynamic>
          servicio = Map<String, dynamic>.from(data);
        }
        
        print('✅ Servicio obtenido');
        return servicio;
      } else {
        print('❌ Error obteniendo servicio: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      return null;
    } catch (e) {
      print('❌ Error inesperado: $e');
      return null;
    }
  }

  /// Obtener categorías
  Future<List<Map<String, dynamic>>> getCategorias() async {
    try {
      print('🔍 Obteniendo categorías...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('categorias')!,
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
        List<Map<String, dynamic>> categorias = [];
        
        if (data is List) {
          categorias = data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else if (data is Map && data['data'] is List) {
          categorias = (data['data'] as List).map((item) => Map<String, dynamic>.from(item)).toList();
        }
        
        print('✅ Categorías obtenidas: ${categorias.length}');
        return categorias;
      } else {
        print('❌ Error obteniendo categorías: ${response.statusCode}');
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