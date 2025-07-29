import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Helper para hacer pruebas rápidas de las APIs
class ApiTestHelper {
  
  /// Imprimir información de debug de la configuración
  static void printApiConfig() {
    print('🔧 === DEBUG API CONFIGURATION ===');
    print('📍 Base URL: ${ApiConfig.baseUrl}');
    print('🔗 Endpoints disponibles:');
    
    final debugInfo = ApiConfig.getDebugInfo();
    print('📋 Auth Endpoints:');
    debugInfo['auth_endpoints'].forEach((key, value) {
      print('  - $key: $value');
    });
    
    print('📋 Client Endpoints:');
    debugInfo['client_endpoints'].forEach((key, value) {
      print('  - $key: $value');
    });
    
    print('👥 Test Accounts: ${debugInfo['testAccountsCount']} disponibles');
    print('🔧 === END DEBUG INFO ===\n');
  }
  
  /// Test de conectividad básica con el servidor
  static Future<Map<String, dynamic>> testServerConnectivity() async {
    print('🌐 Testing server connectivity...');
    
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
      print('📡 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Server is reachable',
          'status_code': response.statusCode,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Server responded with error',
          'status_code': response.statusCode,
          'error': response.body,
        };
      }
    } catch (e) {
      print('❌ Connectivity test failed: $e');
      return {
        'success': false,
        'message': 'Cannot reach server',
        'error': e.toString(),
      };
    }
  }
  
  /// Test de autenticación con credenciales de prueba
  static Future<Map<String, dynamic>> testAuthentication() async {
    print('🔐 Testing authentication...');
    
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
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': 'Authentication successful',
          'status_code': response.statusCode,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Authentication failed',
          'status_code': response.statusCode,
          'error': response.body,
        };
      }
    } catch (e) {
      print('❌ Authentication test failed: $e');
      return {
        'success': false,
        'message': 'Authentication test error',
        'error': e.toString(),
      };
    }
  }
  
  /// Test completo de la API
  static Future<void> runFullApiTest() async {
    print('🚀 === STARTING FULL API TEST ===\n');
    
    // 1. Test de conectividad
    print('1️⃣ Testing server connectivity...');
    final connectivityResult = await testServerConnectivity();
    print('Result: ${connectivityResult['success'] ? '✅' : '❌'} ${connectivityResult['message']}\n');
    
    // 2. Test de autenticación
    print('2️⃣ Testing authentication...');
    final authResult = await testAuthentication();
    print('Result: ${authResult['success'] ? '✅' : '❌'} ${authResult['message']}\n');
    
    // 3. Mostrar configuración
    print('3️⃣ API Configuration:');
    printApiConfig();
    
    print('🏁 === API TEST COMPLETED ===\n');
  }
  
  /// Crear datos de prueba para diferentes tipos de requests
  static Map<String, dynamic> getMockServiceData() {
    return {
      'nombre': 'Servicio de Prueba API',
      'descripcion': 'Servicio creado desde la app móvil',
      'precio': 25.99,
      'duracion': 60,
      'categoria_id': '1',
      'activo': true,
    };
  }
  
  static Map<String, dynamic> getMockProductData() {
    return {
      'nombre': 'Producto de Prueba API',
      'descripcion': 'Producto creado desde la app móvil',
      'precio': 15.50,
      'stock': 10,
      'categoria_id': '1',
      'activo': true,
    };
  }
  
  static Map<String, dynamic> getMockAppointmentData() {
    final now = DateTime.now();
    final appointmentDate = now.add(const Duration(days: 7));
    
    return {
      'servicio_id': '1',
      'sucursal_id': '1',
      'fecha_hora_inicio': appointmentDate.toIso8601String(),
      'fecha_hora_fin': appointmentDate.add(const Duration(hours: 1)).toIso8601String(),
      'notas_cliente': 'Cita de prueba creada desde la app móvil',
    };
  }
  
  static Map<String, dynamic> getMockOrderData() {
    return {
      'productos': [
        {
          'producto_id': '1',
          'cantidad': 2,
          'precio_unitario': 25.99,
        },
        {
          'producto_id': '2',
          'cantidad': 1,
          'precio_unitario': 15.50,
        }
      ],
      'direccion_envio_id': '1',
      'metodo_pago': 'TARJETA',
      'notas_especiales': 'Orden de prueba desde la app móvil',
    };
  }
  
  /// Validar respuesta de API
  static bool validateApiResponse(Map<String, dynamic> response, {
    bool shouldHaveData = true,
    String? expectedDataKey,
  }) {
    print('🔍 Validating API Response...');
    print('📥 Response: ${jsonEncode(response)}');
    
    // Verificar que tenga success
    if (!response.containsKey('success')) {
      print('❌ Response missing "success" field');
      return false;
    }
    
    // Si debe tener datos, verificarlos
    if (shouldHaveData) {
      if (!response.containsKey('data') && !response.containsKey(expectedDataKey ?? 'data')) {
        print('❌ Response missing data field');
        return false;
      }
    }
    
    // Si es exitoso, todo bien
    if (response['success'] == true) {
      print('✅ Valid successful response');
      return true;
    }
    
    // Si no es exitoso, debería tener error
    if (response['success'] == false) {
      if (response.containsKey('error')) {
        print('⚠️ Valid error response: ${response['error']}');
        return true;
      } else {
        print('❌ Error response missing error message');
        return false;
      }
    }
    
    print('❌ Invalid response format');
    return false;
  }
  
  /// Obtener credenciales de prueba aleatorias
  static Map<String, String> getRandomTestCredentials() {
    final credentials = ApiConfig.testCredentials;
    final keys = credentials.keys.toList();
    final randomKey = keys[DateTime.now().millisecond % keys.length];
    final account = credentials[randomKey]!;
    
    return {
      'email': account['email']!,
      'password': account['password']!,
      'name': account['name']!,
      'role': account['role']!,
    };
  }
  
  /// Formatear tiempo transcurrido
  static String formatElapsed(DateTime start) {
    final elapsed = DateTime.now().difference(start);
    if (elapsed.inMilliseconds < 1000) {
      return '${elapsed.inMilliseconds}ms';
    } else {
      return '${(elapsed.inMilliseconds / 1000).toStringAsFixed(1)}s';
    }
  }
  
  /// Log de prueba con timestamp
  static void logTest(String operation, String details) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    print('[$timestamp] 🧪 $operation: $details');
  }
} 