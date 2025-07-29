import 'dart:convert';
import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para APIs de catálogo (servicios, productos, categorías, sucursales)
class CatalogApiService extends BaseApiService {
  
  /// Obtener todos los servicios
  Future<Map<String, dynamic>> getServicios({String? categoriaId}) async {
    print('🔍 Obteniendo servicios...');
    
    try {
      String endpoint = ApiConfig.serviciosEndpoint;
      if (categoriaId != null) {
        endpoint += '?categoria_id=$categoriaId';
      }
      
      final response = await get(endpoint);
      print('✅ Servicios obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo servicios: $e');
      rethrow;
    }
  }
  
  /// Obtener un servicio específico
  Future<Map<String, dynamic>> getServicio(String id) async {
    print('🔍 Obteniendo servicio $id...');
    
    try {
      final response = await get('${ApiConfig.serviciosEndpoint}/$id');
      print('✅ Servicio obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo servicio: $e');
      rethrow;
    }
  }
  
  /// Obtener todos los productos
  Future<Map<String, dynamic>> getProductos({String? categoriaId}) async {
    print('🔍 Obteniendo productos...');
    
    try {
      String endpoint = ApiConfig.productosEndpoint;
      if (categoriaId != null) {
        endpoint += '?categoria_id=$categoriaId';
      }
      
      final response = await get(endpoint);
      print('✅ Productos obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo productos: $e');
      rethrow;
    }
  }
  
  /// Obtener un producto específico
  Future<Map<String, dynamic>> getProducto(String id) async {
    print('🔍 Obteniendo producto $id...');
    
    try {
      final response = await get('${ApiConfig.productosEndpoint}/$id');
      print('✅ Producto obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo producto: $e');
      rethrow;
    }
  }
  
  /// Obtener todas las categorías
  Future<Map<String, dynamic>> getCategorias() async {
    print('🔍 Obteniendo categorías...');
    
    try {
      final response = await get(ApiConfig.categoriasEndpoint);
      print('✅ Categorías obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo categorías: $e');
      rethrow;
    }
  }
  
  /// Obtener servicios destacados
  Future<Map<String, dynamic>> getServiciosDestacados() async {
    print('🔍 Obteniendo servicios destacados...');
    
    try {
      final response = await get(ApiConfig.serviciosDestacadosEndpoint);
      print('✅ Servicios destacados obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo servicios destacados: $e');
      print('📋 Usando datos mock para servicios destacados...');
      
      // Datos mock para servicios destacados
      return {
        'success': true,
        'data': [
          {
            'id': '1',
            'nombre': 'Corte Clásico',
            'descripcion': 'Corte de cabello tradicional con acabado profesional',
            'precio': 25000.0,
            'duracion': 30,
            'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
            'destacado': true,
          },
          {
            'id': '2',
            'nombre': 'Afeitado Tradicional',
            'descripcion': 'Afeitado con navaja y productos premium',
            'precio': 18000.0,
            'duracion': 20,
            'imagen': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
            'destacado': true,
          },
          {
            'id': '3',
            'nombre': 'Masaje Relajante',
            'descripcion': 'Masaje terapéutico para aliviar tensiones',
            'precio': 45000.0,
            'duracion': 60,
            'imagen': 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=400',
            'destacado': true,
          },
        ],
        'message': 'Datos mock - API no disponible',
      };
    }
  }
  
  /// Obtener productos destacados
  Future<Map<String, dynamic>> getProductosDestacados() async {
    print('🔍 Obteniendo productos destacados...');
    
    try {
      final response = await get(ApiConfig.productosDestacadosEndpoint);
      print('✅ Productos destacados obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo productos destacados: $e');
      print('📋 Usando datos mock para productos destacados...');
      
      // Datos mock para productos destacados
      return {
        'success': true,
        'data': [
          {
            'id': '1',
            'nombre': 'Aceite para Barba Premium',
            'descripcion': 'Aceite hidratante para barba con aceites esenciales',
            'precio': 35000.0,
            'imagen': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
            'destacado': true,
            'categoria': 'Cuidado Personal',
          },
          {
            'id': '2',
            'nombre': 'Navaja de Afeitar Artesanal',
            'descripcion': 'Navaja de acero inoxidable con mango de madera',
            'precio': 85000.0,
            'imagen': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
            'destacado': true,
            'categoria': 'Herramientas',
          },
          {
            'id': '3',
            'nombre': 'Kit de Peinado Profesional',
            'descripcion': 'Kit completo con tijeras, peine y spray',
            'precio': 120000.0,
            'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
            'destacado': true,
            'categoria': 'Herramientas',
          },
        ],
        'message': 'Datos mock - API no disponible',
      };
    }
  }
  
