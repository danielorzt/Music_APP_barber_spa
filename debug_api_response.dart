import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 Debug API Response...\n');
  
  const baseUrl = 'https://8985f960eef9.ngrok-free.app/api';
  
  // 1. Login
  print('1️⃣ Login...');
  final loginResponse = await _makeRequest(
    '$baseUrl/Client_usuarios/auth/login',
    method: 'POST',
    body: {
      'email': 'test2@example.com',
      'password': 'password123',
    },
  );
  
  print('Status: ${loginResponse['statusCode']}');
  print('Body: ${loginResponse['body']}');
  
  if (loginResponse['statusCode'] != 200) {
    print('❌ Login fallido');
    return;
  }
  
  // 2. Parse token
  final loginData = jsonDecode(loginResponse['body']);
  final token = loginData['data']['token'];
  print('✅ Token obtenido: ${token.substring(0, 50)}...');
  
  // 3. Probar productos
  print('\n2️⃣ Productos...');
  final productosResponse = await _makeRequest(
    '$baseUrl/Catalog_productos/productos',
    headers: {'Authorization': 'Bearer $token'},
  );
  
  print('Status: ${productosResponse['statusCode']}');
  print('Body length: ${productosResponse['body'].length}');
  print('Body completo: "${productosResponse['body']}"');
  
  // 4. Intentar parsear
  if (productosResponse['body'].isNotEmpty) {
    try {
      final productosData = jsonDecode(productosResponse['body']);
      print('✅ JSON parseado correctamente');
      
      // Manejar tanto arrays directos como objetos con estructura data
      List<dynamic> items;
      if (productosData is List) {
        items = productosData;
        print('📋 Tipo: Array directo');
      } else if (productosData is Map && productosData['data'] is List) {
        items = productosData['data'];
        print('📋 Tipo: Objeto con estructura data');
      } else {
        items = [];
        print('📋 Tipo: Otro formato');
      }
      
      print('Data length: ${items.length}');
      if (items.isNotEmpty) {
        print('First item: ${items.first}');
      }
    } catch (e) {
      print('❌ Error parsing: $e');
    }
  } else {
    print('⚠️ Respuesta vacía');
  }
  
  // 5. Probar servicios
  print('\n3️⃣ Servicios...');
  final serviciosResponse = await _makeRequest(
    '$baseUrl/Catalog_servicios/servicios',
    headers: {'Authorization': 'Bearer $token'},
  );
  
  print('Status: ${serviciosResponse['statusCode']}');
  print('Body length: ${serviciosResponse['body'].length}');
  print('Body completo: "${serviciosResponse['body']}"');
  
  if (serviciosResponse['body'].isNotEmpty) {
    try {
      final serviciosData = jsonDecode(serviciosResponse['body']);
      print('✅ JSON parseado correctamente');
      
      List<dynamic> items;
      if (serviciosData is List) {
        items = serviciosData;
        print('📋 Tipo: Array directo');
      } else if (serviciosData is Map && serviciosData['data'] is List) {
        items = serviciosData['data'];
        print('📋 Tipo: Objeto con estructura data');
      } else {
        items = [];
        print('📋 Tipo: Otro formato');
      }
      
      print('Data length: ${items.length}');
      if (items.isNotEmpty) {
        print('First item: ${items.first}');
      }
    } catch (e) {
      print('❌ Error parsing: $e');
    }
  }
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
    
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
    }
    
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