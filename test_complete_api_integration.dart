// test_complete_api_integration.dart
// Script completo para probar la integración con la API real de Laravel

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🚀 PRUEBA COMPLETA DE INTEGRACIÓN CON API LARAVEL');
  print('==================================================\n');
  
  const baseUrl = 'https://8985f960eef9.ngrok-free.app/api';
  
  // Usuarios de prueba basados en DATOS.SQL
  final testUsers = [
    {
      'email': 'anagarcia123@gmail.com',
      'password': 'passwordAna1',
      'nombre': 'Ana García'
    },
    {
      'email': 'carlosmrtz45@hotmail.com', 
      'password': 'passwordCar2',
      'nombre': 'Carlos Martínez'
    },
    {
      'email': 'sofialpz789@gmail.com',
      'password': 'passwordSof3', 
      'nombre': 'Sofía López'
    }
  ];
  
  String? authToken;
  Map<String, dynamic>? currentUser;
  
  // 1. PROBAR LOGIN CON USUARIOS REALES
  print('1️⃣ PROBANDO LOGIN CON USUARIOS REALES...\n');
  
  for (int i = 0; i < testUsers.length; i++) {
    final user = testUsers[i];
    print('🔐 Probando login con: ${user['email']}');
    
    try {
      final loginResponse = await _makeRequest(
        '$baseUrl/Client_usuarios/auth/login',
        method: 'POST',
        body: {
          'email': user['email'],
          'password': user['password'],
        },
      );
      
      print('📡 Status: ${loginResponse['statusCode']}');
      
      if (loginResponse['statusCode'] == 200) {
        final data = jsonDecode(loginResponse['body']);
        authToken = data['data']['token'];
        currentUser = data['data']['user'];
        
        print('✅ Login exitoso con ${user['nombre']}');
        print('📄 Token: ${authToken!.substring(0, 50)}...');
        print('👤 Usuario: ${currentUser!['nombre']} (ID: ${currentUser!['id']})');
        break;
      } else {
        print('❌ Login fallido: ${loginResponse['statusCode']}');
        print('📄 Respuesta: ${loginResponse['body']}');
      }
    } catch (e) {
      print('❌ Error en login: $e');
    }
    print('');
  }
  
  if (authToken == null) {
    print('❌ No se pudo autenticar con ningún usuario');
    print('💡 Verifica que los usuarios existan en la base de datos');
    return;
  }
  
  print('\n2️⃣ PROBANDO ENDPOINTS PÚBLICOS...\n');
  
  // 2. PROBAR ENDPOINTS PÚBLICOS
  final publicEndpoints = [
    {'name': 'Sucursales', 'url': '$baseUrl/Admin_sucursales/sucursales'},
    {'name': 'Servicios', 'url': '$baseUrl/Catalog_servicios/servicios'},
    {'name': 'Productos', 'url': '$baseUrl/Catalog_productos/productos'},
    {'name': 'Promociones', 'url': '$baseUrl/Admin_promociones/promociones'},
    {'name': 'Categorías', 'url': '$baseUrl/Admin_categorias/categorias'},
  ];
  
  for (final endpoint in publicEndpoints) {
    await _testEndpoint(endpoint['name']!, endpoint['url']!);
  }
  
  print('\n3️⃣ PROBANDO ENDPOINTS AUTENTICADOS...\n');
  
  // 3. PROBAR ENDPOINTS AUTENTICADOS
  final authEndpoints = [
    {'name': 'Agendamientos del Cliente', 'url': '$baseUrl/Scheduling_agendamientos/agendamientos'},
    {'name': 'Órdenes del Cliente', 'url': '$baseUrl/Client_ordenes/ordenes'},
    {'name': 'Direcciones del Cliente', 'url': '$baseUrl/Client_direcciones/direcciones'},
    {'name': 'Reseñas del Cliente', 'url': '$baseUrl/Client_reseñas/reseñas'},
    {'name': 'Perfil del Usuario', 'url': '$baseUrl/Client_usuarios/auth/oauth/me'},
  ];
  
  for (final endpoint in authEndpoints) {
    await _testEndpoint(endpoint['name']!, endpoint['url']!, authToken: authToken);
  }
  
  print('\n4️⃣ PROBANDO CREACIÓN DE DATOS...\n');
  
  // 4. PROBAR CREACIÓN DE DATOS
  await _testCreateAppointment(baseUrl, authToken, currentUser!);
  await _testCreateOrder(baseUrl, authToken, currentUser!);
  
  print('\n5️⃣ PROBANDO ENDPOINTS DE SUCURSALES...\n');
  
  // 5. PROBAR ENDPOINTS DE SUCURSALES
  final sucursalEndpoints = [
    {'name': 'Personal por Sucursal', 'url': '$baseUrl/Admin_personal/personal?sucursal_id=15'},
    {'name': 'Horarios por Sucursal', 'url': '$baseUrl/Agendamiento_horarios/horarios?sucursal_id=15'},
  ];
  
  for (final endpoint in sucursalEndpoints) {
    await _testEndpoint(endpoint['name']!, endpoint['url']!, authToken: authToken);
  }
  
  print('\n✅ PRUEBA COMPLETA FINALIZADA');
  print('🎯 La API está lista para ser integrada con Flutter');
}

