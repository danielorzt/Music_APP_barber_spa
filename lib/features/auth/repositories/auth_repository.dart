// lib/features/auth/repositories/auth_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/core/services/api_service.dart';
import 'package:music_app/features/auth/models/auth_model.dart';
import 'package:music_app/features/profile/models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;
  static const String _tokenKey = 'auth_token';

  AuthRepository(this._apiService);

  // Obtener token de acceso
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Error al obtener token: $e');
      return null;
    }
  }

  // Guardar token de acceso
  Future<bool> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Error al guardar token: $e');
      return false;
    }
  }

  // Eliminar token de acceso
  Future<bool> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tokenKey);
    } catch (e) {
      print('Error al eliminar token: $e');
      return false;
    }
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Login de usuario
  Future<User> login(String email, String password) async {
    try {
      final authRequest = AuthRequest(email: email, password: password);

      final response = await _apiService.post('auth/login', authRequest.toJson());
      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.success) {
        await saveToken(authResponse.token);

        // Obtener datos del usuario
        final userResponse = await _apiService.get('user/profile');
        return User.fromJson(userResponse['data']);
      } else {
        throw Exception(authResponse.message);
      }
    } catch (e) {
      // Para desarrollo, devolvemos un usuario de demostración
      if (email == 'demo@example.com' && password == '123456') {
        await saveToken('demo_token');
        return User(
          id: 1,
          name: 'Usuario Demo',
          email: 'demo@example.com',
          isPremium: true,
        );
      }

      throw Exception('Error de inicio de sesión: ${e.toString()}');
    }
  }

  // Registro de usuario
  Future<User> register(String name, String email, String password, String? phone) async {
    try {
      final authRequest = AuthRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );

      final response = await _apiService.post('auth/register', authRequest.toJson());
      final authResponse = AuthResponse.fromJson(response);

      if (authResponse.success) {
        await saveToken(authResponse.token);

        // Devolvemos el usuario con los datos del registro
        return User(
          id: 0, // El ID real vendrá del backend
          name: name,
          email: email,
          phone: phone ?? '',
        );
      } else {
        throw Exception(authResponse.message);
      }
    } catch (e) {
      // Para desarrollo, simulamos un registro exitoso
      if (email.contains('@') && password.length >= 6) {
        await saveToken('new_user_token');
        return User(
          id: 2,
          name: name,
          email: email,
          phone: phone ?? '',
        );
      }

      throw Exception('Error en el registro: ${e.toString()}');
    }
  }

  // Cerrar sesión
  Future<bool> logout() async {
    try {
      await _apiService.post('auth/logout', {});
      return await deleteToken();
    } catch (e) {
      // Incluso si la API falla, eliminamos el token local
      return await deleteToken();
    }
  }

  // Verificar estado del token
  Future<bool> checkToken() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }

      final response = await _apiService.get('auth/check');
      return response['valid'] == true;
    } catch (e) {
      print('Error al verificar token: $e');
      return false;
    }
  }
}