import 'dart:convert';
import 'dart:io';

void main() async {
  print('🚀 === BARBERMUSICSPA API CONNECTIVITY TEST ===\n');
  
  // Configuración
  const String baseUrl = 'http://172.30.2.48:8000/api';
  const String testUrl = '$baseUrl/Catalog_servicios/servicios';
  const String loginUrl = '$baseUrl/Client_usuarios/auth/login';
  
  print('1️⃣ API Configuration:');
  print('📍 Base URL: $baseUrl');
  print('🔗 Test URL: $testUrl');
  print('🔐 Login URL: $loginUrl');
  print('');
  
  // Test 1: Conectividad básica
  print('2️⃣ Testing basic connectivity...');
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(testUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('📡 Response Status: ${response.statusCode}');
    print('📡 Response Headers: ${response.headers}');
    print('📡 Response Body: ${responseBody}');
    
    if (response.statusCode == 200) {
      print('✅ Server is reachable!');
    } else {
      print('⚠️ Server responded with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Cannot reach server: $e');
  }
  print('');
  
  // Test 2: Autenticación
  print('3️⃣ Testing authentication...');
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(loginUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final loginData = {
      'email': 'alejandra.vazquez@gmail.com',
      'password': 'password',
    };
    
    request.write(json.encode(loginData));
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('📡 Auth Response Status: ${response.statusCode}');
    print('📡 Auth Response Body: $responseBody');
    
    if (response.statusCode == 200) {
      print('✅ Authentication successful!');
      final data = json.decode(responseBody);
      if (data['token'] != null) {
        print('🎉 JWT Token received!');
      }
    } else {
      print('❌ Authentication failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Authentication test failed: $e');
  }
  print('');
  
  // Test 3: Endpoints adicionales
  print('4️⃣ Testing additional endpoints...');
  final endpoints = [
    '/Catalog_servicios/servicios',
    '/Catalog_productos/productos',
    '/Admin_sucursales/sucursales',
  ];
  
  for (final endpoint in endpoints) {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse('$baseUrl$endpoint'));
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');
      
      final response = await request.close();
      print('📡 Testing: $endpoint');
      print('   Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('   ✅ OK');
      } else {
        print('   ❌ Error');
      }
    } catch (e) {
      print('   ❌ Failed: $e');
    }
  }
  print('');
  
  print('🏁 === TEST COMPLETED ===');
  print('');
  print('📋 Summary:');
  print('- If you see ✅ marks, your API is working correctly');
  print('- If you see ❌ marks, there might be network or server issues');
  print('- Check that your Laravel server is running on $baseUrl');
  print('- Verify that your database is properly configured');
  print('- Ensure CORS is properly configured in Laravel');
} 