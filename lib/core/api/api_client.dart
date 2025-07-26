// lib/core/api/api_client.dart
// ARCHIVO COMENTADO PARA FUNCIONAMIENTO SIN API
// import 'package:dio/dio.dart';
// import 'package:music_app/core/api/api_interceptors.dart';
// import 'package:music_app/core/constants/api_endpoints.dart';

// class ApiClient {
//   late final Dio _dio;

//   // Singleton instance
//   static final ApiClient _instance = ApiClient._internal();

//   factory ApiClient() {
//     return _instance;
//   }

//   ApiClient._internal() {
//     final options = BaseOptions(
//       baseUrl: ApiEndpoints.baseUrl,
//       connectTimeout: const Duration(milliseconds: 15000),
//       receiveTimeout: const Duration(milliseconds: 15000),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );

//     _dio = Dio(options);

//     // Añadir interceptor para manejar tokens y errores
//     _dio.interceptors.add(ApiInterceptor());
//   }

//   // Getter para acceder a la instancia de Dio
//   Dio get dio => _dio;
// }