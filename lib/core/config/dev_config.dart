import 'package:dio/dio.dart';
import 'api_config.dart';

/// Configuración específica para desarrollo con el servidor BMSPA
class DevConfig {
  // Configuración del servidor de desarrollo
  static const String serverUrl = 'https://8985f960eef9.ngrok-free.app';
  static const String apiBaseUrl = '$serverUrl/api';
  
  // Endpoints específicos de BMSPA - Actualizados según la API proporcionada
  static const Map<String, String> endpoints = {
    // 🔐 AUTENTICACIÓN Y PERFIL
    'login': 'Client_usuarios/auth/login',
    'register': 'Client_usuarios/auth/register',
    'logout': 'Client_usuarios/auth/logout',
    'currentUser': 'Client_usuarios/auth/oauth/me',
    
    // 📅 CITAS Y AGENDAMIENTO
    'agendamientos': '/Scheduling_agendamientos/agendamientos',
    'agendamiento': '/Scheduling_agendamientos/agendamientos/{id}',
    
    // 🛍️ SERVICIOS Y PRODUCTOS
    'servicios': '/Catalog_servicios/servicios',
    'servicio': '/Catalog_servicios/servicios/{id}',
    'productos': '/Catalog_productos/productos',
    'producto': '/Catalog_productos/productos/{id}',
    
    // 💳 COMPRAS Y ÓRDENES
    'ordenes': '/Client_ordenes/ordenes',
    'orden': '/Client_ordenes/ordenes/{id}',
    
    // 📍 DIRECCIONES
    'direcciones': '/Client_direcciones/direcciones',
    'direccion': '/Client_direcciones/direcciones/{id}',
    'direccionDefault': '/Client_direcciones/direcciones/{id}/default',
    
    // ⭐ RESEÑAS Y CALIFICACIONES
    'reseñas': '/Client_reseñas/reseñas',
    'reseña': '/Client_reseñas/reseñas/{id}',
    'reseñasPublic': '/Client_reseñas/reseñas/public',
    
    // 🔔 RECORDATORIOS Y NOTIFICACIONES
    'recordatorios': '/Client_recordatorios/recordatorios',
    'recordatorio': '/Client_recordatorios/recordatorios/{id}',
    
    // 📊 DATOS ADICIONALES
    'sucursales': '/Admin_sucursales/sucursales',
    'personal': '/Admin_personal/personal',
    'categorias': '/Admin_categorias/categorias',
    'promociones': '/Admin_promociones/promociones',
    
    // 🛒 CARRITO (si existe)
    'carrito': '/Client_carrito/carrito',
    
    // 💳 MÉTODOS DE PAGO
    'metodosPago': '/Client_metodos_pago/metodos_pago',
    'metodoPago': '/Client_metodos_pago/metodos_pago/{id}',
    
    // ⭐ FAVORITOS
    'favoritos': '/Client_favoritos/favoritos',
    'favorito': '/Client_favoritos/favoritos/{id}',
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
    // Asegurar que el endpoint esté formateado correctamente
    if (endpoint.isEmpty) {
      throw ArgumentError('Endpoint cannot be empty');
    }
    
    // Si el endpoint no comienza con '/', agregarlo
    final formattedEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    
    return '$apiBaseUrl$formattedEndpoint';
  }
  
  /// Obtener endpoint por nombre
  static String? getEndpoint(String name) {
    final endpoint = endpoints[name];
    if (endpoint == null) return null;
    
    // Si el endpoint ya comienza con '/', lo devolvemos tal como está
    if (endpoint.startsWith('/')) {
      return endpoint;
    }
    
    // Si no, agregamos el prefijo '/'
    return '/$endpoint';
  }
  
  /// Verificar si un endpoint requiere autenticación
  static bool requiresAuth(String endpoint) {
    final publicEndpoints = [
      endpoints['login'],
      endpoints['register'],
      endpoints['reseñasPublic'],
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