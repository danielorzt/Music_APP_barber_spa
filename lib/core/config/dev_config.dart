import 'package:dio/dio.dart';
import 'api_config.dart';

/// Configuración específica para desarrollo con el servidor BMSPA
class DevConfig {
  // Configuración del servidor de desarrollo
  static const String serverUrl = 'https://c21dae5133a1.ngrok-free.app';
  static const String apiBaseUrl = '$serverUrl/api';
  
  // Endpoints específicos de BMSPA
  static const Map<String, String> endpoints = {
    // Autenticación JWT
    'login': '/Client_usuarios/auth/login',
    'register': '/Client_usuarios/auth/register',
    'logout': '/Client_usuarios/auth/logout',
    'currentUser': '/Client_usuarios/auth/oauth/me',
    
    // Autenticación OAuth2
    'oauthLogin': '/Client_usuarios/auth/oauth/login',
    'oauthRefresh': '/Client_usuarios/auth/oauth/refresh',
    'oauthLogout': '/Client_usuarios/auth/oauth/logout',
    
    // Catálogo
    'servicios': '/Catalog_servicios/servicios',
    'productos': '/Catalog_productos/productos',
    'categorias': '/Catalog_categorias/categorias',
    
    // Agendamiento
    'agendamientos': '/Agendamiento_citas/agendamientos',
    'horarios': '/Agendamiento_horarios/horarios',
    'disponibilidad': '/Agendamiento_disponibilidad/disponibilidad',
    
    // Órdenes
    'ordenes': '/Orders_ordenes/ordenes',
    'detalleOrdenes': '/Orders_detalle_ordenes/detalle_ordenes',
    'carrito': '/Orders_carrito/carrito',
    
    // Usuario
    'perfil': '/User_perfil/perfil',
    'direcciones': '/User_direcciones/direcciones',
    'favoritos': '/User_favoritos/favoritos',
    
    // Gestión de usuario (nuevos endpoints)
    'userAddresses': '/User_direcciones/direcciones',
    'userFavorites': '/User_favoritos/favoritos',
    'userAppointments': '/Agendamiento_citas/agendamientos',
    'userOrders': '/Orders_ordenes/ordenes',
    'userPaymentMethods': '/User_metodos_pago/metodos_pago',
    
    // Sucursales
    'sucursales': '/Branches_sucursales/sucursales',
    'personal': '/Branches_personal/personal',
    
    // Pagos
    'pagos': '/Payments_transacciones_pago/transacciones_pago',
    
    // Recordatorios
    'recordatorios': '/Reminders_recordatorios/recordatorios',
  };
  
  // Credenciales de prueba
  static Map<String, Map<String, String>> get testUsers => {
    'cliente1': {
      'email': 'test.${DateTime.now().millisecondsSinceEpoch}@example.com',
      'password': 'password123',
      'nombre': 'Usuario Test',
      'telefono': '3101234567'
    },
    'admin': {
      'email': 'admin@barbermusicaspa.com',
      'password': 'password',
      'nombre': 'Administrador',
      'telefono': '3001234567'
    }
  };
  
  // Configuración de timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 60);
  
  // Configuración de reintentos
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  /// Obtener URL completa para un endpoint
  static String getFullUrl(String endpoint) {
    return '$apiBaseUrl$endpoint';
  }
  
  /// Obtener endpoint por nombre
  static String? getEndpoint(String name) {
    return endpoints[name];
  }
  
  /// Verificar si un endpoint requiere autenticación
  static bool requiresAuth(String endpoint) {
    final publicEndpoints = [
      endpoints['login'],
      endpoints['register'],
      endpoints['oauthLogin'],
      endpoints['oauthRefresh'],
    ];
    
    return !publicEndpoints.contains(endpoint);
  }
  
  /// Obtener headers para una petición
  static Map<String, String> getHeaders({bool requiresAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    return headers;
  }
  
  /// Información de debug
  static Map<String, dynamic> getDebugInfo() {
    return {
      'serverUrl': serverUrl,
      'apiBaseUrl': apiBaseUrl,
      'endpoints': endpoints,
      'testUsers': testUsers,
      'timeouts': {
        'default': defaultTimeout.inSeconds,
        'short': shortTimeout.inSeconds,
        'long': longTimeout.inSeconds,
      },
      'retries': {
        'max': maxRetries,
        'delay': retryDelay.inSeconds,
      }
    };
  }
  
  /// URL para testing de conectividad
  static String getHealthCheckUrl() {
    return '$apiBaseUrl/health';
  }
  
  /// URL para testing de endpoints
  static String getTestUrl() {
    return getFullUrl(endpoints['servicios']!);
  }
} 