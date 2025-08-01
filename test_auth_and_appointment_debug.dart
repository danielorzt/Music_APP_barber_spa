import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('🔍 DEBUG: Verificando autenticación y agendamiento');
  print('=' * 60);
  
  final dio = Dio();
  dio.options.baseUrl = 'https://bc3996b129b5.ngrok-free.app/api';
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  
  // Test credentials
  final testCredentials = [
    {'email': 'estebanpinzon015@hotmail.com', 'password': 'Daniel123'},
    {'email': 'admin@bmspa.com', 'password': 'admin123'},
    {'email': 'cliente@bmspa.com', 'password': 'cliente123'},
  ];
  
  String? authToken;
  Map<String, dynamic>? currentUser;
  
  // 1. TEST LOGIN AND AUTHENTICATION
  print('\n🔐 PRUEBA DE LOGIN Y AUTENTICACIÓN');
  print('-' * 40);
  
  for (final creds in testCredentials) {
    print('\n📧 Probando: ${creds['email']}');
    
    try {
      final loginResponse = await dio.post('/login', data: {
        'email': creds['email'],
        'password': creds['password'],
      });
      
      print('✅ Status: ${loginResponse.statusCode}');
      print('📄 Response: ${json.encode(loginResponse.data)}');
      
      if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {
        final data = loginResponse.data;
        
        // Extract token
        String? token;
        if (data['token'] != null) {
          token = data['token'];
        } else if (data['access_token'] != null) {
          token = data['access_token'];
        } else if (data['data'] != null && data['data']['token'] != null) {
          token = data['data']['token'];
        }
        
        if (token != null) {
          authToken = token;
          print('✅ Token obtenido: ${token.substring(0, 20)}...');
          
          // Extract user data
          if (data['user'] != null) {
            currentUser = data['user'];
          } else if (data['data'] != null && data['data']['user'] != null) {
            currentUser = data['data']['user'];
          } else if (data['data'] != null && data['data']['id'] != null) {
            currentUser = data['data'];
          }
          
          if (currentUser != null) {
            print('✅ Datos de usuario obtenidos: ${currentUser['nombre']} (ID: ${currentUser['id']})');
          }
          
          break;
        } else {
          print('⚠️ No se encontró token en la respuesta');
        }
      }
    } catch (e) {
      if (e is DioException) {
        print('❌ Error de Dio: ${e.type}');
        print('📄 Status: ${e.response?.statusCode}');
        print('📄 Data: ${e.response?.data}');
      } else {
        print('❌ Error: $e');
      }
    }
  }
  
  if (authToken == null) {
    print('\n❌ No se pudo obtener token de autenticación');
    print('🔍 Continuando con pruebas sin autenticación...');
  } else {
    print('\n✅ Token obtenido exitosamente');
    
    // 2. TEST CURRENT USER ENDPOINT
    print('\n👤 PRUEBA DE ENDPOINT DE USUARIO ACTUAL');
    print('-' * 40);
    
    try {
      final userResponse = await dio.get('/user', options: Options(
        headers: {'Authorization': 'Bearer $authToken'},
      ));
      
      print('✅ Status: ${userResponse.statusCode}');
      print('📄 User data: ${json.encode(userResponse.data)}');
      
      // Update current user data if available
      if (userResponse.data['data'] != null) {
        currentUser = userResponse.data['data'];
        print('✅ Datos de usuario actualizados: ${currentUser?['nombre']} (ID: ${currentUser?['id']})');
      }
    } catch (e) {
      if (e is DioException) {
        print('❌ Error obteniendo usuario: ${e.response?.statusCode}');
        print('📄 Data: ${e.response?.data}');
        
        if (e.response?.statusCode == 401) {
          print('🔍 Token inválido o expirado');
        }
      } else {
        print('❌ Error: $e');
      }
    }
    
    // 3. TEST APPOINTMENT CREATION
    print('\n📅 PRUEBA DE CREACIÓN DE AGENDAMIENTO');
    print('-' * 40);
    
    if (currentUser != null) {
      try {
        final appointmentData = {
          'fecha_hora': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
          'cliente_usuario_id': currentUser['id'],
          'servicio_id': 1,
          'sucursal_id': 1,
          'estado': 'PROGRAMADA',
          'notas': 'Prueba desde script de debug',
        };
        
        print('📤 Enviando datos: ${json.encode(appointmentData)}');
        
        final appointmentResponse = await dio.post('/agendamientos', 
          data: appointmentData,
          options: Options(
            headers: {'Authorization': 'Bearer $authToken'},
          ),
        );
        
        print('✅ Status: ${appointmentResponse.statusCode}');
        print('📄 Response: ${json.encode(appointmentResponse.data)}');
      } catch (e) {
        if (e is DioException) {
          print('❌ Error creando agendamiento: ${e.response?.statusCode}');
          print('📄 Data: ${e.response?.data}');
          
          if (e.response?.statusCode == 422) {
            print('🔍 Errores de validación:');
            final errors = e.response!.data['errors'];
            if (errors != null) {
              errors.forEach((field, messages) {
                print('  - $field: ${messages.join(', ')}');
              });
            }
          } else if (e.response?.statusCode == 401) {
            print('🔍 Usuario no autenticado para crear agendamiento');
          }
        } else {
          print('❌ Error: $e');
        }
      }
    } else {
      print('❌ No hay datos de usuario disponibles para crear agendamiento');
    }
  }
  
  // 4. TEST PUBLIC ENDPOINTS
  print('\n🌐 PRUEBA DE ENDPOINTS PÚBLICOS');
  print('-' * 30);
  
  final publicEndpoints = [
    '/productos',
    '/servicios', 
    '/sucursales',
    '/categorias',
  ];
  
  for (final endpoint in publicEndpoints) {
    try {
      print('\n📡 Probando: $endpoint');
      final response = await dio.get(endpoint);
      print('✅ Status: ${response.statusCode}');
      print('📄 Items: ${response.data['data']?.length ?? 0}');
    } catch (e) {
      if (e is DioException) {
        print('❌ Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('❌ Error: $e');
      }
    }
  }
  
  // 5. TEST TOKEN VALIDATION
  print('\n🔍 PRUEBA DE VALIDACIÓN DE TOKEN');
  print('-' * 35);
  
  if (authToken != null) {
    print('🔍 Token actual: ${authToken.substring(0, 20)}...');
    
    // Test with different endpoints that require authentication
    final authEndpoints = [
      '/user',
      '/agendamientos',
      '/profile',
    ];
    
    for (final endpoint in authEndpoints) {
      try {
        print('\n📡 Probando endpoint autenticado: $endpoint');
        final response = await dio.get(endpoint, options: Options(
          headers: {'Authorization': 'Bearer $authToken'},
        ));
        print('✅ Status: ${response.statusCode}');
        print('📄 Data available: ${response.data != null}');
      } catch (e) {
        if (e is DioException) {
          print('❌ Error: ${e.response?.statusCode} - ${e.response?.data}');
          
          if (e.response?.statusCode == 401) {
            print('🔍 Token no válido para este endpoint');
          }
        } else {
          print('❌ Error: $e');
        }
      }
    }
  }
  
  print('\n🏁 PRUEBAS COMPLETADAS');
  print('=' * 60);
} 