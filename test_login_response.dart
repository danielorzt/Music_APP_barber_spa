import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 === TESTING LOGIN RESPONSE STRUCTURE ===\\n');
  
  const String loginUrl = 'https://13b3b2a25fe8.ngrok-free.app/api/Client_usuarios/auth/login';
  
  print('📍 Testing login endpoint: $loginUrl\\n');
  
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
    
    print('📡 Response Status: ${response.statusCode}');
    print('📡 Response Headers: ${response.headers}');
    print('📡 Full Response Body:');
    print(responseBody);
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      print('\\n🔍 Parsed JSON Structure:');
      print(data);
      
      // Analizar estructura
      print('\\n🔍 Structure Analysis:');
      if (data['message'] != null) {
        print('✅ message: ${data['message']}');
      }
      
      if (data['data'] != null) {
        print('✅ data object found');
        final dataObj = data['data'];
        
        if (dataObj['token'] != null) {
          print('✅ token: ${dataObj['token'].toString().substring(0, 50)}...');
        }
        
        if (dataObj['type'] != null) {
          print('✅ type: ${dataObj['type']}');
        }
        
        if (dataObj['expires_in'] != null) {
          print('✅ expires_in: ${dataObj['expires_in']}');
        }
        
        // Buscar datos de usuario
        if (dataObj['user'] != null) {
          print('✅ user object found');
        } else if (dataObj['id'] != null || dataObj['email'] != null) {
          print('✅ user data found directly in data object');
        } else {
          print('❌ No user data found in response');
        }
      }
    }
  } catch (e) {
    print('❌ Error: $e');
  }
  
  print('\\n🎯 === TEST COMPLETED ===');
} 