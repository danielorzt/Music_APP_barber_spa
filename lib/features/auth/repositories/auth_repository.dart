// lib/features/auth/repositories/auth_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';
import '../../../core/api/api_interceptors.dart';
import '../../profile/models/user_model.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  static const String _userKey = 'user_data';

  // Método para login con JWT
  Future<User> login(String email, String password) async {
    try {
      final requestData = {
        'email': email,
        'password': password,
      };
      
      final response = await _apiService.post('/auth/login', data: requestData);

      // Extraer JWT token de la respuesta
      if (response is Map<String, dynamic> && response.containsKey('jwt')) {
        final token = response['jwt'] as String;
        
        // Guardar token usando el interceptor
        await ApiInterceptor.saveToken(token);
        
        // Crear usuario básico con email (más datos pueden venir del perfil)
        final user = User(
          id: response['userId'],
          email: email,
          nombre: response['name'] ?? response['nombre'] ?? '',
          telefono: response['phone'] ?? response['telefono'],
        );

        // Guardar datos básicos del usuario
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, user.toJson().toString());

        return user;
      } else {
        throw Exception('Token JWT no encontrado en la respuesta');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Método para registro
  Future<User> register(RegisterRequest request) async {
    try {
      final response = await _apiService.post('/auth/registro', data: request.toJson());
      return User.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Método para verificar si hay una sesión activa
  Future<User?> getCurrentUser() async {
    try {
      // Verificar si hay un token válido
      final hasToken = await ApiInterceptor.hasValidToken();
      if (!hasToken) {
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData != null) {
        // Try to parse the JSON string
        try {
          return User.fromJson(userData as Map<String, dynamic>);
        } catch (e) {
          // If parsing fails, remove invalid data
          await prefs.remove(_userKey);
          return null;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Método para verificar si hay sesión activa (solo token)
  Future<bool> isLoggedIn() async {
    return await ApiInterceptor.hasValidToken();
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    try {
      // Eliminar token JWT
      await ApiInterceptor.deleteToken();
      
      // Eliminar datos del usuario
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      rethrow;
    }
  }
}