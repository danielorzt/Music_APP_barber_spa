import 'dart:convert';
import 'dart:io';

void main() async {
  print('🚀 === TESTING CONNECTIVITY ===\\n');
  
  // Configuración actualizada
  const String baseUrl = 'http://192.168.39.148:8000/api';
  const String loginUrl = '$baseUrl/Client_usuarios/auth/login';
  const String registerUrl = '$baseUrl/Client_usuarios/auth/register';
  
  print('📍 Testing URLs:');
  print('   Base URL: $baseUrl');
  print('   Login URL: $loginUrl');
  print('   Register URL: $registerUrl\\n');
  
  // Test 1: Conectividad básica
  print('1️⃣ Testing basic connectivity...');
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse('$baseUrl/Catalog_servicios/servicios'));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ Basic connectivity: SUCCESS');
    print('   Status: ${response.statusCode}');
    print('   Response length: ${responseBody.length} characters');
  } catch (e) {
    print('❌ Basic connectivity: FAILED');
    print('   Error: $e');
  }
  
  // Test 2: Login endpoint
  print('\\n2️⃣ Testing login endpoint...');
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse(loginUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final loginData = {
      'email': 'juan.perez@example.com',
      'password': 'Password123'
    };
    
    request.write(jsonEncode(loginData));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('✅ Login endpoint: SUCCESS');
    print('   Status: ${response.statusCode}');
    print('   Response: ${responseBody.substring(0, responseBody.length > 100 ? 100 : responseBody.length)}...');
  } catch (e) {
    print('❌ Login endpoint: FAILED');
    print('   Error: $e');
  }
  
  print('\\n🎯 === TEST COMPLETED ===');
} 