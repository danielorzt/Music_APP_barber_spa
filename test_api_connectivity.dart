import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/core/config/api_config.dart';

void main() async {
  print('🚀 === BARBERMUSICSPA API CONNECTIVITY TEST ===\n');
  
  // Test 1: Verificar configuración
  print('1️⃣ API Configuration:');
  print('📍 Base URL: ${ApiConfig.baseUrl}');
  print('🔗 Test URL: ${ApiConfig.getTestUrl()}');
  print('🔐 Login URL: ${ApiConfig.getFullUrl(ApiConfig.loginEndpoint)}');
  print('');
  
  // Test 2: Conectividad básica
  print('2️⃣ Testing basic connectivity...');
  try {
    final url = Uri.parse(ApiConfig.getTestUrl());
    print('📡 Testing URL: $url');
    
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));
    
    print('📡 Response Status: ${response.statusCode}');
    print('📡 Response Headers: ${response.headers}');
    print('📡 Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Server is reachable!');
    } else {
      print('⚠️ Server responded with status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Cannot reach server: $e');
  }
  print('');
  
  // Test 3: Autenticación
  print('3️⃣ Testing authentication...');
  try {
    final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.loginEndpoint));
    final testCredentials = ApiConfig.testCredentials['cliente1']!;
    
    print('📡 Testing login with: ${testCredentials['email']}');
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': testCredentials['email'],
        'password': testCredentials['password'],
      }),
    ).timeout(const Duration(seconds: 10));
    
    print('📡 Auth Response Status: ${response.statusCode}');
    print('📡 Auth Response Body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Authentication successful!');
      final data = json.decode(response.body);
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
  
  // Test 4: Endpoints adicionales
  print('4️⃣ Testing additional endpoints...');
  final endpoints = [
    ApiConfig.serviciosEndpoint,
    ApiConfig.productosEndpoint,
    ApiConfig.sucursalesEndpoint,
  ];
  
  for (final endpoint in endpoints) {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
      print('📡 Testing: $endpoint');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));
      
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
  print('- Check that your Laravel server is running on ${ApiConfig.baseUrl}');
  print('- Verify that your database is properly configured');
  print('- Ensure CORS is properly configured in Laravel');
} 