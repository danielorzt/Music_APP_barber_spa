// lib/core/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'http://192.168.1.X:63106/api/v1'; // Cambia la IP por la de tu servidor

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    _initDio();
  }

  void _initDio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Agrega interceptores para manejo de errores y token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Puedes agregar el token aquí si tienes uno
        // final token = await secureStorage.read(key: 'token');
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint('DioError: ${e.message}');
        // Puedes manejar errores específicos aquí
        return handler.next(e);
      },
    ));

    // Agrega un logger en modo de desarrollo
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  // Métodos genéricos para realizar peticiones HTTP
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  dynamic _handleError(DioException error) {
    String errorMessage = 'Ocurrió un error inesperado';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Tiempo de espera agotado. Verifica tu conexión.';
        break;
      case DioExceptionType.badResponse:
        if (error.response != null) {
          final statusCode = error.response!.statusCode;
          final data = error.response!.data;

          if (statusCode == 401) {
            errorMessage = 'No autorizado. Por favor inicia sesión nuevamente.';
            // Aquí puedes manejar el cierre de sesión automático
          } else if (statusCode == 403) {
            errorMessage = 'Acceso denegado.';
          } else if (statusCode == 404) {
            errorMessage = 'Recurso no encontrado.';
          } else if (statusCode == 500) {
            errorMessage = 'Error del servidor.';
          } else {
            // Intenta extraer el mensaje de error del backend
            if (data is Map && data.containsKey('error')) {
              errorMessage = data['error'];
            } else {
              errorMessage = 'Error $statusCode: ${error.message}';
            }
          }
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = 'La solicitud fue cancelada';
        break;
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          errorMessage = 'No hay conexión a Internet';
        }
        break;
      default:
        errorMessage = error.message ?? 'Ocurrió un error inesperado';
    }

    throw Exception(errorMessage);
  }
}