  /// Obtener ofertas y promociones
  Future<Map<String, dynamic>> getOfertas() async {
    print('🔍 Obteniendo ofertas...');
    
    try {
      final response = await get(ApiConfig.ofertasEndpoint);
      print('✅ Ofertas obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo ofertas: $e');
      print('📋 Usando datos mock para ofertas...');
      
      // Datos mock para ofertas
      return {
        'success': true,
        'data': [
          {
            'id': '1',
            'titulo': 'Descuento 20% en Cortes',
            'descripcion': 'Descuento especial en todos los cortes de cabello',
            'descuento': 20,
            'fecha_inicio': '2025-07-28',
            'fecha_fin': '2025-08-15',
            'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
            'activa': true,
          },
          {
            'id': '2',
            'titulo': 'Combo Barba + Corte',
            'descripcion': 'Ahorra 15% en el combo de barba y corte',
            'descuento': 15,
            'fecha_inicio': '2025-07-25',
            'fecha_fin': '2025-08-10',
            'imagen': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
            'activa': true,
          },
          {
            'id': '3',
            'titulo': 'Masaje Relajante 30% OFF',
            'descripcion': 'Disfruta de un masaje relajante con descuento especial',
            'descuento': 30,
            'fecha_inicio': '2025-07-20',
            'fecha_fin': '2025-08-20',
            'imagen': 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=400',
            'activa': true,
          },
        ],
        'message': 'Datos mock - API no disponible',
      };
    }
  }
  
  /// Obtener todas las sucursales
  Future<Map<String, dynamic>> getSucursales() async {
    print('🔍 Obteniendo sucursales...');
    
    try {
      final response = await get(ApiConfig.sucursalesEndpoint);
      print('✅ Sucursales obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo sucursales: $e');
      rethrow;
    }
  }
  
  /// Obtener una sucursal específica
  Future<Map<String, dynamic>> getSucursal(String id) async {
    print('🔍 Obteniendo sucursal $id...');
    
    try {
      final response = await get('${ApiConfig.sucursalesEndpoint}/$id');
      print('✅ Sucursal obtenida exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo sucursal: $e');
      rethrow;
    }
  }
  
  /// Obtener personal de una sucursal
  Future<Map<String, dynamic>> getPersonalSucursal(String sucursalId) async {
    print('🔍 Obteniendo personal de sucursal $sucursalId...');
    
    try {
      final response = await get('${ApiConfig.personalEndpoint}?sucursal_id=$sucursalId');
      print('✅ Personal obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo personal: $e');
      rethrow;
    }
  }
  
  /// Obtener especialidades
  Future<Map<String, dynamic>> getEspecialidades() async {
    print('🔍 Obteniendo especialidades...');
    
    try {
      final response = await get(ApiConfig.especialidadesEndpoint);
      print('✅ Especialidades obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo especialidades: $e');
      rethrow;
    }
  }
  
  /// Buscar servicios por nombre
  Future<Map<String, dynamic>> buscarServicios(String query) async {
    print('🔍 Buscando servicios: "$query"...');
    
    try {
      final response = await get('${ApiConfig.serviciosEndpoint}?search=$query');
      print('✅ Búsqueda completada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error en búsqueda: $e');
      rethrow;
    }
  }
  
  /// Buscar productos por nombre
  Future<Map<String, dynamic>> buscarProductos(String query) async {
    print('🔍 Buscando productos: "$query"...');
    
    try {
      final response = await get('${ApiConfig.productosEndpoint}?search=$query');
      print('✅ Búsqueda completada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error en búsqueda: $e');
      rethrow;
    }
  }
} 