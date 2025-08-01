import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('🔍 DEBUG: Probando login con diferentes configuraciones');
  print('=' * 60);
  
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  
  // Test different base URLs
  final testUrls = [
    'https://bc3996b129b5.ngrok-free.app/api',
    'http://localhost:8000/api',
    'http://127.0.0.1:8000/api',
  ];
  
  final testCredentials = [
    {'email': 'estebanpinzon015@hotmail.com', 'password': 'Daniel123'},
    {'email': 'admin@bmspa.com', 'password': 'admin123'},
    {'email': 'cliente@bmspa.com', 'password': 'cliente123'},
  ];
  
  for (final baseUrl in testUrls) {
    print('\n🌐 Probando URL: $baseUrl');
    print('-' * 40);
    
    dio.options.baseUrl = baseUrl;
    
    // Test connectivity first
    try {
      print('📡 Probando conectividad...');
      final response = await dio.get('/');
      print('✅ Conectividad exitosa: ${response.statusCode}');
    } catch (e) {
      print('❌ Error de conectividad: $e');
      continue;
    }
    
    // Test login endpoints
    final loginEndpoints = [
      '/login',
      '/Client_usuarios/auth/login',
      '/auth/login',
    ];
    
    for (final endpoint in loginEndpoints) {
      print('\n🔐 Probando endpoint: $endpoint');
      
      for (final creds in testCredentials) {
        print('📧 Credenciales: ${creds['email']}');
        
        try {
          final loginResponse = await dio.post(endpoint, data: {
            'email': creds['email'],
            'password': creds['password'],
          });
          
          print('✅ Status: ${loginResponse.statusCode}');
          print('📄 Response: ${json.encode(loginResponse.data)}');
          
          if (loginResponse.statusCode == 200 || loginResponse.statusCode == 201) {
            print('🎉 ¡Login exitoso!');
            return;
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
    }
  }
  
  print('\n🏁 Pruebas completadas');
  print('=' * 60);
} 