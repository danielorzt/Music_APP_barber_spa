import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/dev_config.dart';
import '../models/producto.dart';
import '../models/servicio.dart';

/// Servicio unificado para catálogo (productos y servicios)
/// Reemplaza los servicios duplicados y proporciona una interfaz consistente
class UnifiedCatalogService {
  final Dio _dio = Dio();

  UnifiedCatalogService() {
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
  // 🛍️ PRODUCTOS
  // ============================================================================

  /// Listar todos los productos
  Future<List<Producto>> getProductos({int? categoriaId}) async {
    try {
      print('🛍️ Obteniendo productos...');
      
      String endpoint = DevConfig.getEndpoint('productos')!;
      if (categoriaId != null) {
        endpoint += '?categoria_id=$categoriaId';
      }
      
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> productos;
        
        // Manejar tanto arrays directos como objetos con estructura data
        if (data is List) {
          productos = data;
        } else if (data is Map && data['data'] is List) {
          productos = data['data'];
        } else {
          productos = [];
        }
        
        final result = productos.map((json) => Producto.fromJson(json)).toList();
        print('✅ Productos obtenidos: ${result.length}');
        return result;
      }
      
      print('⚠️ No se encontraron productos');
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo productos: ${e.type}');
      print('📄 Respuesta: ${e.response?.data}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo productos: $e');
      return [];
    }
  }

  /// Obtener producto específico
  Future<Producto?> getProducto(int id) async {
    try {
      print('🛍️ Obteniendo producto $id...');
      
      final endpoint = DevConfig.getEndpoint('producto')!.replaceAll('{id}', id.toString());
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final producto = Producto.fromJson(data);
        print('✅ Producto obtenido: ${producto.nombre}');
        return producto;
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

  /// Buscar productos por nombre
  Future<List<Producto>> buscarProductos(String query) async {
    try {
      print('🔍 Buscando productos: $query');
      
      String endpoint = DevConfig.getEndpoint('productos')!;
      endpoint += '?search=$query';
      
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          final productos = data.map((json) => Producto.fromJson(json)).toList();
          print('✅ Productos encontrados: ${productos.length}');
          return productos;
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error buscando productos: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado buscando productos: $e');
      return [];
    }
  }

  // ============================================================================
  // ✂️ SERVICIOS
  // ============================================================================

  /// Listar todos los servicios
  Future<List<Servicio>> getServicios({int? categoriaId}) async {
    try {
      print('✂️ Obteniendo servicios...');
      
      String endpoint = DevConfig.getEndpoint('servicios')!;
      if (categoriaId != null) {
        endpoint += '?categoria_id=$categoriaId';
      }
      
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> servicios;
        
        // Manejar tanto arrays directos como objetos con estructura data
        if (data is List) {
          servicios = data;
        } else if (data is Map && data['data'] is List) {
          servicios = data['data'];
        } else {
          servicios = [];
        }
        
        final result = servicios.map((json) => Servicio.fromJson(json)).toList();
        print('✅ Servicios obtenidos: ${result.length}');
        return result;
      }
      
      print('⚠️ No se encontraron servicios');
      return [];
    } on DioException catch (e) {
      print('❌ Error obteniendo servicios: ${e.type}');
      print('📄 Respuesta: ${e.response?.data}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo servicios: $e');
      return [];
    }
  }

  /// Obtener servicio específico
  Future<Servicio?> getServicio(int id) async {
    try {
      print('✂️ Obteniendo servicio $id...');
      
      final endpoint = DevConfig.getEndpoint('servicio')!.replaceAll('{id}', id.toString());
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        final servicio = Servicio.fromJson(data);
        print('✅ Servicio obtenido: ${servicio.nombre}');
        return servicio;
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

  /// Buscar servicios por nombre
  Future<List<Servicio>> buscarServicios(String query) async {
    try {
      print('🔍 Buscando servicios: $query');
      
      String endpoint = DevConfig.getEndpoint('servicios')!;
      endpoint += '?search=$query';
      
      final response = await _dio.get(
        endpoint,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          final servicios = data.map((json) => Servicio.fromJson(json)).toList();
          print('✅ Servicios encontrados: ${servicios.length}');
          return servicios;
        }
      }
      
      return [];
    } on DioException catch (e) {
      print('❌ Error buscando servicios: ${e.type}');
      return [];
    } catch (e) {
      print('❌ Error inesperado buscando servicios: $e');
      return [];
    }
  }

  // ============================================================================
  // 📂 CATEGORÍAS
  // ============================================================================

  /// Listar todas las categorías
  Future<List<Map<String, dynamic>>> getCategorias() async {
    try {
      print('📂 Obteniendo categorías...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('categorias')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          print('✅ Categorías obtenidas: ${data.length}');
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

  // ============================================================================
  // 🏢 SUCURSALES
  // ============================================================================

  /// Listar todas las sucursales
  Future<List<Map<String, dynamic>>> getSucursales() async {
    try {
      print('🏢 Obteniendo sucursales...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('sucursales')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          print('✅ Sucursales obtenidas: ${data.length}');
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

  // ============================================================================
  // 👥 PERSONAL
  // ============================================================================

  /// Listar todo el personal
  Future<List<Map<String, dynamic>>> getPersonal() async {
    try {
      print('👥 Obteniendo personal...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('personal')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          print('✅ Personal obtenido: ${data.length}');
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

  // ============================================================================
  // 🎯 PROMOCIONES
  // ============================================================================

  /// Listar todas las promociones
  Future<List<Map<String, dynamic>>> getPromociones() async {
    try {
      print('🎯 Obteniendo promociones...');
      
      final response = await _dio.get(
        DevConfig.getEndpoint('promociones')!,
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is List) {
          print('✅ Promociones obtenidas: ${data.length}');
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

  /// Crear una cita
  Future<Map<String, dynamic>> createAppointment({
    required String sucursalId,
    required String servicioId,
    String? personalId,
    required String fecha,
    required String hora,
    String? notas,
  }) async {
    try {
      print('📅 Creando cita...');
      
      final response = await _dio.post(
        '${DevConfig.apiBaseUrl}/Scheduling_agendamientos/agendamientos',
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Cita creada exitosamente');
        return {
          'success': true,
          'data': response.data,
        };
      }
      
      print('⚠️ Error creando cita: ${response.statusCode}');
      return {
        'success': false,
        'error': 'Error al crear la cita',
      };
    } on DioException catch (e) {
      print('❌ Error de Dio creando cita: ${e.type}');
      return {
        'success': false,
        'error': 'Error de conexión al crear la cita',
      };
    } catch (e) {
      print('❌ Error inesperado creando cita: $e');
      return {
        'success': false,
        'error': 'Error inesperado al crear la cita',
      };
    }
  }

  // ============================================================================
  // 📊 ESTADÍSTICAS
  // ============================================================================

  /// Obtener estadísticas del catálogo
  Future<Map<String, dynamic>> getEstadisticas() async {
    try {
      print('📊 Obteniendo estadísticas...');
      
      final productos = await getProductos();
      final servicios = await getServicios();
      final categorias = await getCategorias();
      final sucursales = await getSucursales();
      final personal = await getPersonal();
      final promociones = await getPromociones();
      
      return {
        'productos': productos.length,
        'servicios': servicios.length,
        'categorias': categorias.length,
        'sucursales': sucursales.length,
        'personal': personal.length,
        'promociones': promociones.length,
        'total_items': productos.length + servicios.length,
      };
    } catch (e) {
      print('❌ Error obteniendo estadísticas: $e');
      return {};
    }
  }
} 