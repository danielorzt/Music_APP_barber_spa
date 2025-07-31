import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/dev_config.dart';

/// Servicio para probar la conexión con la API BMSPA
class ConnectionTestService {
  final Dio _dio = Dio();

  ConnectionTestService() {
    _dio.options.baseUrl = DevConfig.apiBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  /// Probar conectividad básica
  Future<Map<String, dynamic>> testBasicConnection() async {
    try {
      print('🔍 Probando conectividad básica...');
      
      final response = await _dio.get(
        '/health',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      return {
        'success': true,
        'statusCode': response.statusCode,
        'data': response.data,
        'message': 'Conexión exitosa',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.type}',
        'message': e.message,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
        'message': 'Error desconocido',
      };
    }
  }

  /// Probar endpoint de servicios
  Future<Map<String, dynamic>> testServiciosEndpoint() async {
    try {
      print('🔍 Probando endpoint de servicios...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('servicios')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;
      final servicios = data['data'] ?? data;
      
      return {
        'success': true,
        'statusCode': response.statusCode,
        'count': servicios is List ? servicios.length : 0,
        'data': servicios,
        'message': 'Servicios obtenidos correctamente',
      };
    } on DioException catch (e) {
      // Manejar específicamente errores de autenticación
      if (e.response?.statusCode == 401) {
        return {
          'success': false,
          'error': 'Endpoint requiere autenticación',
          'message': 'El endpoint está disponible pero requiere login',
          'statusCode': 401,
        };
      }
      
      return {
        'success': false,
        'error': 'Error obteniendo servicios: ${e.type}',
        'message': e.message,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
        'message': 'Error desconocido',
      };
    }
  }

  /// Probar endpoint de productos
  Future<Map<String, dynamic>> testProductosEndpoint() async {
    try {
      print('🔍 Probando endpoint de productos...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('productos')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final data = response.data;
      final productos = data['data'] ?? data;
      
      return {
        'success': true,
        'statusCode': response.statusCode,
        'count': productos is List ? productos.length : 0,
        'data': productos,
        'message': 'Productos obtenidos correctamente',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error obteniendo productos: ${e.type}',
        'message': e.message,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
        'message': 'Error desconocido',
      };
    }
  }

  /// Probar endpoint de autenticación
  Future<Map<String, dynamic>> testAuthEndpoint() async {
    try {
      print('🔍 Probando endpoint de autenticación...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('currentUser')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      return {
        'success': true,
        'statusCode': response.statusCode,
        'message': 'Endpoint de autenticación accesible',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error en autenticación: ${e.type}',
        'message': e.message,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
        'message': 'Error desconocido',
      };
    }
  }

  /// Probar todos los endpoints principales
  Future<Map<String, dynamic>> testAllEndpoints() async {
    print('🔍 Iniciando pruebas completas de conectividad...');
    
    final results = <String, Map<String, dynamic>>{};
    
    // Probar conectividad básica
    results['basic'] = await testBasicConnection();
    
    // Probar servicios
    results['servicios'] = await testServiciosEndpoint();
    
    // Probar productos
    results['productos'] = await testProductosEndpoint();
    
    // Probar autenticación
    results['auth'] = await testAuthEndpoint();
    
    // Resumen
    final successfulTests = results.values.where((r) => r['success'] == true).length;
    final totalTests = results.length;
    
    return {
      'success': successfulTests == totalTests,
      'totalTests': totalTests,
      'successfulTests': successfulTests,
      'failedTests': totalTests - successfulTests,
      'results': results,
      'message': '$successfulTests de $totalTests pruebas exitosas',
    };
  }

  /// Probar URL específica
  Future<Map<String, dynamic>> testSpecificUrl(String url) async {
    try {
      print('🔍 Probando URL: $url');
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      return {
        'success': true,
        'statusCode': response.statusCode,
        'data': response.data,
        'message': 'URL accesible',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error: ${e.type}',
        'message': e.message,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
        'message': 'Error desconocido',
      };
    }
  }
} 