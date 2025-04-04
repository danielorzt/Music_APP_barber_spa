// lib/features/auth/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:music_app/features/auth/repositories/auth_repository.dart';
import 'package:music_app/features/profile/models/user_model.dart';
import 'package:music_app/features/profile/repositories/user_repository.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthStatus _status = AuthStatus.unknown;
  User? _currentUser;
  String? _errorMessage;

  AuthProvider(this._authRepository, this._userRepository) {
    _checkAuthStatus();
  }

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _checkAuthStatus() async {
    try {
      final isAuth = await _authRepository.isAuthenticated();

      if (isAuth) {
        // Verificar token y obtener usuario
        final isValid = await _authRepository.checkToken();

        if (isValid) {
          _currentUser = await _userRepository.getCurrentUser();
          _status = AuthStatus.authenticated;
        } else {
          // Token inválido, logout
          await _authRepository.logout();
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      _errorMessage = null;
      final user = await _authRepository.login(email, password);

      // Guardar usuario en el repositorio
      await _userRepository.saveCurrentUser(user);

      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String? phone) async {
    try {
      _errorMessage = null;
      final user = await _authRepository.register(name, email, password, phone);

      // Guardar usuario en el repositorio
      await _userRepository.saveCurrentUser(user);

      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _authRepository.logout();
      await _userRepository.logout();

      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}