// test_api_connectivity_updated.dart
// Script para probar conectividad con diferentes URLs de la API

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 PROBANDO CONECTIVIDAD CON API LARAVEL');
  print('==========================================\n');
  
  // Lista de URLs a probar
  final urlsToTest = [
    'https://8985f960eef9.ngrok-free.app/api',
    'https://8985f960eef9.ngrok-free.app',
    'http://localhost:8000/api',
    'http://127.0.0.1:8000/api',
    'https://api.barbermusicspa.com/api', // Si tienes un dominio
  ];
  
  print('🌐 Probando conectividad con diferentes URLs...\n');
  
  for (final baseUrl in urlsToTest) {
    print('🔗 Probando: $baseUrl');
    
    try {
      // Probar endpoint de salud
      final healthResponse = await _testEndpoint('$baseUrl/health', 'Health Check');
      
      if (healthResponse['statusCode'] == 200) {
        print('✅ Servidor activo en: $baseUrl');
        print('📡 Respuesta: ${healthResponse['body']}');
        
        // Si el servidor está activo, probar endpoints específicos
        await _testSpecificEndpoints(baseUrl);
        break;
      } else {
        print('❌ Servidor no responde en: $baseUrl');
        print('📡 Status: ${healthResponse['statusCode']}');
      }
    } catch (e) {
      print('❌ Error de conectividad: $e');
    }
    print('');
  }
  
  print('🎯 Prueba de conectividad completada');
}

Future<void> _testSpecificEndpoints(String baseUrl) async {
  print('\n🔍 Probando endpoints específicos...\n');
  
  final endpoints = [
    {'name': 'Sucursales', 'url': '$baseUrl/Admin_sucursales/sucursales'},
    {'name': 'Servicios', 'url': '$baseUrl/Catalog_servicios/servicios'},
    {'name': 'Productos', 'url': '$baseUrl/Catalog_productos/productos'},
    {'name': 'Promociones', 'url': '$baseUrl/Admin_promociones/promociones'},
    {'name': 'Login', 'url': '$baseUrl/Client_usuarios/auth/login'},
  ];
  
  for (final endpoint in endpoints) {
    await _testEndpoint(endpoint['url']!, endpoint['name']!);
  }
}

Future<Map<String, dynamic>> _testEndpoint(String url, String name) async {
  print('🔍 Probando $name...');
  
  try {
    final response = await _makeRequest(url);
    
    print('📡 Status: ${response['statusCode']}');
    
    if (response['statusCode'] == 200) {
      try {
        final data = jsonDecode(response['body']);
        print('✅ $name: Respuesta válida');
        
        // Mostrar estructura de datos
        if (data is Map) {
          print('📋 Estructura de respuesta:');
          data.keys.take(5).forEach((key) {
            print('   $key: ${data[key]}');
          });
        } else if (data is List) {
          print('📋 Lista con ${data.length} elementos');
          if (data.isNotEmpty) {
            final firstItem = data.first;
            if (firstItem is Map) {
              print('📋 Estructura del primer elemento:');
              firstItem.keys.take(3).forEach((key) {
                print('   $key: ${firstItem[key]}');
              });
            }
          }
        }
      } catch (parseError) {
        print('❌ Error parsing JSON: $parseError');
        print('📄 Respuesta raw: ${response['body'].substring(0, 200)}...');
      }
    } else {
      print('❌ $name: ${response['statusCode']}');
      print('📄 Respuesta: ${response['body']}');
    }
  } catch (e) {
    print('❌ Error en $name: $e');
  }
  print('');
  
  return {'statusCode': 0, 'body': ''};
}

Future<Map<String, dynamic>> _makeRequest(String url) async {
  final client = HttpClient();
  
  try {
    final request = await client.openUrl('GET', Uri.parse(url));
    
    // Headers por defecto
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    return {
      'statusCode': response.statusCode,
      'body': responseBody,
    };
  } finally {
    client.close();
  }
} 