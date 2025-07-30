import 'dart:convert';
import 'package:dio/dio.dart';

/// Prueba de conectividad y login JWT con la API de BMSPA
class JWTLoginTest {
  static const String baseUrl = 'https://c21dae5133a1.ngrok-free.app/api';
  static const String loginEndpoint = '/Client_usuarios/auth/login';
  static const String registerEndpoint = '/Client_usuarios/auth/register';
  
  static final Dio _dio = Dio();
  
  static void main() async {
    print('🧪 INICIANDO PRUEBAS DE LOGIN JWT - BMSPA API');
    print('📍 URL Base: $baseUrl');
    print('🔐 Endpoint Login: $loginEndpoint');
    print('📝 Endpoint Register: $registerEndpoint');
    print('=' * 60);
    
    // Configurar Dio
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Prueba 1: Verificar conectividad
    await testConnectivity();
    
    // Prueba 2: Registro de usuario (primero)
    await testRegister();
    
    // Prueba 3: Login con credenciales válidas
    await testValidLogin();
    
    // Prueba 4: Login con credenciales inválidas
    await testInvalidLogin();
    
    print('=' * 60);
    print('✅ PRUEBAS COMPLETADAS');
  }
  
  /// Prueba de conectividad básica
  static Future<void> testConnectivity() async {
    print('\n🔍 PRUEBA 1: VERIFICAR CONECTIVIDAD');
    try {
      final response = await _dio.get('/health');
      print('✅ Conectividad OK: ${response.statusCode}');
      print('📄 Respuesta: ${response.data}');
    } catch (e) {
      print('❌ Error de conectividad: $e');
      print('⚠️ Verifica que el servidor esté corriendo en $baseUrl');
    }
  }
  
  /// Prueba de registro de usuario
  static Future<void> testRegister() async {
    print('\n📝 PRUEBA 2: REGISTRO DE USUARIO');
    
    final testUser = {
      'nombre': 'Usuario Test',
      'email': 'test.${DateTime.now().millisecondsSinceEpoch}@example.com',
      'password': 'password123',
      'password_confirmation': 'password123',
      'telefono': '3101234567'
    };
    
    print('📧 Datos de registro: ${testUser['email']}');
    
    try {
      final response = await _dio.post(
        registerEndpoint,
        data: testUser,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
      
      print('📊 Status Code: ${response.statusCode}');
      print('📄 Respuesta: ${jsonEncode(response.data)}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ REGISTRO EXITOSO');
        // Guardar las credenciales para la prueba de login
        _testCredentials = {
          'email': testUser['email']!,
          'password': testUser['password']!,
          'name': testUser['nombre']!
        };
      } else {
        print('❌ REGISTRO FALLIDO');
        print('📋 Error: ${response.data['message'] ?? 'Error desconocido'}');
      }
    } catch (e) {
      print('❌ Error en registro: $e');
    }
  }
  
  /// Prueba de login con credenciales válidas
  static Future<void> testValidLogin() async {
    print('\n🔐 PRUEBA 3: LOGIN CON CREDENCIALES VÁLIDAS');
    
    // Usar las credenciales del registro exitoso
    if (_testCredentials != null) {
      print('\n📧 Probando con: ${_testCredentials!['email']}');
      
      try {
        final response = await _dio.post(
          loginEndpoint,
          data: {
            'email': _testCredentials!['email'],
            'password': _testCredentials!['password'],
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            validateStatus: (status) => status! < 500,
          ),
        );
        
        print('📊 Status Code: ${response.statusCode}');
        print('📄 Respuesta: ${jsonEncode(response.data)}');
        
        if (response.statusCode == 200) {
          final data = response.data;
          final token = _findToken(data);
          
          if (token != null) {
            print('✅ LOGIN EXITOSO');
            print('🔑 Token: ${token.substring(0, 20)}...');
            print('👤 Usuario: ${_testCredentials!['name']}');
          } else {
            print('⚠️ Login exitoso pero no se encontró token');
          }
        } else {
          print('❌ LOGIN FALLIDO');
          print('📋 Error: ${response.data['message'] ?? 'Error desconocido'}');
        }
      } catch (e) {
        print('❌ Error en login: $e');
      }
    } else {
      print('⚠️ No hay credenciales de prueba disponibles');
    }
  }
  
  /// Prueba de login con credenciales inválidas
  static Future<void> testInvalidLogin() async {
    print('\n❌ PRUEBA 4: LOGIN CON CREDENCIALES INVÁLIDAS');
    
    const invalidCredentials = [
      {
        'email': 'usuario.inexistente@test.com',
        'password': 'password123',
        'description': 'Usuario inexistente'
      },
      {
        'email': 'test@example.com',
        'password': 'password_incorrecto',
        'description': 'Contraseña incorrecta'
      },
      {
        'email': 'email_invalido',
        'password': 'password',
        'description': 'Email inválido'
      }
    ];
    
    for (final credentials in invalidCredentials) {
      print('\n📧 Probando: ${credentials['description']}');
      
      try {
        final response = await _dio.post(
          loginEndpoint,
          data: {
            'email': credentials['email'],
            'password': credentials['password'],
          },
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            validateStatus: (status) => status! < 500,
          ),
        );
        
        print('📊 Status Code: ${response.statusCode}');
        print('📄 Respuesta: ${jsonEncode(response.data)}');
        
        if (response.statusCode == 401 || response.statusCode == 422) {
          print('✅ ERROR MANEJADO CORRECTAMENTE');
        } else {
          print('⚠️ Respuesta inesperada');
        }
      } catch (e) {
        print('❌ Error en login: $e');
      }
    }
  }
  
  /// Buscar token en la respuesta del servidor
  static String? _findToken(Map<String, dynamic> data) {
    if (data['token'] != null) return data['token'];
    if (data['data'] != null && data['data']['token'] != null) {
      return data['data']['token'];
    }
    if (data['access_token'] != null) return data['access_token'];
    if (data['data'] != null && data['data']['access_token'] != null) {
      return data['data']['access_token'];
    }
    return null;
  }
  
  // Variable para almacenar las credenciales de prueba
  static Map<String, String>? _testCredentials;
}

// Ejecutar las pruebas
void main() {
  JWTLoginTest.main();
} 