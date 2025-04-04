// lib/features/profile/repositories/user_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/core/services/api_service.dart';
import 'package:music_app/features/profile/models/user_model.dart';

class UserRepository {
  final ApiService _apiService;
  static const String _userKey = 'current_user';

  UserRepository(this._apiService);

  // Obtener usuario actual desde el almacenamiento local
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userKey);

      if (userString == null || userString.isEmpty) {
        return null;
      }

      return User.fromJson(jsonDecode(userString));
    } catch (e) {
      print('Error al obtener usuario: $e');
      return null;
    }
  }

  // Guardar usuario en almacenamiento local
  Future<bool> saveCurrentUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      print('Error al guardar usuario: $e');
      return false;
    }
  }

  // Login de usuario
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      final user = User.fromJson(response['user']);
      await saveCurrentUser(user);
      return user;
    } catch (e) {
      // Para desarrollo, devolvemos un usuario de demostración
      if (email == 'demo@example.com' && password == '123456') {
        final demoUser = User(
          id: 1,
          name: 'Usuario Demo',
          email: 'demo@example.com',
          isPremium: true,
        );
        await saveCurrentUser(demoUser);
        return demoUser;
      }

      throw Exception('Error de inicio de sesión: $e');
    }
  }

  // Cerrar sesión
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_userKey);
    } catch (e) {
      print('Error al cerrar sesión: $e');
      return false;
    }
  }

  // Actualizar perfil de usuario
  Future<User> updateProfile(User user) async {
    try {
      final response = await _apiService.post('users/profile', user.toJson());
      final updatedUser = User.fromJson(response['data']);
      await saveCurrentUser(updatedUser);
      return updatedUser;
    } catch (e) {
      // Si la API falla, actualizamos solo localmente
      await saveCurrentUser(user);
      return user;
    }
  }
}