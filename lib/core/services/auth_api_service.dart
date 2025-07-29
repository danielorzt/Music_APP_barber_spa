import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_client.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

/// Servicio para manejar autenticación con la API Laravel
class AuthApiService {
  final ApiClient _apiClient = ApiClient();
  
  /// Obtener headers para peticiones autenticadas
  Future<Map<String, String>> get _headers async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// Login de usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    print('🔐 Intentando login para: $email');
    final start = DateTime.now();
    
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Buscar token en diferentes estructuras de respuesta
        final token = _findToken(data);
        
        if (token != null) {
          // Guardar token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);

          // Buscar datos de usuario en la respuesta
          final userData = _findUserData(data);

          User user;
          if (userData != null) {
            // Crear usuario con datos de la respuesta
            user = User.fromJson(userData);
          } else {
            // Si no hay datos de usuario en la respuesta, extraer del token JWT
            print('⚠️ No se encontraron datos de usuario en la respuesta de login');
            print('🔍 Extrayendo datos del token JWT...');

            // Extraer datos del token JWT (email y nombre están en el token)
            try {
              final tokenParts = token.split('.');
              if (tokenParts.length == 3) {
                final payload = tokenParts[1];
                final decodedPayload = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
                final payloadData = jsonDecode(decodedPayload);
                
                user = User(
                  id: payloadData['sub']?.toString() ?? 'temp_id',
                  nombre: payloadData['nombre'] ?? 'Usuario',
                  email: payloadData['email'] ?? email,
                  role: payloadData['rol'] ?? 'CLIENTE',
                );
                
                print('✅ Datos extraídos del token JWT');
              } else {
                throw Exception('Token JWT inválido');
              }
            } catch (e) {
              print('⚠️ No se pudieron extraer datos del token JWT: $e');
              print('🔍 Creando usuario básico...');
              
              // Crear usuario básico como fallback
              user = User(
                id: 'temp_id',
                nombre: 'Usuario',
                email: email,
                role: 'CLIENTE',
              );
            }
          }

          print('✅ Login exitoso en ${DateTime.now().difference(start).inMilliseconds}ms');
          return {
            'success': true,
            'user': user.toJson(), // Convertir a Map<String, dynamic>
            'token': token,
          };
        } else {
          print('❌ Token no encontrado en respuesta');
          return {
            'success': false,
            'error': 'Credenciales incorrectas',
          };
        }
      } else {
        final errorMessage = response.data['message'] ?? 'Error de autenticación';
        
        print('❌ Login fallido: $errorMessage');
        return {
          'success': false,
          'error': errorMessage,
        };
      }
    } on DioException catch (e) {
      print('❌ Error en login: ${e.message}');
      print('❌ Error type: ${e.type}');
      print('❌ Error response: ${e.response?.data}');
      
      String errorMessage = 'Error de conexión';
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        errorMessage = errorData['message'] ?? 'Error de autenticación';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado en login: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Registro de usuario
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nombre,
    String? telefono,
  }) async {
    print('📝 Intentando registro para: $email');
    final start = DateTime.now();
    
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.registerEndpoint));
      final headers = await _headers;
      
      final response = await _apiClient.dio.post(
        ApiConfig.registerEndpoint,
        data: {
          'email': email,
          'password': password,
          'password_confirmation': password,
          'nombre': nombre,
          'telefono': telefono,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        
        // Buscar token en diferentes estructuras de respuesta
        final token = _findToken(data);
        final userData = _findUserData(data);
        
        if (token != null && userData != null) {
          // Guardar token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          
          // Crear usuario
          final user = User.fromJson(userData);
          
          print('✅ Registro exitoso en ${DateTime.now().difference(start).inMilliseconds}ms');
          return {
            'success': true,
            'user': user.toJson(), // Convertir a Map<String, dynamic>
            'token': token,
          };
        } else {
          print('❌ Token o datos de usuario no encontrados en respuesta');
          return {
            'success': false,
            'error': 'Error en el registro',
          };
        }
      } else {
        final errorMessage = response.data['message'] ?? 'Error en el registro';
        
        print('❌ Registro fallido: $errorMessage');
        return {
          'success': false,
          'error': errorMessage,
        };
      }
    } on DioException catch (e) {
      print('❌ Error en registro: ${e.message}');
      print('❌ Error type: ${e.type}');
      print('❌ Error response: ${e.response?.data}');
      
      String errorMessage = 'Error de conexión';
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        errorMessage = errorData['message'] ?? 'Error en el registro';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado en registro: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Logout de usuario
  Future<Map<String, dynamic>> logout() async {
    print('🚪 Intentando logout');
    
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.logoutEndpoint));
      final headers = await _headers;
      
      final response = await _apiClient.dio.post(
        ApiConfig.logoutEndpoint,
        options: Options(
          headers: headers,
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      
      // Limpiar token localmente sin importar la respuesta del servidor
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      
      print('✅ Logout exitoso');
      return {
        'success': true,
        'message': 'Sesión cerrada exitosamente',
      };
    } on DioException catch (e) {
      print('❌ Error en logout: ${e.message}');
      print('❌ Error type: ${e.type}');
      print('❌ Error response: ${e.response?.data}');
      
      String errorMessage = 'Error de conexión';
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        errorMessage = errorData['message'] ?? 'Error de autenticación';
      }
      
      // Limpiar token localmente incluso si hay error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      
      return {
        'success': true,
        'message': 'Sesión cerrada localmente',
      };
    } catch (e) {
      print('❌ Error inesperado en logout: $e');
      
      // Limpiar token localmente incluso si hay error
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      
      return {
        'success': true,
        'message': 'Sesión cerrada localmente',
      };
    }
  }

  /// Obtener usuario actual
  Future<Map<String, dynamic>> getCurrentUser() async {
    print('👤 Obteniendo usuario actual');
    
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.currentUserEndpoint));
      final headers = await _headers;
      
      final response = await _apiClient.dio.get(
        ApiConfig.currentUserEndpoint,
        options: Options(
          headers: headers,
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final userData = _findUserData(data);
        
        if (userData != null) {
          final user = User.fromJson(userData);
          print('✅ Usuario actual obtenido: ${user.nombre}');
          return {
            'success': true,
            'user': user.toJson(), // Convertir a Map<String, dynamic>
          };
        } else {
          print('❌ Datos de usuario no encontrados');
          return {
            'success': false,
            'error': 'Datos de usuario no válidos',
          };
        }
      } else {
        print('❌ Error obteniendo usuario: ${response.statusCode}');
        return {
          'success': false,
          'error': 'No autenticado',
        };
      }
    } on DioException catch (e) {
      print('❌ Error obteniendo usuario: ${e.message}');
      print('❌ Error type: ${e.type}');
      print('❌ Error response: ${e.response?.data}');
      
      String errorMessage = 'Error de conexión';
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        errorMessage = errorData['message'] ?? 'Error de autenticación';
      }
      
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado obteniendo usuario: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Verificar si hay una sesión activa
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (token == null) {
      return false;
    }
    
    // Verificar token con el servidor
    try {
      final result = await getCurrentUser();
      return result['success'] == true;
    } catch (e) {
      print('❌ Error verificando autenticación: $e');
      return false;
    }
  }

  /// Verificar si hay un token válido (método faltante)
  Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    
    if (token == null) {
      return false;
    }
    
    // Verificar token con el servidor
    try {
      final result = await getCurrentUser();
      return result['success'] == true;
    } catch (e) {
      print('❌ Error verificando token: $e');
      return false;
    }
  }

  /// Buscar token en diferentes estructuras de respuesta
  String? _findToken(Map<String, dynamic> data) {
    print('🔍 Buscando token en respuesta: $data');
    
    // Estructura Laravel: data.data.token
    if (data['data'] != null && data['data']['token'] != null) {
      print('✅ Token encontrado en data.data.token');
      return data['data']['token'];
    }
    
    // Estructura 1: data.token
    if (data['token'] != null) {
      print('✅ Token encontrado en data.token');
      return data['token'];
    }
    
    // Estructura 2: data.access_token
    if (data['access_token'] != null) {
      print('✅ Token encontrado en data.access_token');
      return data['access_token'];
    }
    
    // Estructura 3: data.data.access_token
    if (data['data'] != null && data['data']['access_token'] != null) {
      print('✅ Token encontrado en data.data.access_token');
      return data['data']['access_token'];
    }
    
    print('❌ Token no encontrado en ninguna estructura conocida');
    return null;
  }

  /// Buscar datos de usuario en diferentes estructuras de respuesta
  Map<String, dynamic>? _findUserData(Map<String, dynamic> data) {
    print('🔍 Buscando datos de usuario en respuesta: $data');
    
    // Estructura 1: data.user
    if (data['user'] != null) {
      print('✅ Datos de usuario encontrados en data.user');
      return data['user'];
    }
    
    // Estructura 2: data.data.user
    if (data['data'] != null && data['data']['user'] != null) {
      print('✅ Datos de usuario encontrados en data.data.user');
      return data['data']['user'];
    }
    
    // Estructura 3: data.data (si data es directamente el usuario)
    if (data['data'] != null && data['data'] is Map<String, dynamic>) {
      final userData = data['data'];
      // Verificar si tiene campos de usuario (excluyendo token)
      if (userData['id'] != null || userData['email'] != null) {
        // Filtrar campos que no son del usuario
        final filteredData = Map<String, dynamic>.from(userData);
        filteredData.remove('token');
        filteredData.remove('type');
        filteredData.remove('expires_in');
        
        if (filteredData.isNotEmpty) {
          print('✅ Datos de usuario encontrados en data.data (filtrados)');
          return filteredData;
        }
      }
    }
    
    // Estructura 4: data directamente (si es el usuario)
    if (data['id'] != null || data['email'] != null) {
      print('✅ Datos de usuario encontrados en data directamente');
      return data;
    }
    
    print('❌ Datos de usuario no encontrados en ninguna estructura conocida');
    return null;
  }
} 