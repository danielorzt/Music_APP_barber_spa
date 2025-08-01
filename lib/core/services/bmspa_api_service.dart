import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/dev_config.dart';
import '../models/agendamiento.dart';
import '../models/producto.dart';
import '../models/orden.dart';

/// Servicio principal para la API de BMSPA
/// Maneja todos los endpoints de clientes según la documentación proporcionada
class BMSPAApiService {
  final Dio _dio = Dio();

  BMSPAApiService() {
    _dio.options.baseUrl = DevConfig.apiBaseUrl;
    _dio.options.connectTimeout = DevConfig.defaultTimeout;
    _dio.options.receiveTimeout = DevConfig.defaultTimeout;
  }

  /// Obtener token de autenticación
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  /// Configurar headers de autenticación
  Future<Options> _getAuthOptions() async {
    final token = await _getAuthToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // ============================================================================
  // 🔐 AUTENTICACIÓN Y PERFIL
  // ============================================================================

  /// Registro de usuario
  Future<Map<String, dynamic>> register({
    required String nombre,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? telefono,
  }) async {
    try {
      print('🔐 BMSPA API: Registrando usuario...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('register')!,
        data: {
          'nombre': nombre,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (telefono != null) 'telefono': telefono,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ Registro exitoso: ${response.statusCode}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final token = _findToken(data);
        final userData = _findUserData(data);
        
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          await prefs.setString('user_data', jsonEncode(userData));
        }
        
        return {
          'success': true,
          'user': userData,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'error': 'Error en el registro',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      print('❌ Error en registro: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      
      String errorMessage = 'Error en el registro';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      
      return {
        'success': false,
        'error': errorMessage,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      print('❌ Error inesperado en registro: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Login de usuario
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 BMSPA API: Iniciando sesión...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('login')!,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print('✅ Login exitoso: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = _findToken(data);
        final userData = _findUserData(data);
        
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
          await prefs.setString('user_data', jsonEncode(userData));
        }
        
        return {
          'success': true,
          'user': userData,
          'token': token,
        };
      } else {
        return {
          'success': false,
          'error': 'Error en el login',
          'statusCode': response.statusCode,
        };
      }
    } on DioException catch (e) {
      print('❌ Error en login: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      
      String errorMessage = 'Credenciales incorrectas';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      
      return {
        'success': false,
        'error': errorMessage,
        'statusCode': e.response?.statusCode,
      };
    } catch (e) {
      print('❌ Error inesperado en login: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Obtener usuario actual
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      print('👤 BMSPA API: Obteniendo usuario actual...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('currentUser')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        print('✅ Usuario obtenido exitosamente');
        return response.data['data'] ?? response.data;
      }
      
      return null;
    } on DioException catch (e) {
      print('❌ Error obteniendo usuario: ${e.type}');
      return null;
    } catch (e) {
      print('❌ Error inesperado obteniendo usuario: $e');
      return null;
    }
  }

  /// Logout
  Future<bool> logout() async {
    try {
      print('🚪 BMSPA API: Cerrando sesión...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('logout')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('jwt_token');
        await prefs.remove('user_data');
        print('✅ Logout exitoso');
        return true;
      }
      
      return false;
    } on DioException catch (e) {
      print('❌ Error en logout: ${e.type}');
      return false;
    } catch (e) {
      print('❌ Error inesperado en logout: $e');
      return false;
    }
  }

  // ============================================================================
  // 📅 CITAS Y AGENDAMIENTO
  // ============================================================================

  /// Listar agendamientos del usuario
  Future<List<Agendamiento>> getMisAgendamientos() async {
    try {
      print('📅 BMSPA API: Obteniendo agendamientos...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('agendamientos')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.map((json) => Agendamiento.fromJson(json)).toList();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo agendamientos: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo agendamientos: $e');
      return [];
    }
  }

  /// Crear cita
  Future<Map<String, dynamic>> createAppointment({
    required int sucursalId,
    required int servicioId,
    int? personalId,
    required String fecha,
    required String hora,
    String? notas,
  }) async {
    try {
      print('📅 BMSPA API: Creando cita...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('agendamientos')!,
        data: {
          'sucursal_id': sucursalId,
          'servicio_id': servicioId,
          if (personalId != null) 'personal_id': personalId,
          'fecha': fecha,
          'hora': hora,
          if (notas != null) 'notas': notas,
        },
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Cita creada exitosamente');
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error creando cita',
        };
      }
    } on DioException catch (e) {
      print('❌ Error creando cita: ${e.type}');
      String errorMessage = 'Error creando cita';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado creando cita: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Ver cita específica
  Future<Agendamiento?> getAppointment(int id) async {
    try {
      print('📅 BMSPA API: Obteniendo cita $id...');
      
      final endpoint = DevConfig.getEndpoint('agendamiento')!.replaceAll('{id}', id.toString());
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return Agendamiento.fromJson(data);
      }
      
      return null;
    } on DioException catch (e) {
      print('❌ Error obteniendo cita: ${e.type}');
      return null;
    } catch (e) {
      print('❌ Error inesperado obteniendo cita: $e');
      return null;
    }
  }

  /// Actualizar cita
  Future<Map<String, dynamic>> updateAppointment({
    required int id,
    String? fecha,
    String? hora,
    String? notas,
  }) async {
    try {
      print('📅 BMSPA API: Actualizando cita $id...');
      
      final endpoint = DevConfig.getEndpoint('agendamiento')!.replaceAll('{id}', id.toString());
      final data = <String, dynamic>{};
      if (fecha != null) data['fecha'] = fecha;
      if (hora != null) data['hora'] = hora;
      if (notas != null) data['notas'] = notas;
      
      final response = await _dio.put(
        endpoint,
        data: data,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        print('✅ Cita actualizada exitosamente');
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error actualizando cita',
        };
      }
    } on DioException catch (e) {
      print('❌ Error actualizando cita: ${e.type}');
      String errorMessage = 'Error actualizando cita';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado actualizando cita: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Cancelar cita
  Future<bool> cancelAppointment(int id) async {
    try {
      print('📅 BMSPA API: Cancelando cita $id...');
      
      final endpoint = DevConfig.getEndpoint('agendamiento')!.replaceAll('{id}', id.toString());
      final response = await _dio.delete(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        print('✅ Cita cancelada exitosamente');
        return true;
      }
      
      return false;
    } on DioException catch (e) {
      print('❌ Error cancelando cita: ${e.type}');
      return false;
    } catch (e) {
      print('❌ Error inesperado cancelando cita: $e');
      return false;
    }
  }

  // ============================================================================
  // 🛍️ SERVICIOS Y PRODUCTOS
  // ============================================================================

  /// Listar servicios (público)
  Future<List<Map<String, dynamic>>> getServicios() async {
    try {
      print('🛍️ BMSPA API: Obteniendo servicios...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('servicios')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        
        // Manejar tanto arrays como objetos con claves string
        if (data is Map) {
          // Si es un mapa, convertir sus valores a lista
          final servicesList = data.values.toList();
          return servicesList.cast<Map<String, dynamic>>();
        } else if (data is List) {
          // Si ya es una lista, proceder normalmente
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo servicios: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo servicios: $e');
      return [];
    }
  }

  /// Ver servicio específico
  Future<Map<String, dynamic>?> getServicio(int id) async {
    try {
      print('🛍️ BMSPA API: Obteniendo servicio $id...');
      
      final endpoint = DevConfig.getEndpoint('servicio')!.replaceAll('{id}', id.toString());
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return data as Map<String, dynamic>;
      }
      
      return null;
    } on DioException catch (e) {
      print('❌ Error obteniendo servicio: ${e.type}');
      return null;
    } catch (e) {
      print('❌ Error inesperado obteniendo servicio: $e');
      return null;
    }
  }

  /// Listar productos (público)
  Future<List<Producto>> getProductos() async {
    try {
      print('🛍️ BMSPA API: Obteniendo productos...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('productos')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        
        // Manejar tanto arrays como objetos con claves string
        if (data is Map) {
          // Si es un mapa, convertir sus valores a lista
          final productsList = data.values.toList();
          return productsList.map((json) => Producto.fromJson(json as Map<String, dynamic>)).toList();
        } else if (data is List) {
          // Si ya es una lista, proceder normalmente
          return data.map((json) => Producto.fromJson(json as Map<String, dynamic>)).toList();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo productos: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo productos: $e');
      return [];
    }
  }

  /// Ver producto específico
  Future<Producto?> getProducto(int id) async {
    try {
      print('🛍️ BMSPA API: Obteniendo producto $id...');
      
      final endpoint = DevConfig.getEndpoint('producto')!.replaceAll('{id}', id.toString());
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return Producto.fromJson(data as Map<String, dynamic>);
      }
      
      return null;
    } on DioException catch (e) {
      print('❌ Error obteniendo producto: ${e.type}');
      return null;
    } catch (e) {
      print('❌ Error inesperado obteniendo producto: $e');
      return null;
    }
  }

  // ============================================================================
  // 💳 COMPRAS Y ÓRDENES
  // ============================================================================

  /// Listar órdenes del usuario
  Future<List<Orden>> getMisOrdenes() async {
    try {
      print('💳 BMSPA API: Obteniendo órdenes...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('ordenes')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.map((json) => Orden.fromJson(json)).toList();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo órdenes: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo órdenes: $e');
      return [];
    }
  }

  /// Crear orden
  Future<Map<String, dynamic>> createOrder({
    required int direccionId,
    required List<Map<String, dynamic>> productos,
    required String metodoPago,
    String? notas,
  }) async {
    try {
      print('💳 BMSPA API: Creando orden...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('ordenes')!,
        data: {
          'direccion_id': direccionId,
          'productos': productos,
          'metodo_pago': metodoPago,
          if (notas != null) 'notas': notas,
        },
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Orden creada exitosamente');
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error creando orden',
        };
      }
    } on DioException catch (e) {
      print('❌ Error creando orden: ${e.type}');
      String errorMessage = 'Error creando orden';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado creando orden: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  // ============================================================================
  // 📍 DIRECCIONES
  // ============================================================================

  /// Listar direcciones del usuario
  Future<List<Map<String, dynamic>>> getMisDirecciones() async {
    try {
      print('📍 BMSPA API: Obteniendo direcciones...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('direcciones')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo direcciones: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo direcciones: $e');
      return [];
    }
  }

  /// Crear dirección
  Future<Map<String, dynamic>> createDireccion({
    required String calle,
    required String numero,
    required String ciudad,
    required String departamento,
    String? codigoPostal,
    String? referencias,
  }) async {
    try {
      print('📍 BMSPA API: Creando dirección...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('direcciones')!,
        data: {
          'calle': calle,
          'numero': numero,
          'ciudad': ciudad,
          'departamento': departamento,
          if (codigoPostal != null) 'codigo_postal': codigoPostal,
          if (referencias != null) 'referencias': referencias,
        },
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Dirección creada exitosamente');
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error creando dirección',
        };
      }
    } on DioException catch (e) {
      print('❌ Error creando dirección: ${e.type}');
      String errorMessage = 'Error creando dirección';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado creando dirección: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  // ============================================================================
  // ⭐ RESEÑAS Y CALIFICACIONES
  // ============================================================================

  /// Listar reseñas públicas
  Future<List<Map<String, dynamic>>> getResenasPublicas() async {
    try {
      print('⭐ BMSPA API: Obteniendo reseñas públicas...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('reseñasPublic')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo reseñas públicas: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo reseñas públicas: $e');
      return [];
    }
  }

  /// Listar mis reseñas
  Future<List<Map<String, dynamic>>> getMisResenas() async {
    try {
      print('⭐ BMSPA API: Obteniendo mis reseñas...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('reseñas')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo mis reseñas: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo mis reseñas: $e');
      return [];
    }
  }

  /// Crear reseña
  Future<Map<String, dynamic>> createResena({
    required String tipo, // "servicio" o "producto"
    required int itemId,
    required int calificacion,
    required String comentario,
    String? titulo,
  }) async {
    try {
      print('⭐ BMSPA API: Creando reseña...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('reseñas')!,
        data: {
          'tipo': tipo,
          'item_id': itemId,
          'calificacion': calificacion,
          'comentario': comentario,
          if (titulo != null) 'titulo': titulo,
        },
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Reseña creada exitosamente');
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error creando reseña',
        };
      }
    } on DioException catch (e) {
      print('❌ Error creando reseña: ${e.type}');
      String errorMessage = 'Error creando reseña';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado creando reseña: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  // ============================================================================
  // 🔔 RECORDATORIOS Y NOTIFICACIONES
  // ============================================================================

  /// Listar recordatorios
  Future<List<Map<String, dynamic>>> getRecordatorios() async {
    try {
      print('🔔 BMSPA API: Obteniendo recordatorios...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('recordatorios')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo recordatorios: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo recordatorios: $e');
      return [];
    }
  }

  /// Crear recordatorio
  Future<Map<String, dynamic>> createRecordatorio({
    required String titulo,
    required String descripcion,
    required String fecha,
    String? hora,
    String? tipo, // "cita", "promocion", "general"
  }) async {
    try {
      print('🔔 BMSPA API: Creando recordatorio...');
      
      final response = await _dio.post(
        DevConfig.getEndpoint('recordatorios')!,
        data: {
          'titulo': titulo,
          'descripcion': descripcion,
          'fecha': fecha,
          if (hora != null) 'hora': hora,
          if (tipo != null) 'tipo': tipo,
        },
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Recordatorio creado exitosamente');
        return {
          'success': true,
          'data': response.data['data'] ?? response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error creando recordatorio',
        };
      }
    } on DioException catch (e) {
      print('❌ Error creando recordatorio: ${e.type}');
      String errorMessage = 'Error creando recordatorio';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      print('❌ Error inesperado creando recordatorio: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  // ============================================================================
  // 📊 DATOS ADICIONALES
  // ============================================================================

  /// Listar sucursales
  Future<List<Map<String, dynamic>>> getSucursales() async {
    try {
      print('📊 BMSPA API: Obteniendo sucursales...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('sucursales')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo sucursales: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo sucursales: $e');
      return [];
    }
  }

  /// Listar personal
  Future<List<Map<String, dynamic>>> getPersonal() async {
    try {
      print('📊 BMSPA API: Obteniendo personal...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('personal')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo personal: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo personal: $e');
      return [];
    }
  }

  /// Obtener personal por sucursal
  Future<List<Map<String, dynamic>>> getPersonalPorSucursal(int sucursalId) async {
    try {
      print('📊 BMSPA API: Obteniendo personal de sucursal $sucursalId...');
      
      final response = await _dio.get(
        '${DevConfig.getEndpoint('personal')!}?sucursal_id=$sucursalId',
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo personal de sucursal: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo personal de sucursal: $e');
      return [];
    }
  }

  /// Obtener horarios por sucursal
  Future<List<Map<String, dynamic>>> getHorariosPorSucursal(int sucursalId) async {
    try {
      print('📊 BMSPA API: Obteniendo horarios de sucursal $sucursalId...');
      
      final response = await _dio.get(
        '/api/horarios-sucursal?sucursal_id=$sucursalId',
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo horarios de sucursal: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo horarios de sucursal: $e');
      return [];
    }
  }

  /// Listar categorías
  Future<List<Map<String, dynamic>>> getCategorias() async {
    try {
      print('📊 BMSPA API: Obteniendo categorías...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('categorias')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo categorías: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo categorías: $e');
      return [];
    }
  }

  /// Listar promociones (público)
  Future<List<Map<String, dynamic>>> getPromociones() async {
    try {
      print('📊 BMSPA API: Obteniendo promociones...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('promociones')!,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        
        // Manejar tanto arrays como objetos con claves string
        if (data is Map) {
          // Si es un mapa, convertir sus valores a lista
          final promotionsList = data.values.toList();
          return promotionsList.cast<Map<String, dynamic>>();
        } else if (data is List) {
          // Si ya es una lista, proceder normalmente
          return data.cast<Map<String, dynamic>>();
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo promociones: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo promociones: $e');
      return [];
    }
  }

  // ============================================================================
  // 🔧 MÉTODOS AUXILIARES
  // ============================================================================

  /// Buscar token en la respuesta
  String? _findToken(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['token'] ?? 
             data['access_token'] ?? 
             data['jwt_token'] ?? 
             data['auth_token'];
    }
    return null;
  }

  /// Buscar datos de usuario en la respuesta
  Map<String, dynamic>? _findUserData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['user'] ?? 
             data['data'] ?? 
             data['usuario'] ?? 
             data;
    }
    return null;
  }
} 