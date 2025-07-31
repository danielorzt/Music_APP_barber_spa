import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 Probando endpoints de la API BMSPA...\n');
  
  const baseUrl = 'https://8985f960eef9.ngrok-free.app/api';
  
  // Credenciales de prueba
  const email = 'test2@example.com';
  const password = 'password123';
  
  String? authToken;
  
  // 1. Probar login
  print('1️⃣ Probando login...');
  try {
    final loginResponse = await _makeRequest(
      '$baseUrl/Client_usuarios/auth/login',
      method: 'POST',
      body: {
        'email': email,
        'password': password,
      },
    );
    
    if (loginResponse['statusCode'] == 200) {
      final data = jsonDecode(loginResponse['body']);
      authToken = data['data']['token'];
      print('✅ Login exitoso');
      print('📄 Token: ${authToken!.substring(0, 50)}...');
    } else {
      print('❌ Login fallido: ${loginResponse['statusCode']}');
      print('📄 Respuesta: ${loginResponse['body']}');
      return;
    }
  } catch (e) {
    print('❌ Error en login: $e');
    return;
  }
  
  print('\n2️⃣ Probando endpoints con autenticación...\n');
  
  // 2. Probar endpoints protegidos
  final endpoints = [
    {'name': 'Productos', 'url': '$baseUrl/Catalog_productos/productos'},
    {'name': 'Servicios', 'url': '$baseUrl/Catalog_servicios/servicios'},
    {'name': 'Agendamientos', 'url': '$baseUrl/Scheduling_agendamientos/agendamientos'},
    {'name': 'Promociones', 'url': '$baseUrl/Admin_promociones/promociones'},
    {'name': 'Direcciones', 'url': '$baseUrl/Client_direcciones/direcciones'},
  ];
  
  for (final endpoint in endpoints) {
    print('🔍 Probando ${endpoint['name']}...');
    try {
      final response = await _makeRequest(
        endpoint['url']!,
        headers: {'Authorization': 'Bearer $authToken'},
      );
      
      print('📡 Status: ${response['statusCode']}');
      
      if (response['statusCode'] == 200) {
        try {
          final data = jsonDecode(response['body']);
          print('📄 Respuesta JSON válida');
          
          // Intentar extraer datos
          dynamic items;
          if (data['data'] is List) {
            items = data['data'];
          } else if (data is List) {
            items = data;
          } else {
            items = [];
          }
          
          final count = items is List ? items.length : 0;
          print('✅ ${endpoint['name']}: $count items');
          
          // Mostrar estructura de datos
          if (count > 0 && items is List) {
            print('📋 Estructura del primer item:');
            final firstItem = items.first;
            if (firstItem is Map) {
              firstItem.keys.take(5).forEach((key) {
                print('   $key: ${firstItem[key]}');
              });
            }
          }
        } catch (parseError) {
          print('❌ Error parsing JSON: $parseError');
          print('📄 Respuesta raw: ${response['body'].substring(0, 200)}...');
        }
      } else {
        print('❌ ${endpoint['name']}: ${response['statusCode']}');
        print('📄 Respuesta: ${response['body']}');
      }
    } catch (e) {
      print('❌ Error en ${endpoint['name']}: $e');
    }
    print('');
  }
  
  print('🎯 Pruebas completadas');
}

Future<Map<String, dynamic>> _makeRequest(
  String url, {
  String method = 'GET',
  Map<String, String>? headers,
  Map<String, dynamic>? body,
}) async {
  final client = HttpClient();
  
  try {
    final request = await client.openUrl(method, Uri.parse(url));
    
    // Headers por defecto
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    // Headers adicionales
    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
    }
    
    // Body para POST/PUT
    if (body != null) {
      request.write(jsonEncode(body));
    }
    
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