import 'dart:convert';
import 'dart:io';

/// Prueba simple de conectividad con la nueva URL local
void main() async {
  print('🔧 PRUEBA DE CONECTIVIDAD - NUEVA URL LOCAL');
  print('=============================================');
  
  // Información de la nueva configuración
  print('\n📋 CONFIGURACIÓN ACTUAL:');
  print('URL Ngrok: https://13b3b2a25fe8.ngrok-free.app');
  print('URL Base: https://13b3b2a25fe8.ngrok-free.app/api');
  
  // Probar conectividad básica
  print('\n🌐 PROBANDO CONECTIVIDAD...');
  
  try {
    // Test 1: Health check básico
    final healthUrl = 'https://13b3b2a25fe8.ngrok-free.app/api/health';
    print('\n1️⃣ Probando health check: $healthUrl');
    
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(healthUrl));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ Status: ${response.statusCode}');
    print('📄 Response: $responseBody');
    
  } catch (e) {
    print('❌ Error en health check: $e');
  }
  
  // Test 2: Endpoint de servicios
  try {
    final serviciosUrl = 'https://13b3b2a25fe8.ngrok-free.app/api/Catalog_servicios/servicios';
    print('\n2️⃣ Probando endpoint de servicios: $serviciosUrl');
    
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(serviciosUrl));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      print('📊 Servicios encontrados: ${data['data']?.length ?? 0}');
    } else {
      print('📄 Response: $responseBody');
    }
    
  } catch (e) {
    print('❌ Error en servicios: $e');
  }
  
  // Test 3: Endpoint de productos
  try {
    final productosUrl = 'https://13b3b2a25fe8.ngrok-free.app/api/Catalog_productos/productos';
    print('\n3️⃣ Probando endpoint de productos: $productosUrl');
    
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(productosUrl));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      print('📊 Productos encontrados: ${data['data']?.length ?? 0}');
    } else {
      print('📄 Response: $responseBody');
    }
    
  } catch (e) {
    print('❌ Error en productos: $e');
  }
  
  // Test 4: Login de prueba
  try {
    final loginUrl = 'https://13b3b2a25fe8.ngrok-free.app/api/Client_usuarios/auth/login';
    print('\n4️⃣ Probando login de prueba: $loginUrl');
    
    final loginData = {
      'email': 'anagarcia123@gmail.com',
      'password': 'passwordAna1'
    };
    
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(loginUrl));
    request.headers.set('Content-Type', 'application/json');
    request.write(json.encode(loginData));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = json.decode(responseBody);
      print('🔑 Login exitoso: ${data['message'] ?? 'OK'}');
      if (data['data']?['access_token'] != null) {
        print('🎫 Token obtenido: ${data['data']['access_token'].toString().substring(0, 20)}...');
      }
    } else {
      print('📄 Response: $responseBody');
    }
    
  } catch (e) {
    print('❌ Error en login: $e');
  }
  
  print('\n✅ PRUEBA COMPLETADA');
  print('🎯 Si todos los tests pasaron, la nueva URL está funcionando correctamente.');
  print('📱 Ahora puedes ejecutar la aplicación Flutter con la nueva configuración.');
} 