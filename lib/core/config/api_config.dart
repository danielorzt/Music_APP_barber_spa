import 'package:shared_preferences/shared_preferences.dart';

/// Configuración centralizada para todas las APIs del cliente
class ApiConfig {
  // Base URL de la API Laravel - Usando la IP real del servidor
  static const String baseUrl = 'http://172.30.7.51:8000/api';
  
  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 60);
  
  // Endpoints de Autenticación (Client_*)
  static const String loginEndpoint = '/Client_usuarios/auth/login';
  static const String registerEndpoint = '/Client_usuarios/auth/register';
  static const String logoutEndpoint = '/Client_usuarios/auth/logout';
  static const String currentUserEndpoint = '/Client_usuarios/perfil'; // Cambiado de /auth/me a /perfil
  static const String refreshTokenEndpoint = '/Client_usuarios/auth/refresh';
  
  // Endpoints de Catálogo (Catalog_*)
  static const String serviciosEndpoint = '/Catalog_servicios/servicios';
  static const String productosEndpoint = '/Catalog_productos/productos';
  static const String categoriasEndpoint = '/Admin_categorias/categorias';
  static const String serviciosDestacadosEndpoint = '/Catalog_servicios/servicios/destacados';
  static const String productosDestacadosEndpoint = '/Catalog_productos/productos/destacados';
  static const String ofertasEndpoint = '/Admin_promociones/promociones';
  
  // Endpoints de Agendamiento (Scheduling_*)
  static const String agendamientosEndpoint = '/Scheduling_agendamientos/agendamientos';
  static const String horariosSucursalEndpoint = '/Scheduling_horarios_sucursal/horarios';
  static const String excepcionesHorarioEndpoint = '/Scheduling_excepciones_horario_sucursal/excepciones';
  static const String disponibilidadEndpoint = '/Scheduling_agendamientos/disponibilidad';
  static const String personalDisponibleEndpoint = '/Scheduling_agendamientos/personal-disponible';
  
  // Endpoints de Órdenes (Client_*)
  static const String ordenesEndpoint = '/Client_ordenes/ordenes';
  static const String detalleOrdenesEndpoint = '/Client_detalle_ordenes/detalle-ordenes';
  static const String carritoEndpoint = '/Client_ordenes/carrito';
  
  // Endpoints de Usuario y Perfil (Client_*)
  static const String perfilEndpoint = '/Client_usuarios/perfil';
  static const String direccionesEndpoint = '/Client_direcciones/direcciones';
  static const String resenasEndpoint = '/Client_reseñas/reseñas';
  static const String preferenciasMusicaEndpoint = '/Client_musica_preferencias/preferencias';
  
  // Endpoints de Sucursales (Admin_*)
  static const String sucursalesEndpoint = '/Admin_sucursales/sucursales';
  static const String personalEndpoint = '/Admin_personal/personal';
  static const String especialidadesEndpoint = '/Admin_especialidades/especialidades';
  
  // Endpoints de Pagos (Payments_*)
  static const String transaccionesPagoEndpoint = '/Payments_transacciones_pago/transacciones';
  
  // Endpoints de Recordatorios (Client_*)
  static const String recordatoriosEndpoint = '/Client_recordatorios/recordatorios';
  
  // Endpoints faltantes que causan errores
  static const String horariosEndpoint = '/Scheduling_horarios_sucursal/horarios';
  static const String favoritosEndpoint = '/Client_favoritos/favoritos';
  
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
      final token = prefs.getString('jwt_token');
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
      'auth_endpoints': {
        'login': loginEndpoint,
        'register': registerEndpoint,
        'logout': logoutEndpoint,
        'currentUser': currentUserEndpoint,
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
} 