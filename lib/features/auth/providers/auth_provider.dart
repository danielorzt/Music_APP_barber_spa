// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/services/auth_api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApiService _authService = AuthApiService();
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  String? _error;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get error => _error;

  AuthProvider() {
    _checkAuthStatus();
  }

  /// Verificar estado de autenticación al iniciar
  Future<void> _checkAuthStatus() async {
    try {
      print('🔍 AuthProvider: Verificando estado de autenticación...');
      
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        _error = null;
        print('✅ Usuario autenticado: ${user['nombre']}');
      } else {
        _isAuthenticated = false;
        _currentUser = null;
        print('🔍 No hay usuario autenticado');
      }
    } catch (e) {
      print('❌ Error verificando autenticación: $e');
      _isAuthenticated = false;
      _currentUser = null;
    }
    notifyListeners();
  }

  /// Login con JWT
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _error = null;

    try {
      print('🔐 AuthProvider: Intentando login con JWT...');
      
      final result = await _authService.login(email, password);
      
      if (result['success'] == true) {
        _isAuthenticated = true;
        _currentUser = result['user'];
        _error = null;
        print('✅ Login exitoso: ${result['user']?['nombre']}');
        notifyListeners();
        return true;
      } else {
        _error = result['error'] ?? 'Error de autenticación';
        _isAuthenticated = false;
        _currentUser = null;
        print('❌ Login fallido: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error inesperado: $e';
      _isAuthenticated = false;
      _currentUser = null;
      print('❌ Error en login: $_error');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Registro de usuario
  Future<bool> register({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      print('📝 AuthProvider: Intentando registro...');
      
      final result = await _authService.register(
        nombre: nombre,
        email: email,
        password: password,
        telefono: telefono,
      );
      
      if (result['success'] == true) {
        // Si el registro es exitoso, el usuario queda autenticado automáticamente
        _isAuthenticated = true;
        _currentUser = result['user'];
        _error = null;
        print('✅ Registro exitoso: ${result['user']?['nombre']}');
        print('🔐 Usuario autenticado automáticamente después del registro');
        notifyListeners();
        return true;
      } else {
        _error = result['error'] ?? 'Error en el registro';
        _isAuthenticated = false;
        _currentUser = null;
        print('❌ Registro fallido: $_error');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error inesperado: $e';
      _isAuthenticated = false;
      _currentUser = null;
      print('❌ Error en registro: $_error');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      print('🚪 AuthProvider: Cerrando sesión...');
      
      await _authService.logout();
      
      _isAuthenticated = false;
      _currentUser = null;
      _error = null;
      
      print('✅ Logout exitoso');
    } catch (e) {
      print('❌ Error en logout: $e');
      // Aún así, limpiar el estado local
      _isAuthenticated = false;
      _currentUser = null;
      _error = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Establecer estado de carga
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Verificar si el usuario tiene un rol específico
  bool hasRole(String role) {
    if (_currentUser == null) return false;
    final userRole = _currentUser!['rol']?.toString().toUpperCase();
    return userRole == role.toUpperCase();
  }

  /// Verificar si el usuario es cliente
  bool get isClient => hasRole('CLIENTE');

  /// Verificar si el usuario es empleado
  bool get isEmployee => hasRole('EMPLEADO');

  /// Verificar si el usuario es admin
  bool get isAdmin => hasRole('ADMIN_GENERAL') || hasRole('ADMIN_SUCURSAL');
}