Future<void> _testEndpoint(String name, String url, {String? authToken}) async {
  print('🔍 Probando $name...');
  
  try {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    
    final response = await _makeRequest(url, headers: headers);
    
    print('📡 Status: ${response['statusCode']}');
    
    if (response['statusCode'] == 200 || response['statusCode'] == 201) {
      try {
        final data = jsonDecode(response['body']);
        
        // Analizar estructura de datos
        dynamic items;
        if (data['data'] is List) {
          items = data['data'];
        } else if (data is List) {
          items = data;
        } else if (data is Map) {
          items = [data];
        } else {
          items = [];
        }
        
        final count = items is List ? items.length : 1;
        print('✅ $name: $count items encontrados');
        
        // Mostrar estructura del primer item
        if (count > 0 && items is List && items.isNotEmpty) {
          final firstItem = items.first;
          if (firstItem is Map) {
            print('📋 Estructura del primer item:');
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
      print('❌ $name: ${response['statusCode']}');
      print('📄 Respuesta: ${response['body']}');
    }
  } catch (e) {
    print('❌ Error en $name: $e');
  }
  print('');
}

Future<void> _testCreateAppointment(String baseUrl, String authToken, Map<String, dynamic> user) async {
  print('📅 Probando creación de agendamiento...');
  
  try {
    final appointmentData = {
      'cliente_usuario_id': user['id'],
      'personal_id': 1, // Ana García - Barbero
      'servicio_id': 17, // Corte de Cabello Masculino
      'sucursal_id': 15, // BarberMusicSpa San Luis Potosí
      'fecha_hora_inicio': '2025-01-30T10:00:00.000000Z',
      'fecha_hora_fin': '2025-01-30T10:45:00.000000Z',
      'precio_final': 25.0,
      'estado': 'PROGRAMADA',
      'notas_cliente': 'Cita de prueba desde Flutter App',
    };
    
    final response = await _makeRequest(
      '$baseUrl/Scheduling_agendamientos/agendamientos',
      method: 'POST',
      headers: {'Authorization': 'Bearer $authToken'},
      body: appointmentData,
    );
    
    print('📡 Status: ${response['statusCode']}');
    
    if (response['statusCode'] == 201) {
      print('✅ Agendamiento creado exitosamente');
      final data = jsonDecode(response['body']);
      print('📄 Respuesta: ${data['message']}');
    } else {
      print('❌ Error creando agendamiento: ${response['statusCode']}');
      print('📄 Respuesta: ${response['body']}');
    }
  } catch (e) {
    print('❌ Error en creación de agendamiento: $e');
  }
  print('');
}

Future<void> _testCreateOrder(String baseUrl, String authToken, Map<String, dynamic> user) async {
  print('🛍️ Probando creación de orden...');
  
  try {
    final orderData = {
      'notas_orden': 'Orden de prueba desde Flutter App',
      'detalles': [
        {
          'producto_id': 1, // Asumiendo que existe un producto con ID 1
          'cantidad': 2
        }
      ]
    };
    
    final response = await _makeRequest(
      '$baseUrl/Client_ordenes/ordenes',
      method: 'POST',
      headers: {'Authorization': 'Bearer $authToken'},
      body: orderData,
    );
    
    print('📡 Status: ${response['statusCode']}');
    
    if (response['statusCode'] == 201) {
      print('✅ Orden creada exitosamente');
      final data = jsonDecode(response['body']);
      print('📄 Respuesta: ${data['message']}');
    } else {
      print('❌ Error creando orden: ${response['statusCode']}');
      print('📄 Respuesta: ${response['body']}');
    }
  } catch (e) {
    print('❌ Error en creación de orden: $e');
  }
  print('');
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