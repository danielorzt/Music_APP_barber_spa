import 'package:shared_preferences/shared_preferences.dart';

/// Configuración centralizada para todas las APIs del cliente
class ApiConfig {
  // Configuración de entorno
  static const bool isDevelopment = true;
  
  // Base URLs - Múltiples opciones para diferentes entornos
  static const String baseUrlProduction = 'https://api.barbermusicaspa.com/api';
  static const String baseUrlDevelopment = 'https://c21dae5133a1.ngrok-free.app/api'; // URL de ngrok
  static const String baseUrlLocalhost = 'http://localhost:8000/api';
  static const String baseUrlEmulator = 'http://10.0.2.2:8000/api';
  static const String baseUrlNetwork = 'https://c21dae5133a1.ngrok-free.app/api'; // URL de ngrok
  
  // URL base activa según el entorno
  static String get baseUrl {
    if (isDevelopment) {
      // En desarrollo, intentar diferentes URLs
      return baseUrlDevelopment;
    }
    return baseUrlProduction;
  }
  
  // URLs alternativas para testing
  static List<String> get alternativeUrls => [
    baseUrlDevelopment,
    baseUrlLocalhost,
    baseUrlEmulator,
    baseUrlProduction,
  ];
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 60);
  
  // Endpoints de Autenticación JWT (corregidos según la API de BMSPA)
  static const String loginEndpoint = '/Client_usuarios/auth/login';
  static const String registerEndpoint = '/Client_usuarios/auth/register';
  static const String logoutEndpoint = '/Client_usuarios/auth/logout';
  static const String currentUserEndpoint = '/Client_usuarios/auth/oauth/me';
  
  // Endpoints OAuth2 específicos
  static const String oauthLoginEndpoint = '/Client_usuarios/auth/oauth/login';
  static const String oauthRefreshEndpoint = '/Client_usuarios/auth/oauth/refresh';
  static const String oauthMeEndpoint = '/Client_usuarios/auth/oauth/me';
  
  // Endpoints de Catálogo (simplificados)
  static const String serviciosEndpoint = '/services';
  static const String productosEndpoint = '/products';
  static const String categoriasEndpoint = '/categories';
  static const String serviciosDestacadosEndpoint = '/services/featured';
  static const String productosDestacadosEndpoint = '/products/featured';
  static const String ofertasEndpoint = '/promotions';
  
  // Endpoints de Agendamiento (corregidos según la API de BMSPA)
  static const String agendamientosEndpoint = '/Agendamiento_citas/agendamientos';
  static const String horariosSucursalEndpoint = '/Agendamiento_horarios/horarios';
  static const String excepcionesHorarioEndpoint = '/Agendamiento_excepciones/excepciones';
  static const String disponibilidadEndpoint = '/Agendamiento_disponibilidad/disponibilidad';
  static const String personalDisponibleEndpoint = '/Agendamiento_personal/personal';
  
  // Endpoints de Órdenes (simplificados)
  static const String ordenesEndpoint = '/orders';
  static const String detalleOrdenesEndpoint = '/order-details';
  static const String carritoEndpoint = '/cart';
  
  // Endpoints de Usuario y Perfil (simplificados)
  static const String perfilEndpoint = '/user/profile';
  static const String direccionesEndpoint = '/addresses';
  static const String resenasEndpoint = '/reviews';
  static const String preferenciasMusicaEndpoint = '/music-preferences';
  
  // Endpoints de Sucursales (simplificados)
  static const String sucursalesEndpoint = '/branches';
  static const String personalEndpoint = '/staff';
  static const String especialidadesEndpoint = '/specialties';
  
  // Endpoints de Pagos (simplificados)
  static const String transaccionesPagoEndpoint = '/payments';
  
  // Endpoints de Recordatorios (simplificados)
  static const String recordatoriosEndpoint = '/reminders';
  
  // Endpoints faltantes que causan errores
  static const String horariosEndpoint = '/schedules';
  static const String favoritosEndpoint = '/favorites';
  
  /// Credenciales de prueba basadas en bd_definitiva.sql
  static const Map<String, Map<String, String>> testCredentials = {
    'admin': {
      'email': 'admin@barbermusicaspa.com',
      'password': 'password',
      'name': 'Administrador General',
      'role': 'ADMIN_GENERAL',
    },
    'cliente1': {
      'email': 'alejandra.vazquez@gmail.com',
      'password': 'password',
      'name': 'Alejandra Vázquez',
      'role': 'CLIENTE',
    },
    'cliente2': {
      'email': 'roberto.silva@gmail.com',
      'password': 'password',
      'name': 'Roberto Silva',
      'role': 'CLIENTE',
    },
    'empleado1': {
      'email': 'carlos.rodriguez@barbermusicaspa.com',
      'password': 'password',
      'name': 'Carlos Rodríguez',
      'role': 'EMPLEADO',
    },
    'admin_sucursal': {
      'email': 'maria.gonzalez@barbermusicaspa.com',
      'password': 'password',
      'name': 'María González',
      'role': 'ADMIN_SUCURSAL',
    },
  };
  
  /// Obtener URL completa para un endpoint
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  /// Obtener URL completa con URL específica
  static String getFullUrlWithBase(String baseUrl, String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  /// Obtener timeout específico para un endpoint
  static Duration getTimeoutForEndpoint(String endpoint) {
    if (endpoint.contains('auth') || endpoint.contains('login')) {
      return shortTimeout;
    }
    if (endpoint.contains('upload') || endpoint.contains('download')) {
      return longTimeout;
    }
    return defaultTimeout;
  }
  
  /// Verificar si un endpoint requiere autenticación
  static bool requiresAuth(String endpoint) {
    final publicEndpoints = [
      loginEndpoint,
      registerEndpoint,
      oauthLoginEndpoint,
      // Nota: Actualmente todos los endpoints requieren auth en el servidor
      // Estos endpoints deberían ser públicos pero el servidor los protege
    ];
    
    return !publicEndpoints.contains(endpoint);
  }
  
  /// Obtener headers para una petición
  static Future<Map<String, String>> getHeaders({bool requiresAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (requiresAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? prefs.getString('jwt_token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }
  
  /// Información de debug
  static Map<String, dynamic> getDebugInfo() {
    return {
      'baseUrl': baseUrl,
      'isDevelopment': isDevelopment,
      'alternativeUrls': alternativeUrls,
      'auth_endpoints': {
        'login': loginEndpoint,
        'register': registerEndpoint,
        'logout': logoutEndpoint,
        'currentUser': currentUserEndpoint,
        'oauth_login': oauthLoginEndpoint,
        'oauth_refresh': oauthRefreshEndpoint,
        'oauth_me': oauthMeEndpoint,
      },
      'client_endpoints': {
        'servicios': serviciosEndpoint,
        'productos': productosEndpoint,
        'agendamientos': agendamientosEndpoint,
        'ordenes': ordenesEndpoint,
        'sucursales': sucursalesEndpoint,
      },
      'testAccountsCount': testCredentials.length,
    };
  }
  
  /// Verificar conectividad con el servidor
  static String getHealthCheckUrl() {
    return '$baseUrl/health';
  }
  
  /// URL para testing de conectividad básica
  static String getTestUrl() {
    return '$baseUrl/Catalog_servicios/servicios';
  }
  
  /// Obtener todas las URLs de prueba
  static List<String> getAllTestUrls() {
    return alternativeUrls.map((url) => '$url/Catalog_servicios/servicios').toList();
  }
  
  /// Obtener todas las URLs de health check
  static List<String> getAllHealthCheckUrls() {
    return alternativeUrls.map((url) => '$url/health').toList();
  }
} 