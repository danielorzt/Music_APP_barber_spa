import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:music_app/core/api/api_client.dart';
// import 'package:music_app/core/constants/api_endpoints.dart';
import 'package:music_app/features/profile/models/user_model.dart';

class AuthRepository {
  // final Dio _dio = ApiClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<User> login(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Datos mock para testing
    if (email == 'test@test.com' && password == '123456') {
      final mockUser = User(
        id: 1,
        nombre: 'Usuario Test',
        email: email,
        telefono: '+573001234567',
        tipo: 'CLIENTE',
        estado: 'activo',
        imagen: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      );
      
      // Guardar token mock
      await _storage.write(key: 'auth_token', value: 'mock_token_12345');
      
      return mockUser;
    } else {
      throw Exception('Credenciales inválidas. Usa test@test.com / 123456');
    }
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _dio.post(
    //     ApiEndpoints.login,
    //     data: {
    //       'email': email,
    //       'password': password,
    //     },
    //   );

    //   if (response.statusCode == 200 && response.data != null) {
    //     final token = response.data['token'] as String; 
    //     final userJson = response.data['user'] as Map<String, dynamic>;

    //     // Guardar el token de forma segura
    //     await _storage.write(key: 'auth_token', value: token);

    //     // Devolver el objeto User
    //     return User.fromJson(userJson);
    //   } else {
    //     throw Exception('Error en el login: Respuesta no válida');
    //   }
    // } on DioException catch (e) {
    //   // Manejar errores de Dio (red, 4xx, 5xx)
    //   final errorMessage = e.response?.data['message'] ?? 'Error de red. Inténtalo de nuevo.';
    //   throw Exception(errorMessage);
    // } catch (e) {
    //   // Manejar otros errores
    //   throw Exception('Ocurrió un error inesperado: ${e.toString()}');
    // }
  }

  Future<void> logout() async {
    // Borrar el token del almacenamiento
    await _storage.delete(key: 'auth_token');
    // Aquí también se podría llamar a un endpoint de /logout en el backend si existiera
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<User?> getCurrentUser() async {
    final token = await getToken();
    if (token == null) return null;
    
    // Datos mock para usuario actual
    return User(
      id: 1,
      nombre: 'Usuario Test',
      email: 'test@test.com',
      telefono: '+573001234567',
      tipo: 'CLIENTE',
      estado: 'activo',
      imagen: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    );
    
    // TODO: Implement getting current user from API
    // For now, return null if no cached user data
    // return null;
  }
}