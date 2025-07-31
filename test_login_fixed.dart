import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔍 Probando login con usuario creado...\n');
  
  final baseUrl = 'http://localhost:8000/api';
  
  // Probar login con el usuario creado
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('$baseUrl/Client_usuarios/auth/login'));
    request.headers.set('Accept', 'application/json');
    request.headers.set('Content-Type', 'application/json');
    
    final loginData = {
      'email': 'test@example.com',
      'password': 'password123'
    };
    
    request.write(jsonEncode(loginData));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('📡 Login Status: ${response.statusCode}');
    print('📄 Login Response: ${responseBody.substring(0, responseBody.length > 200 ? 200 : responseBody.length)}...\n');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(responseBody);
      if (data['access_token'] != null) {
        print('✅ Login exitoso! Token obtenido');
        
        // Probar endpoints con token
        final token = data['access_token'];
        print('\n🔐 Probando endpoints con token...\n');
        
        final protectedEndpoints = [
          '/Catalog_servicios/servicios',
          '/Catalog_productos/productos',
        ];
        
        for (final endpoint in protectedEndpoints) {
          print('📡 Probando con token: $endpoint');
          try {
            final client2 = HttpClient();
            final request2 = await client2.getUrl(Uri.parse('$baseUrl$endpoint'));
            request2.headers.set('Accept', 'application/json');
            request2.headers.set('Content-Type', 'application/json');
            request2.headers.set('Authorization', 'Bearer $token');
            
            final response2 = await request2.close();
            final responseBody2 = await response2.transform(utf8.decoder).join();
            
            print('✅ Status: ${response2.statusCode}');
            print('📄 Response: ${responseBody2.substring(0, responseBody2.length > 100 ? 100 : responseBody2.length)}...\n');
          } catch (e) {
            print('❌ Error: $e\n');
          }
        }
      }
    } else {
      print('❌ Login falló');
      print('📄 Error completo: $responseBody');
    }
  } catch (e) {
    print('❌ Error en login: $e\n');
  }
} 