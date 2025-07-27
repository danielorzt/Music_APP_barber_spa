import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para gestionar servicios y productos del catálogo
class CatalogApiService extends BaseApiService {
  
  // === SERVICIOS ===
  
  /// Obtener todos los servicios
  Future<Map<String, dynamic>> getServicios({
    int? page,
    int? limit,
    String? categoria,
    String? search,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (categoria != null) params['categoria'] = categoria;
    if (search != null) params['search'] = search;
    
    final endpoint = buildEndpointWithParams(ApiConfig.serviciosEndpoint, params);
    
    print('🔍 Obteniendo servicios...');
    final result = await get(endpoint, requiresAuth: false); // Los catálogos pueden ser públicos
    
    if (result['success']) {
      final servicios = extractList(result['data'], 'servicios');
      print('✅ ${servicios.length} servicios obtenidos');
      
      return {
        'success': true,
        'servicios': servicios,
        'total': result['data']['total'] ?? servicios.length,
        'current_page': result['data']['current_page'] ?? 1,
        'last_page': result['data']['last_page'] ?? 1,
      };
    }
    
    return result;
  }
  
  /// Obtener un servicio específico por ID
  Future<Map<String, dynamic>> getServicio(String id) async {
    print('🔍 Obteniendo servicio ID: $id');
    final result = await get('${ApiConfig.serviciosEndpoint}/$id', requiresAuth: false);
    
    if (result['success']) {
      final servicio = extractData(result['data'], 'servicio') ?? result['data'];
      print('✅ Servicio obtenido: ${servicio['nombre'] ?? 'Sin nombre'}');
      
      return {
        'success': true,
        'servicio': servicio,
      };
    }
    
    return result;
  }
  
  /// Obtener servicios por categoría
  Future<Map<String, dynamic>> getServiciosByCategoria(String categoriaId) async {
    return getServicios(categoria: categoriaId);
  }
  
  /// Buscar servicios
  Future<Map<String, dynamic>> searchServicios(String query) async {
    return getServicios(search: query);
  }
  
  // === PRODUCTOS ===
  
  /// Obtener todos los productos
  Future<Map<String, dynamic>> getProductos({
    int? page,
    int? limit,
    String? categoria,
    String? search,
    double? minPrice,
    double? maxPrice,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (categoria != null) params['categoria'] = categoria;
    if (search != null) params['search'] = search;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    
    final endpoint = buildEndpointWithParams(ApiConfig.productosEndpoint, params);
    
    print('🔍 Obteniendo productos...');
    final result = await get(endpoint, requiresAuth: false); // Los catálogos pueden ser públicos
    
    if (result['success']) {
      final productos = extractList(result['data'], 'productos');
      print('✅ ${productos.length} productos obtenidos');
      
      return {
        'success': true,
        'productos': productos,
        'total': result['data']['total'] ?? productos.length,
        'current_page': result['data']['current_page'] ?? 1,
        'last_page': result['data']['last_page'] ?? 1,
      };
    }
    
    return result;
  }
  
  /// Obtener un producto específico por ID
  Future<Map<String, dynamic>> getProducto(String id) async {
    print('🔍 Obteniendo producto ID: $id');
    final result = await get('${ApiConfig.productosEndpoint}/$id', requiresAuth: false);
    
    if (result['success']) {
      final producto = extractData(result['data'], 'producto') ?? result['data'];
      print('✅ Producto obtenido: ${producto['nombre'] ?? 'Sin nombre'}');
      
      return {
        'success': true,
        'producto': producto,
      };
    }
    
    return result;
  }
  
  /// Obtener productos por categoría
  Future<Map<String, dynamic>> getProductosByCategoria(String categoriaId) async {
    return getProductos(categoria: categoriaId);
  }
  
  /// Buscar productos
  Future<Map<String, dynamic>> searchProductos(String query) async {
    return getProductos(search: query);
  }
  
  /// Obtener productos con filtros de precio
  Future<Map<String, dynamic>> getProductosWithPriceFilter({
    double? minPrice,
    double? maxPrice,
    String? categoria,
  }) async {
    return getProductos(
      minPrice: minPrice,
      maxPrice: maxPrice,
      categoria: categoria,
    );
  }
  
  // === CATEGORÍAS (Útil para filtros) ===
  
  /// Obtener categorías disponibles
  Future<Map<String, dynamic>> getCategorias() async {
    print('🔍 Obteniendo categorías...');
    final result = await get(ApiConfig.categoriasEndpoint, requiresAuth: false);
    
    if (result['success']) {
      final categorias = extractList(result['data'], 'categorias');
      print('✅ ${categorias.length} categorías obtenidas');
      
      return {
        'success': true,
        'categorias': categorias,
      };
    }
    
    return result;
  }
  
  // === UTILIDADES ===
  
  /// Obtener servicios destacados (puede basarse en algún campo específico)
  Future<Map<String, dynamic>> getServiciosDestacados() async {
    // Implementar lógica específica según cómo tu API maneja servicios destacados
    // Por ahora, obtener los primeros 6 servicios
    return getServicios(limit: 6);
  }
  
  /// Obtener productos destacados
  Future<Map<String, dynamic>> getProductosDestacados() async {
    // Implementar lógica específica según cómo tu API maneja productos destacados
    // Por ahora, obtener los primeros 6 productos
    return getProductos(limit: 6);
  }
  
  /// Obtener ofertas o productos con descuento
  Future<Map<String, dynamic>> getOfertas() async {
    print('🔍 Obteniendo ofertas...');
    // Implementar lógica específica para ofertas según tu API
    // Esto podría ser un endpoint específico o filtros especiales
    return getProductos(limit: 10);
  }
} 