import 'dart:io';
import 'dart:convert';

void main() async {
  print('🔍 Probando conectividad con el backend...\n');
  
  final urls = [
    'http://localhost:8000/api',
    'http://127.0.0.1:8000/api',
    'http://10.0.2.2:8000/api',
    'https://e2286224ffa9.ngrok-free.app/api',
  ];
  
  for (final url in urls) {
    print('📡 Probando: $url');
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('$url/health'));
      request.headers.set('Accept', 'application/json');
      request.headers.set('Content-Type', 'application/json');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      print('✅ Status: ${response.statusCode}');
      print('📄 Response: $responseBody\n');
    } catch (e) {
      print('❌ Error: $e\n');
    }
  }
  
  print('🧪 Probando endpoints específicos...\n');
  
  // Probar endpoints específicos
  final endpoints = [
    '/Client_usuarios/auth/login',
    '/Catalog_servicios/servicios',
    '/Catalog_productos/productos',
  ];
  
  for (final endpoint in endpoints) {
    print('📡 Probando endpoint: $endpoint');
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('http://localhost:8000/api$endpoint'));
      request.headers.set('Accept', 'application/json');
      request.headers.set('Content-Type', 'application/json');
      
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      
      print('✅ Status: ${response.statusCode}');
      print('📄 Response: ${responseBody.substring(0, responseBody.length > 100 ? 100 : responseBody.length)}...\n');
    } catch (e) {
      print('❌ Error: $e\n');
    }
  }
} 