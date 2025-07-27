// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:music_app/features/profile/models/user_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider with ChangeNotifier {
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
      // Simulación de llamada a API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular validación básica
      if (email.isEmpty || password.isEmpty) {
        _error = 'Email y contraseña son requeridos';
        _status = AuthStatus.error;
        return false;
      }
      
      // Simular diferentes tipos de usuario
      if (email == 'admin@barbershop.com') {
        _currentUser = User(
          id: '1',
          nombre: 'Administrador',
          email: email,
          telefono: '+1234567890',
          role: 'admin',
        );
      } else {
        _currentUser = User(
          id: '2',
          nombre: 'Cliente Demo',
          email: email,
          telefono: '+1234567890',
          role: 'client',
        );
      }
      
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = 'Error al iniciar sesión: $e';
      _status = AuthStatus.error;
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
      // Simulación de llamada a API
      await Future.delayed(const Duration(seconds: 2));
      
      // Simular validación básica
      if (email.isEmpty || password.isEmpty || nombre.isEmpty) {
        _error = 'Todos los campos son requeridos';
        _status = AuthStatus.error;
        return false;
      }
      
      // Simular verificación de email existente
      if (email == 'test@existe.com') {
        _error = 'Este email ya está registrado';
        _status = AuthStatus.error;
        return false;
      }
      
      // Crear nuevo usuario
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: nombre,
        email: email,
        telefono: telefono,
        role: 'client',
      );
      
      _status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _error = 'Error al registrar usuario: $e';
      _status = AuthStatus.error;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      // Simulación de llamada a API
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _error = null;
    } catch (e) {
      _error = 'Error al cerrar sesión: $e';
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
      // Simulación de llamada a API
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

  // Método para verificar si hay sesión guardada (simulado)
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();
    
    try {
      // Simular verificación de token guardado
      await Future.delayed(const Duration(seconds: 1));
      
      // Por ahora, simular que no hay sesión activa
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _status = AuthStatus.error;
      _error = 'Error al verificar sesión';
    }
    
    notifyListeners();
  }
}