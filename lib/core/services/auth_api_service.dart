import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../config/dev_config.dart';

class AuthApiService {
  final Dio _dio = Dio();

  AuthApiService() {
    _dio.options.baseUrl = DevConfig.apiBaseUrl;
    _dio.options.connectTimeout = DevConfig.defaultTimeout;
    _dio.options.receiveTimeout = DevConfig.defaultTimeout;
  }

  /// Login con JWT
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔐 Intentando login con JWT...');
      print('📍 URL: ${DevConfig.getEndpoint('login')}');
      print('📧 Email: $email');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('login')!,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            return status! <= 500; // Aceptar códigos 2xx, 3xx, 4xx, 5xx
          },
        ),
      );

      print('✅ Respuesta del servidor: ${response.statusCode}');
      print('📄 Datos: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        // Extraer token y datos de usuario según la estructura de tu API
        final token = _findToken(data);
        final userData = _findUserData(data);
        
        if (token != null) {
          await _saveToken('jwt_token', token);
          print('💾 Token guardado: ${token.substring(0, 20)}...');
          
          if (userData != null) {
            await _saveUser(userData);
            print('💾 Datos de usuario guardados');
          }
        } else {
          print('⚠️ No se encontró token en la respuesta');
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Login exitoso',
          'user': userData,
          'token': token,
        };
      } else {
        // Manejar otros códigos de estado
        String errorMessage = 'Error en el servidor';
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        
        // Manejar errores específicos según el código de estado
        switch (response.statusCode) {
          case 500:
            errorMessage = 'Error interno del servidor. El servidor está experimentando problemas técnicos.';
            break;
          case 401:
            errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
            break;
          case 422:
            errorMessage = 'Datos inválidos. Verifica que todos los campos sean correctos.';
            break;
          default:
            if (errorMessage.isEmpty) {
              errorMessage = 'Error inesperado en el servidor';
            }
        }
        
        return {
          'success': false,
          'error': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      print('🔢 Código de estado: ${e.response?.statusCode}');
      
      String errorMessage = 'Error de conexión';
      
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final serverMessage = errorData['message'] ?? '';
        final statusCode = e.response!.statusCode;
        
        print('📋 Mensaje del servidor: $serverMessage');
        print('🔢 Código de estado: $statusCode');
        
        // Manejar errores específicos según los códigos de tu API
        switch (statusCode) {
          case 401:
            errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
            break;
          case 403:
            errorMessage = 'Cuenta desactivada. Contacta al administrador.';
            break;
          case 409:
            errorMessage = 'Conflicto en el servidor. Intenta nuevamente.';
            break;
          case 422:
            errorMessage = 'Datos inválidos. Verifica que todos los campos sean correctos.';
            break;
          case 500:
            errorMessage = 'Error interno del servidor. Intenta nuevamente en unos minutos.';
            break;
          default:
            if (serverMessage.contains('credentials') || serverMessage.contains('Unauthorized')) {
              errorMessage = 'Credenciales incorrectas. Verifica tu email y contraseña.';
            } else if (serverMessage.contains('validation')) {
              errorMessage = 'Datos inválidos. Verifica que todos los campos sean correctos.';
            } else if (serverMessage.contains('Error al iniciar sesión')) {
              errorMessage = 'Error en el servidor. Intenta nuevamente en unos minutos.';
            } else {
              errorMessage = serverMessage.isNotEmpty ? serverMessage : 'Error de autenticación';
            }
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Tiempo de espera agotado. Verifica tu conexión a internet.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'El servidor tardó demasiado en responder. Intenta nuevamente.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
      }

      return {
        'success': false,
        'error': errorMessage,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      print('❌ Error inesperado: $e');
      return {
        'success': false,
        'error': 'Error inesperado. Intenta nuevamente.',
      };
    }
  }

  /// Registro de usuario
  Future<Map<String, dynamic>> register({
    required String nombre,
    required String email,
    required String password,
    String? telefono,
  }) async {
    try {
      print('📝 Intentando registro...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('register')!,
        data: {
          'nombre': nombre,
          'email': email,
          'password': password,
          'password_confirmation': password,
          if (telefono != null) 'telefono': telefono,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ Registro exitoso: ${response.statusCode}');
      print('📄 Respuesta: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        // Extraer token y datos de usuario
        final token = _findToken(data);
        final userData = _findUserData(data);
        
        if (token != null) {
          await _saveToken('jwt_token', token);
          if (userData != null) {
            await _saveUser(userData);
          }
        }

        return {
          'success': true,
          'message': data['message'] ?? 'Registro exitoso',
          'user': userData,
        };
      } else {
        return {
          'success': false,
          'error': 'Error inesperado en el servidor',
        };
      }
    } on DioException catch (e) {
      print('❌ Error de Dio: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      
      String errorMessage = 'Error de conexión';
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final serverMessage = errorData['message'] ?? '';
        
        // Manejar errores específicos del servidor
        if (serverMessage.contains('email already registered')) {
          errorMessage = 'El email ya está registrado. Intenta con otro email.';
        } else if (serverMessage.contains('validation')) {
          errorMessage = 'Datos inválidos. Verifica que todos los campos sean correctos.';
        } else if (serverMessage.contains('password')) {
          errorMessage = 'La contraseña debe tener al menos 6 caracteres.';
        } else {
          errorMessage = serverMessage.isNotEmpty ? serverMessage : 'Error de registro';
        }
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Tiempo de espera agotado. Verifica tu conexión a internet.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'El servidor tardó demasiado en responder. Intenta nuevamente.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
      }

      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado: $e');
      return {
        'success': false,
        'error': 'Error inesperado. Intenta nuevamente.',
      };
    }
  }

  /// Obtener usuario actual
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final token = await _getToken('jwt_token');
      if (token == null) {
        return null;
      }

      final response = await _dio.get(
        DevConfig.getEndpoint('currentUser')!,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
    }
    return null;
  }

  /// Logout
  Future<void> logout() async {
    try {
      final token = await _getToken('jwt_token');
      if (token != null) {
        await _dio.post(
          DevConfig.getEndpoint('logout')!,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
      }
    } catch (e) {
      print('❌ Error en logout: $e');
    } finally {
      await _clearTokens();
    }
  }

  /// Métodos privados para manejo de tokens
  Future<void> _saveToken(String key, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, token);
  }

  Future<String?> _getToken(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(user));
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_data');
  }

  /// Buscar token en la respuesta del servidor
  String? _findToken(Map<String, dynamic> data) {
    print('🔍 Buscando token en respuesta: ${data.keys.toList()}');
    
    // Buscar en diferentes ubicaciones posibles según la estructura de tu API
    if (data['token'] != null) {
      print('✅ Token encontrado en data.token');
      return data['token'];
    }
    
    if (data['data'] != null && data['data'] is Map<String, dynamic>) {
      final dataObj = data['data'] as Map<String, dynamic>;
      if (dataObj['token'] != null) {
        print('✅ Token encontrado en data.data.token');
        return dataObj['token'];
      }
    }
    
    if (data['access_token'] != null) {
      print('✅ Token encontrado en data.access_token');
      return data['access_token'];
    }
    
    // Buscar en otras ubicaciones posibles
    if (data['data'] != null && data['data'] is Map<String, dynamic>) {
      final dataObj = data['data'] as Map<String, dynamic>;
      if (dataObj['access_token'] != null) {
        print('✅ Token encontrado en data.data.access_token');
        return dataObj['access_token'];
      }
    }
    
    print('❌ No se encontró token en la respuesta');
    return null;
  }

  /// Buscar datos de usuario en la respuesta del servidor
  Map<String, dynamic>? _findUserData(Map<String, dynamic> data) {
    print('🔍 Buscando datos de usuario en respuesta');
    
    // Buscar en diferentes ubicaciones posibles según la estructura de tu API
    if (data['user'] != null && data['user'] is Map<String, dynamic>) {
      print('✅ Datos de usuario encontrados en data.user');
      return data['user'] as Map<String, dynamic>;
    }
    
    if (data['data'] != null && data['data'] is Map<String, dynamic>) {
      final dataObj = data['data'] as Map<String, dynamic>;
      if (dataObj['user'] != null && dataObj['user'] is Map<String, dynamic>) {
        print('✅ Datos de usuario encontrados en data.data.user');
        return dataObj['user'] as Map<String, dynamic>;
      }
      
      // Si no hay objeto user separado, usar los datos principales del data
      if (dataObj['id'] != null || dataObj['email'] != null) {
        print('✅ Datos de usuario encontrados en data.data (datos principales)');
        return dataObj;
      }
    }
    
    // Si no hay objeto user separado, usar los datos principales
    if (data['id'] != null || data['email'] != null) {
      print('✅ Datos de usuario encontrados en data (datos principales)');
      return data;
    }
    
    print('❌ No se encontraron datos de usuario en la respuesta');
    return null;
  }
} 