// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:music_app/features/profile/models/user_model.dart';
import 'package:music_app/core/services/auth_api_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
  final AuthApiService _apiService = AuthApiService();
  
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _error;
  bool _isLoading = false;

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get error => _error;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _isLoading;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _error = null;
    
    try {
      print('🔐 AuthProvider: Iniciando login...');
      
      // Validación básica
      if (email.isEmpty || password.isEmpty) {
        _error = 'Email y contraseña son requeridos';
        _status = AuthStatus.error;
        return false;
      }
      
      // Llamada a la API real
      final result = await _apiService.login(email, password);
      
      if (result['success']) {
        print('✅ AuthProvider: Login exitoso');
        
        // Extraer datos del usuario de la respuesta
        final userData = result['user'];
        if (userData != null) {
          // Verificar si userData es ya un objeto User o un Map
          if (userData is User) {
            _currentUser = userData;
          } else if (userData is Map<String, dynamic>) {
            _currentUser = User.fromJson(userData);
          } else {
            _error = 'Formato de datos de usuario inválido';
            _status = AuthStatus.error;
            return false;
          }
          _status = AuthStatus.authenticated;
          _error = null; // Limpiar error en caso de éxito
          print('👤 Usuario autenticado: ${_currentUser?.nombre}');
          return true;
        } else {
          _error = 'Datos de usuario inválidos';
          _status = AuthStatus.error;
          return false;
        }
      } else {
        // Mejorar mensajes de error
        String errorMessage = result['error'] ?? 'Error desconocido en el login';
        
        // Mapear errores comunes
        if (errorMessage.contains('credentials')) {
          errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
        } else if (errorMessage.contains('Unauthorized')) {
          errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
        } else if (errorMessage.contains('network')) {
          errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
        } else if (errorMessage.contains('timeout')) {
          errorMessage = 'Tiempo de espera agotado. Intenta nuevamente.';
        }
        
        _error = errorMessage;
        _status = AuthStatus.error;
        print('❌ AuthProvider: $errorMessage');
        return false;
      }
    } catch (e) {
      String errorMessage = 'Error inesperado: $e';
      
      // Mejorar mensajes de error de excepción
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tiempo de espera agotado. Intenta nuevamente.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Error en el formato de respuesta del servidor.';
      }
      
      _error = errorMessage;
      _status = AuthStatus.error;
      print('💥 AuthProvider Error: $errorMessage');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) async {
    _setLoading(true);
    _error = null;
    
    try {
      print('📝 AuthProvider: Iniciando registro...');
      
      // Validación básica
      if (email.isEmpty || password.isEmpty || nombre.isEmpty) {
        _error = 'Todos los campos son requeridos';
        _status = AuthStatus.error;
        return false;
      }
      
      // Llamada a la API real
      final result = await _apiService.register(
        nombre: nombre,
        email: email,
        password: password,
        telefono: telefono,
      );
      
      if (result['success']) {
        print('✅ AuthProvider: Registro exitoso');
        
        // Extraer datos del usuario de la respuesta
        final userData = result['user'];
        if (userData != null) {
          // Verificar si userData es ya un objeto User o un Map
          if (userData is User) {
            _currentUser = userData;
          } else if (userData is Map<String, dynamic>) {
            _currentUser = User.fromJson(userData);
          } else {
            _error = 'Formato de datos de usuario inválido';
            _status = AuthStatus.error;
            return false;
          }
          _status = AuthStatus.authenticated;
          _error = null; // Limpiar error en caso de éxito
          print('👤 Usuario registrado: ${_currentUser?.nombre}');
          return true;
        } else {
          _error = 'Datos de usuario inválidos';
          _status = AuthStatus.error;
          return false;
        }
      } else {
        // Mejorar mensajes de error
        String errorMessage = result['error'] ?? 'Error desconocido en el registro';
        
        // Mapear errores comunes
        if (errorMessage.contains('email') && errorMessage.contains('already')) {
          errorMessage = 'El email ya está registrado. Intenta con otro email o inicia sesión.';
        } else if (errorMessage.contains('validation')) {
          errorMessage = 'Datos inválidos. Verifica que todos los campos sean correctos.';
        } else if (errorMessage.contains('network')) {
          errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
        } else if (errorMessage.contains('timeout')) {
          errorMessage = 'Tiempo de espera agotado. Intenta nuevamente.';
        }
        
        _error = errorMessage;
        _status = AuthStatus.error;
        print('❌ AuthProvider: $errorMessage');
        return false;
      }
    } catch (e) {
      String errorMessage = 'Error inesperado: $e';
      
      // Mejorar mensajes de error de excepción
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tiempo de espera agotado. Intenta nuevamente.';
      } else if (e.toString().contains('FormatException')) {
        errorMessage = 'Error en el formato de respuesta del servidor.';
      }
      
      _error = errorMessage;
      _status = AuthStatus.error;
      print('💥 AuthProvider Error: $errorMessage');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      print('🚪 AuthProvider: Cerrando sesión...');
      
      // Llamada a la API para logout
      await _apiService.logout();
      
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _error = null;
      
      print('✅ AuthProvider: Sesión cerrada exitosamente');
    } catch (e) {
      _error = 'Error al cerrar sesión: $e';
      print('❌ AuthProvider Logout Error: $e');
      
      // Aunque haya error, cerrar sesión localmente
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? nombre,
    String? telefono,
    String? direccion,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    
    try {
      // Por ahora mantener funcionamiento local
      // TODO: Implementar API call cuando el endpoint esté disponible
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = _currentUser!.copyWith(
        nombre: nombre ?? _currentUser!.nombre,
        telefono: telefono ?? _currentUser!.telefono,
      );
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al actualizar perfil: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Verificar si hay sesión guardada y validar token
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      print('🔍 AuthProvider: Verificando estado de autenticación...');
      
      // Verificar si hay token guardado
      final hasToken = await _apiService.hasValidToken();
      if (!hasToken) {
        print('🔍 No hay token guardado');
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }
      
      // Verificar token con el servidor
      final result = await _apiService.getCurrentUser();
      if (result['success']) {
        print('✅ Token válido, usuario encontrado');
        _currentUser = User.fromJson(result['user']);
        _status = AuthStatus.authenticated;
        _error = null; // Limpiar error en caso de éxito
        print('👤 Usuario autenticado: ${_currentUser?.nombre}');
      } else {
        print('❌ Token inválido o expirado');
        _status = AuthStatus.unauthenticated;
        _currentUser = null;
      }
    } catch (e) {
      print('💥 Error verificando auth status: $e');
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
    }
    
    notifyListeners();
  }

  /// Método de conveniencia para verificar si el usuario es admin
  bool get isAdmin => _currentUser?.role == 'admin';
  
  /// Método de conveniencia para verificar si el usuario es cliente
  bool get isClient => _currentUser?.role == 'client';
}