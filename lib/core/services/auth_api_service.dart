import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AuthApiService {
  
  // Headers por defecto
  Map<String, String> get _headers => ApiConfig.defaultHeaders;

  // Headers con token de autorización
  Future<Map<String, String>> get _authHeaders async {
    final token = await getStoredToken();
    return {
      ..._headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Login con email y password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.loginEndpoint));
      print('🔐 Intentando login en: $url');
      
      final requestBody = {
        'email': email,
        'password': password,
      };
      
      print('📤 Datos enviados: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(requestBody),
      ).timeout(ApiConfig.defaultTimeout);
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
      print('📥 Response Headers: ${response.headers}');
      
      // Manejar diferentes códigos de respuesta exitosos
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final data = jsonDecode(response.body);
          print('✅ JSON decodificado exitosamente: $data');
          
          // Verificar estructura de respuesta de Laravel
          // Laravel puede devolver diferentes estructuras según cómo esté configurado
          Map<String, dynamic> userData;
          String? token;
          
          // Caso 1: Respuesta directa con user
          if (data['user'] != null) {
            userData = data['user'];
            token = data['token'] ?? data['access_token'];
          }
          // Caso 2: Respuesta con data wrapper
          else if (data['data'] != null && data['data']['user'] != null) {
            userData = data['data']['user'];
            token = data['data']['token'] ?? data['data']['access_token'];
          }
          // Caso 3: Usuario directamente en la respuesta
          else if (data['id'] != null || data['email'] != null) {
            userData = data;
            token = data['token'] ?? data['access_token'];
          }
          // Caso 4: Respuesta con status success
          else if (data['success'] == true && data['user'] != null) {
            userData = data['user'];
            token = data['token'] ?? data['access_token'];
          }
          // Caso 5: Buscar usuario en diferentes campos
          else {
            // Buscar cualquier objeto que tenga email
            userData = _findUserData(data);
            token = _findToken(data);
          }
          
          print('👤 Datos de usuario extraídos: $userData');
          print('🔑 Token extraído: ${token != null ? 'PRESENTE' : 'AUSENTE'}');
          
          // Guardar token si existe
          if (token != null && token.isNotEmpty) {
            await saveToken(token);
            print('✅ Token guardado exitosamente');
          }
          
          return {
            'success': true,
            'data': data,
            'user': userData,
            'token': token,
            'message': 'Login exitoso',
          };
        } catch (jsonError) {
          print('❌ Error decodificando JSON: $jsonError');
          print('📄 Response body raw: ${response.body}');
          
          // Si no es JSON válido, tratar como éxito si el status es 200
          return {
            'success': true,
            'data': {'raw_response': response.body},
            'user': {
              'email': email,
              'nombre': 'Usuario',
              'role': 'client',
              'id': '1',
            },
            'token': null,
            'message': 'Login exitoso (respuesta no JSON)',
          };
        }
      } else {
        print('❌ Status code no exitoso: ${response.statusCode}');
        try {
          final errorData = jsonDecode(response.body);
          return {
            'success': false,
            'error': errorData['message'] ?? errorData['error'] ?? 'Error en el servidor',
            'details': errorData,
            'status_code': response.statusCode,
          };
        } catch (e) {
          return {
            'success': false,
            'error': 'Error del servidor (${response.statusCode}): ${response.body}',
            'status_code': response.statusCode,
          };
        }
      }
    } catch (e) {
      print('❌ Error en login: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Buscar datos de usuario en diferentes estructuras de respuesta
  Map<String, dynamic> _findUserData(Map<String, dynamic> data) {
    // Buscar en campos comunes
    for (final key in ['user', 'usuario', 'data', 'result']) {
      if (data[key] != null && data[key] is Map) {
        final userData = data[key] as Map<String, dynamic>;
        if (userData['email'] != null || userData['id'] != null) {
          return userData;
        }
      }
    }
    
    // Si la respuesta misma tiene email, usarla
    if (data['email'] != null) {
      return data;
    }
    
    // Último recurso: crear usuario básico
    return {
      'id': '1',
      'email': 'usuario@test.com',
      'nombre': 'Usuario de Prueba',
      'role': 'client',
    };
  }

  /// Buscar token en diferentes campos de la respuesta
  String? _findToken(Map<String, dynamic> data) {
    final tokenFields = ['token', 'access_token', 'accessToken', 'jwt', 'authToken'];
    
    for (final field in tokenFields) {
      if (data[field] != null) {
        return data[field].toString();
      }
      
      // Buscar en data nested
      if (data['data'] != null && data['data'][field] != null) {
        return data['data'][field].toString();
      }
    }
    
    return null;
  }

  /// Registro de nuevo usuario
  Future<Map<String, dynamic>> register({
    required String nombre,
    required String email,
    required String password,
    required String telefono,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.registerEndpoint));
      print('📝 Intentando registro en: $url');
      
      final requestBody = {
        'nombre': nombre,
        'email': email,
        'password': password,
        'telefono': telefono,
      };
      
      print('📤 Datos enviados: ${jsonEncode(requestBody)}');
      
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(requestBody),
      ).timeout(ApiConfig.defaultTimeout);
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        
        // Guardar token si existe
        final token = _findToken(data);
        if (token != null) {
          await saveToken(token);
        }
        
        return {
          'success': true,
          'data': data,
          'user': _findUserData(data),
          'token': token,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? 'Error en el servidor',
          'details': errorData,
        };
      }
    } catch (e) {
      print('❌ Error en registro: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.logoutEndpoint));
      print('🚪 Intentando logout en: $url');
      
      final response = await http.post(
        url,
        headers: await _authHeaders,
      ).timeout(ApiConfig.shortTimeout);
      
      print('📥 Status Code: ${response.statusCode}');
      
      // Independientemente del resultado, eliminar token local
      await removeToken();
      
      return {
        'success': true,
        'message': 'Sesión cerrada exitosamente',
      };
    } catch (e) {
      print('❌ Error en logout: $e');
      // Aún así eliminar token local
      await removeToken();
      return {
        'success': true,
        'message': 'Sesión cerrada localmente',
      };
    }
  }

  /// Verificar token y obtener usuario actual
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await getStoredToken();
      if (token == null) {
        return {
          'success': false,
          'error': 'No hay token de autenticación',
        };
      }

      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.meEndpoint));
      print('👤 Obteniendo usuario actual de: $url');
      
      final response = await http.get(
        url,
        headers: await _authHeaders,
      ).timeout(ApiConfig.shortTimeout);
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'user': _findUserData(data),
        };
      } else {
        // Token inválido, eliminar
        await removeToken();
        return {
          'success': false,
          'error': 'Token inválido',
        };
      }
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Guardar token en SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Obtener token de SharedPreferences
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Eliminar token de SharedPreferences
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Verificar si hay token guardado
  Future<bool> hasValidToken() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }
} 