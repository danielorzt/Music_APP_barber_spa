// lib/core/api/api_interceptors.dart
// ARCHIVO COMENTADO PARA FUNCIONAMIENTO SIN API
// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter/foundation.dart';

// class ApiInterceptor extends Interceptor {
//   static const FlutterSecureStorage _storage = FlutterSecureStorage();
//   static const String _tokenKey = 'jwt_token';

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     // No añadir token a las rutas de autenticación
//     if (options.path.contains('/auth/login') || options.path.contains('/auth/register')) {
//       return handler.next(options);
//     }

//     try {
//       final token = await _storage.read(key: _tokenKey);
//       if (token != null && token.isNotEmpty) {
//         options.headers['Authorization'] = 'Bearer $token';
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error reading token from secure storage: $e');
//       }
//     }
    
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 401) {
//       _handleUnauthorized();
//     }
    
//     handler.next(err);
//   }

//   static Future<void> _handleUnauthorized() async {
//     try {
//       await _storage.delete(key: _tokenKey);
//       if (kDebugMode) {
//         print('Token deleted due to 401 error - user needs to login again');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error deleting token: $e');
//       }
//     }
//   }

//   static Future<void> saveToken(String token) async {
//     try {
//       await _storage.write(key: _tokenKey, value: token);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error saving token: $e');
//       }
//       rethrow;
//     }
//   }

//   static Future<String?> getToken() async {
//     try {
//       return await _storage.read(key: _tokenKey);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error reading token: $e');
//       }
//       return null;
//     }
//   }

//   static Future<bool> hasValidToken() async {
//     try {
//       final token = await _storage.read(key: _tokenKey);
//       return token != null && token.isNotEmpty;
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error checking token validity: $e');
//       }
//       return false;
//     }
//   }

//   static Future<void> deleteToken() async {
//     try {
//       await _storage.delete(key: _tokenKey);
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error deleting token: $e');
//       }
//       rethrow;
//     }
//   }
// }