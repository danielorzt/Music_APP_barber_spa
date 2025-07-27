import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../features/profile/models/user_model.dart';
import '../constants/api_endpoints.dart';

class AuthRepository {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  Future<User?> login(String email, String password) async {
    try {
      // Para desarrollo offline, simulamos la respuesta
      await Future.delayed(const Duration(seconds: 1));
      
      // Simular diferentes usuarios
      if (email == 'admin@barbershop.com') {
        return const User(
          id: '1',
          nombre: 'Administrador',
          email: 'admin@barbershop.com',
          telefono: '+1234567890',
          role: 'admin',
        );
      } else {
        return const User(
          id: '2',
          nombre: 'Cliente Demo',
          email: 'cliente@demo.com',
          telefono: '+1234567890',
          role: 'client',
        );
      }
      
      /* Código para API real (comentado para modo offline)
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];
        
        // Guardar token de forma segura
        await _storage.write(key: 'auth_token', value: token);
        
        return User.fromJson(userData);
      } else {
        throw Exception('Error al iniciar sesión');
      }
      */
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<User?> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) async {
    try {
      // Para desarrollo offline, simulamos la respuesta
      await Future.delayed(const Duration(seconds: 2));
      
      return User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        email: email,
        telefono: telefono,
        role: 'client',
      );
      
      /* Código para API real (comentado para modo offline)
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.register}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'password': password,
          'telefono': telefono,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];
        
        // Guardar token de forma segura
        await _storage.write(key: 'auth_token', value: token);
        
        return User.fromJson(userData);
      } else {
        throw Exception('Error al registrar usuario');
      }
      */
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) return null;

      // Para desarrollo offline, retornamos null
      return null;

      /* Código para API real (comentado para modo offline)
      final response = await http.get(
        Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.me}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else {
        await logout(); // Token inválido
        return null;
      }
      */
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      
      /* Código para API real (comentado para modo offline)
      final token = await _storage.read(key: 'auth_token');
      if (token != null) {
        await http.post(
          Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.logout}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
      */
    } catch (e) {
      // Ignorar errores de logout
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }
}