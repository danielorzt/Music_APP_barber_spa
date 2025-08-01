import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('🔍 INICIANDO PRUEBAS DE DEBUG PARA LOGIN Y AGENDAMIENTO');
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
  
  // 1. TEST LOGIN
  print('\n🔐 PRUEBA DE LOGIN');
  print('-' * 30);
  
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
    
    // 2. TEST GET CURRENT USER
    print('\n👤 PRUEBA DE OBTENER USUARIO ACTUAL');
    print('-' * 40);
    
    try {
      final userResponse = await dio.get('/user', options: Options(
        headers: {'Authorization': 'Bearer $authToken'},
      ));
      
      print('✅ Status: ${userResponse.statusCode}');
      print('📄 User data: ${json.encode(userResponse.data)}');
    } catch (e) {
      if (e is DioException) {
        print('❌ Error obteniendo usuario: ${e.response?.statusCode}');
        print('📄 Data: ${e.response?.data}');
      } else {
        print('❌ Error: $e');
      }
    }
    
    // 3. TEST APPOINTMENT CREATION
    print('\n📅 PRUEBA DE CREACIÓN DE AGENDAMIENTO');
    print('-' * 40);
    
    try {
      final appointmentData = {
        'fecha_hora': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        'cliente_usuario_id': 1, // Assuming user ID 1
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
        }
      } else {
        print('❌ Error: $e');
      }
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
  
  print('\n🏁 PRUEBAS COMPLETADAS');
  print('=' * 60);
} 