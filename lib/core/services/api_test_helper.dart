import 'dart:convert';
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