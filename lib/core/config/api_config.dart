class ApiConfig {
  // Configuración de la API
  static const String baseUrl = 'http://192.168.39.148:8000/api';
  
  // === ENDPOINTS DE AUTENTICACIÓN ===
  static const String loginEndpoint = '/Client_usuarios/auth/login';
  static const String registerEndpoint = '/Client_usuarios/auth/register';
  static const String logoutEndpoint = '/Client_usuarios/auth/logout';
  static const String meEndpoint = '/Client_usuarios/auth/me';
  
  // === ENDPOINTS DE CATÁLOGO (PÚBLICOS/PROTEGIDOS) ===
  static const String serviciosEndpoint = '/Catalog_servicios/servicios';
  static const String productosEndpoint = '/Catalog_productos/productos';
  
  // === ENDPOINTS DE CLIENTE ===
  // Agendamientos (Citas)
  static const String agendamientosEndpoint = '/Scheduling_agendamientos/agendamientos';
  
  // Órdenes y Compras
  static const String ordenesEndpoint = '/Client_ordenes/ordenes';
  static const String detalleOrdenesEndpoint = '/Client_detalle_ordenes';
  
  // Perfil y Datos Personales
  static const String direccionesEndpoint = '/Client_direcciones/direcciones';
  static const String recordatoriosEndpoint = '/Client_recordatorios/recordatorios';
  
  // Reseñas y Valoraciones
  static const String resenasEndpoint = '/Client_reseñas';
  
  // Preferencias Musicales
  static const String musicaPreferenciasEndpoint = '/Client_musica_preferencias/preferencias';
  
  // === ENDPOINTS ADMINISTRATIVOS (Para futuro) ===
  static const String sucursalesEndpoint = '/Admin_sucursales/sucursales';
  static const String promocionesEndpoint = '/Admin_promociones/promociones';
  static const String personalEndpoint = '/Admin_personal/personal';
  static const String categoriasEndpoint = '/Admin_categorias/categorias';
  static const String especialidadesEndpoint = '/Admin_especialidades/especialidades';
  
  // === ENDPOINTS DE PAGOS ===
  static const String transaccionesPagoEndpoint = '/Payments_transacciones_pago';
  
  // === ENDPOINTS DE HORARIOS ===
  static const String horariosSucursalEndpoint = '/Scheduling_horarios_sucursal/horarios';
  static const String excepcionesHorarioEndpoint = '/Scheduling_excepciones_horario_sucursal';
  
  // Configuración de timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 15);
  static const Duration longTimeout = Duration(seconds: 60);
  
  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Credenciales de prueba (basadas en bd_definitiva.sql)
  static const Map<String, Map<String, String>> testCredentials = {
    'admin_general': {
      'email': 'admin@barbermusicaspa.com',
      'password': 'password',
      'name': 'Carlos Rodríguez',
      'role': 'ADMIN_GENERAL'
    },
    'admin_strada': {
      'email': 'admin.strada@barbermusicaspa.com',
      'password': 'password',
      'name': 'María González',
      'role': 'EMPLEADO'
    },
    'admin_slp': {
      'email': 'admin.slp@barbermusicaspa.com',
      'password': 'password',
      'name': 'José Martínez',
      'role': 'EMPLEADO'
    },
    'cliente_alejandra': {
      'email': 'alejandra.vazquez@gmail.com',
      'password': 'password',
      'name': 'Alejandra Vázquez',
      'role': 'CLIENTE'
    },
    'cliente_roberto': {
      'email': 'roberto.silva@gmail.com',
      'password': 'password',
      'name': 'Roberto Silva',
      'role': 'CLIENTE'
    },
    'cliente_carmen': {
      'email': 'carmen.jimenez@hotmail.com',
      'password': 'password',
      'name': 'Carmen Jiménez',
      'role': 'CLIENTE'
    },
  };
  
  // URL completa para un endpoint
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  // URLs específicas para funcionalidades del cliente
  static String getServiciosUrl() => getFullUrl(serviciosEndpoint);
  static String getProductosUrl() => getFullUrl(productosEndpoint);
  static String getAgendamientosUrl() => getFullUrl(agendamientosEndpoint);
  static String getOrdenesUrl() => getFullUrl(ordenesEndpoint);
  static String getDireccionesUrl() => getFullUrl(direccionesEndpoint);
  static String getRecordatoriosUrl() => getFullUrl(recordatoriosEndpoint);
  static String getMusicaPreferenciasUrl() => getFullUrl(musicaPreferenciasEndpoint);
  
  // URLs con parámetros
  static String getServicioUrl(String id) => '${getServiciosUrl()}/$id';
  static String getProductoUrl(String id) => '${getProductosUrl()}/$id';
  static String getAgendamientoUrl(String id) => '${getAgendamientosUrl()}/$id';
  static String getOrdenUrl(String id) => '${getOrdenesUrl()}/$id';
  static String getDireccionUrl(String id) => '${getDireccionesUrl()}/$id';
  static String getRecordatorioUrl(String id) => '${getRecordatoriosUrl()}/$id';
  
  // Verificar si la configuración es válida
  static bool isConfigValid() {
    return baseUrl.isNotEmpty && baseUrl.startsWith('http');
  }
  
  // Información de debug
  static Map<String, dynamic> getDebugInfo() {
    return {
      'baseUrl': baseUrl,
      'isValid': isConfigValid(),
      'auth_endpoints': {
        'login': getFullUrl(loginEndpoint),
        'register': getFullUrl(registerEndpoint),
        'logout': getFullUrl(logoutEndpoint),
        'me': getFullUrl(meEndpoint),
      },
      'client_endpoints': {
        'servicios': getServiciosUrl(),
        'productos': getProductosUrl(),
        'agendamientos': getAgendamientosUrl(),
        'ordenes': getOrdenesUrl(),
        'direcciones': getDireccionesUrl(),
        'recordatorios': getRecordatoriosUrl(),
        'musicaPreferencias': getMusicaPreferenciasUrl(),
      },
      'testAccountsCount': testCredentials.length,
    };
  }
  
  // Configuración específica por tipo de operación
  static Duration getTimeoutForEndpoint(String endpoint) {
    if (endpoint.contains('productos') || endpoint.contains('servicios')) {
      return longTimeout; // Catálogos pueden ser grandes
    } else if (endpoint.contains('auth')) {
      return defaultTimeout;
    } else {
      return shortTimeout;
    }
  }
  
  // Verificar si un endpoint requiere autenticación
  static bool requiresAuth(String endpoint) {
    final publicEndpoints = [
      loginEndpoint,
      registerEndpoint,
      // Algunos catálogos podrían ser públicos
    ];
    
    return !publicEndpoints.contains(endpoint);
  }
} 