import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('🔍 Iniciando tests de conectividad API...\n');

  // URLs a probar
  final urls = [
    'http://10.0.2.2:8000/api', // Emulador Android
    'http://localhost:8000/api', // Localhost
    'http://192.168.1.100:8000/api', // Red local
    'https://api.barbermusicaspa.com/api', // Producción
  ];

  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  for (final baseUrl in urls) {
    print('🌐 Probando: $baseUrl');
    
    try {
      // Test 1: Conectividad básica
      final healthResponse = await dio.get('$baseUrl/health');
      print('✅ Health check: ${healthResponse.statusCode}');
    } catch (e) {
      print('❌ Health check falló: $e');
    }

    try {
      // Test 2: Endpoint de servicios
      final servicesResponse = await dio.get('$baseUrl/services');
      print('✅ Services endpoint: ${servicesResponse.statusCode}');
    } catch (e) {
      print('❌ Services endpoint falló: $e');
    }

    try {
      // Test 3: Endpoint de productos
      final productsResponse = await dio.get('$baseUrl/products');
      print('✅ Products endpoint: ${productsResponse.statusCode}');
    } catch (e) {
      print('❌ Products endpoint falló: $e');
    }

    try {
      // Test 4: Login endpoint (sin credenciales)
      final loginResponse = await dio.post('$baseUrl/auth/login', data: {
        'email': 'test@example.com',
        'password': 'password',
      });
      print('✅ Login endpoint: ${loginResponse.statusCode}');
      if (loginResponse.statusCode == 200) {
        print('📄 Respuesta: ${loginResponse.data}');
      }
    } catch (e) {
      if (e is DioException) {
        print('❌ Login endpoint falló: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('❌ Login endpoint falló: $e');
      }
    }

    print('---\n');
  }

  print('🎯 Tests completados');
} 