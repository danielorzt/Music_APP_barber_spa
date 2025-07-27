// lib/features/auth/repositories/auth_repository.dart
import 'package:music_app/features/profile/models/user_model.dart';

/// Repository para manejar autenticación
/// NOTA: Este es un repository simplificado para desarrollo
/// En producción, usar AuthApiService directamente
class AuthRepository {
  
  /// Login simplificado - usar AuthApiService en su lugar
  Future<User?> login(String email, String password) async {
    // Esta implementación es para compatibilidad temporal
    // En producción, usar AuthApiService directamente
    throw Exception('Usar AuthApiService.login() directamente');
  }
  
  /// Registro simplificado - usar AuthApiService en su lugar
  Future<User?> register({
    required String email, 
    required String password, 
    required String nombre,
    String? telefono,
  }) async {
    // Esta implementación es para compatibilidad temporal
    // En producción, usar AuthApiService directamente
    throw Exception('Usar AuthApiService.register() directamente');
  }
  
  /// Logout simplificado - usar AuthApiService en su lugar
  Future<void> logout() async {
    // Esta implementación es para compatibilidad temporal
    // En producción, usar AuthApiService directamente
    throw Exception('Usar AuthApiService.logout() directamente');
  }
  
  /// Obtener usuario actual - usar AuthApiService en su lugar
  Future<User?> getCurrentUser() async {
    // Esta implementación es para compatibilidad temporal
    // En producción, usar AuthApiService directamente
    throw Exception('Usar AuthApiService.getCurrentUser() directamente');
  }
}