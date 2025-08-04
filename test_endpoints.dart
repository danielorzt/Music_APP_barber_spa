import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 === TESTING AVAILABLE ENDPOINTS ===\n');

  const String baseUrl = 'https://13b3b2a25fe8.ngrok-free.app/api';
  
  // Lista de endpoints a probar
  final endpoints = [
    '/Client_usuarios/auth/login',
    '/Client_usuarios/auth/register',
    '/Client_usuarios/auth/logout',
    '/Client_usuarios/auth/me',
    '/Client_usuarios/perfil',
    '/Client_usuarios/profile',
    '/Client_usuarios/user',
    '/auth/me',
    '/auth/user',
    '/user',
    '/profile',
  ];

  for (final endpoint in endpoints) {
    await testEndpoint(baseUrl + endpoint, endpoint);
  }

  print('\n🎯 === TEST COMPLETED ===');
}

Future<void> testEndpoint(String fullUrl, String endpoint) async {
  print('📍 Testing: $endpoint');
  
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(fullUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final response = await request.close();
    
    print('📡 Status: ${response.statusCode}');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ ENDPOINT AVAILABLE: $endpoint');
    } else if (response.statusCode == 404) {
      print('❌ NOT FOUND: $endpoint');
    } else if (response.statusCode == 401) {
      print('🔐 UNAUTHORIZED (needs auth): $endpoint');
    } else {
      print('⚠️ OTHER STATUS (${response.statusCode}): $endpoint');
    }
  } catch (e) {
    print('❌ ERROR: $endpoint - $e');
  }
  
  print('---');
} 