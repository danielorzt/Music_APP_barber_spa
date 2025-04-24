// lib/features/auth/repositories/auth_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';
import '../../profile/models/user_model.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';

  // Método para login
  Future<User> login(String email, String password) async {
    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _apiService.post('/auth/login', data: request.toJson());

      final user = User.fromJson(response);

      // Guardar datos del usuario en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, user.toJson().toString());

      // Si hay un token en la respuesta, guardarlo también
      if (response.containsKey('token')) {
        await prefs.setString(_tokenKey, response['token']);
      }

      return user;
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
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);

      if (userData != null) {
        return User.fromJson(userData as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Método para cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }
}