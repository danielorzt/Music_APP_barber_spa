import 'package:dio/dio.dart';
import 'package:music_app/core/api/api_interceptors.dart';
import 'package:music_app/core/config/api_config.dart';

class ApiClient {
  late final Dio _dio;

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    final options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: 15000),
      receiveTimeout: const Duration(milliseconds: 15000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Añadir interceptor para manejar tokens y errores
    _dio.interceptors.add(ApiInterceptor());
  }

  // Getter para acceder a la instancia de Dio
  Dio get dio => _dio;
}