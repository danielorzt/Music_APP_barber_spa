import 'dart:convert';
import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para manejar órdenes y compras con la API real de Laravel
class OrdersRealApiService extends BaseApiService {
  
  /// Obtener todas las órdenes del usuario
  Future<Map<String, dynamic>> getOrdenes({
    String? estado,
    String? fechaInicio,
    String? fechaFin,
    int? page,
  }) async {
    print('🛒 Obteniendo órdenes...');
    
    try {
      String endpoint = ApiConfig.ordenesEndpoint;
      List<String> params = [];
      
      if (estado != null) params.add('estado=$estado');
      if (fechaInicio != null) params.add('fecha_inicio=$fechaInicio');
      if (fechaFin != null) params.add('fecha_fin=$fechaFin');
      if (page != null) params.add('page=$page');
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await get(endpoint);
      print('✅ Órdenes obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo órdenes: $e');
      rethrow;
    }
  }
  
  /// Obtener una orden específica
  Future<Map<String, dynamic>> getOrden(String id) async {
    print('🛒 Obteniendo orden $id...');
    
    try {
      final response = await get('${ApiConfig.ordenesEndpoint}/$id');
      print('✅ Orden obtenida exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo orden: $e');
      rethrow;
    }
  }
  
  /// Crear una nueva orden
  Future<Map<String, dynamic>> crearOrden({
    required List<Map<String, dynamic>> productos,
    String? direccionId,
    String? metodoPago,
    String? notas,
  }) async {
    print('🛒 Creando nueva orden...');
    
    try {
      final body = {
        'productos': productos,
        if (direccionId != null) 'direccion_id': direccionId,
        if (metodoPago != null) 'metodo_pago': metodoPago,
        if (notas != null) 'notas': notas,
      };
      
      final response = await post(ApiConfig.ordenesEndpoint, body);
      print('✅ Orden creada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error creando orden: $e');
      rethrow;
    }
  }
  
  /// Actualizar estado de una orden
  Future<Map<String, dynamic>> actualizarEstadoOrden(
    String id,
    String nuevoEstado,
  ) async {
    print('🛒 Actualizando estado de orden $id...');
    
    try {
      final body = {'estado': nuevoEstado};
      final response = await put('${ApiConfig.ordenesEndpoint}/$id/estado', body);
      print('✅ Estado de orden actualizado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando estado de orden: $e');
      rethrow;
    }
  }
  
  /// Cancelar una orden
  Future<Map<String, dynamic>> cancelarOrden(
    String id, {
    String? motivoCancelacion,
  }) async {
    print('🛒 Cancelando orden $id...');
    
    try {
      final body = {
        'estado': 'CANCELADA',
        if (motivoCancelacion != null) 'motivo_cancelacion': motivoCancelacion,
      };
      
      final response = await put('${ApiConfig.ordenesEndpoint}/$id', body);
      print('✅ Orden cancelada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error cancelando orden: $e');
      rethrow;
    }
  }
  
  /// CARRITO DE COMPRAS
  
  /// Obtener contenido del carrito
  Future<Map<String, dynamic>> getCarrito() async {
    print('🛍️ Obteniendo carrito...');
    
    try {
      final response = await get(ApiConfig.carritoEndpoint);
      print('✅ Carrito obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo carrito: $e');
      rethrow;
    }
  }
  
  /// Agregar producto al carrito
  Future<Map<String, dynamic>> agregarAlCarrito({
    required String productoId,
    required int cantidad,
    Map<String, dynamic>? opciones,
  }) async {
    print('🛍️ Agregando producto $productoId al carrito...');
    
    try {
      final body = {
        'producto_id': productoId,
        'cantidad': cantidad,
        if (opciones != null) 'opciones': opciones,
      };
      
      final response = await post('${ApiConfig.carritoEndpoint}/agregar', body);
      print('✅ Producto agregado al carrito exitosamente');
      return response;
    } catch (e) {
      print('❌ Error agregando producto al carrito: $e');
      rethrow;
    }
  }
  
  /// Actualizar cantidad de producto en carrito
  Future<Map<String, dynamic>> actualizarCantidadCarrito({
    required String itemId,
    required int nuevaCantidad,
  }) async {
    print('🛍️ Actualizando cantidad en carrito...');
    
    try {
      final body = {'cantidad': nuevaCantidad};
      final response = await put('${ApiConfig.carritoEndpoint}/item/$itemId', body);
      print('✅ Cantidad actualizada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando cantidad: $e');
      rethrow;
    }
  }
  
  /// Eliminar producto del carrito
  Future<Map<String, dynamic>> eliminarDelCarrito(String itemId) async {
    print('🛍️ Eliminando item $itemId del carrito...');
    
    try {
      final response = await delete('${ApiConfig.carritoEndpoint}/item/$itemId');
      print('✅ Item eliminado del carrito exitosamente');
      return response;
    } catch (e) {
      print('❌ Error eliminando item del carrito: $e');
      rethrow;
    }
  }
  
  /// Vaciar carrito completamente
  Future<Map<String, dynamic>> vaciarCarrito() async {
    print('🛍️ Vaciando carrito...');
    
    try {
      final response = await delete('${ApiConfig.carritoEndpoint}/vaciar');
      print('✅ Carrito vaciado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error vaciando carrito: $e');
      rethrow;
    }
  }
  
  /// Procesar checkout del carrito
  Future<Map<String, dynamic>> procesarCheckout({
    String? direccionId,
    required String metodoPago,
    String? cuponDescuento,
    String? notas,
  }) async {
    print('💳 Procesando checkout...');
    
    try {
      final body = {
        if (direccionId != null) 'direccion_id': direccionId,
        'metodo_pago': metodoPago,
        if (cuponDescuento != null) 'cupon_descuento': cuponDescuento,
        if (notas != null) 'notas': notas,
      };
      
      final response = await post('${ApiConfig.carritoEndpoint}/checkout', body);
      print('✅ Checkout procesado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error procesando checkout: $e');
      rethrow;
    }
  }
  
  /// DETALLES DE ÓRDENES
  
  /// Obtener detalles de una orden
  Future<Map<String, dynamic>> getDetallesOrden(String ordenId) async {
    print('📋 Obteniendo detalles de orden $ordenId...');
    
    try {
      final response = await get('${ApiConfig.detalleOrdenesEndpoint}?orden_id=$ordenId');
      print('✅ Detalles de orden obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo detalles de orden: $e');
      rethrow;
    }
  }
  
  /// PAGOS Y TRANSACCIONES
  
  /// Obtener transacciones de pago del usuario
  Future<Map<String, dynamic>> getTransaccionesPago({
    String? ordenId,
    String? estado,
    int? page,
  }) async {
    print('💳 Obteniendo transacciones de pago...');
    
    try {
      String endpoint = ApiConfig.transaccionesPagoEndpoint;
      List<String> params = [];
      
      if (ordenId != null) params.add('orden_id=$ordenId');
      if (estado != null) params.add('estado=$estado');
      if (page != null) params.add('page=$page');
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await get(endpoint);
      print('✅ Transacciones obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo transacciones: $e');
      rethrow;
    }
  }
  
  /// DIRECCIONES DE ENTREGA
  
  /// Obtener direcciones del usuario
  Future<Map<String, dynamic>> getDirecciones() async {
    print('📍 Obteniendo direcciones...');
    
    try {
      final response = await get(ApiConfig.direccionesEndpoint);
      print('✅ Direcciones obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo direcciones: $e');
      rethrow;
    }
  }
  
  /// Agregar nueva dirección
  Future<Map<String, dynamic>> agregarDireccion({
    required String nombre,
    required String direccion,
    required String ciudad,
    required String codigoPostal,
    String? telefono,
    String? instruccionesEntrega,
    bool? esPrincipal,
  }) async {
    print('📍 Agregando nueva dirección...');
    
    try {
      final body = {
        'nombre': nombre,
        'direccion': direccion,
        'ciudad': ciudad,
        'codigo_postal': codigoPostal,
        if (telefono != null) 'telefono': telefono,
        if (instruccionesEntrega != null) 'instrucciones_entrega': instruccionesEntrega,
        if (esPrincipal != null) 'es_principal': esPrincipal,
      };
      
      final response = await post(ApiConfig.direccionesEndpoint, body);
      print('✅ Dirección agregada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error agregando dirección: $e');
      rethrow;
    }
  }
  
  /// Actualizar dirección
  Future<Map<String, dynamic>> actualizarDireccion(
    String id,
    Map<String, dynamic> data,
  ) async {
    print('📍 Actualizando dirección $id...');
    
    try {
      final response = await put('${ApiConfig.direccionesEndpoint}/$id', data);
      print('✅ Dirección actualizada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando dirección: $e');
      rethrow;
    }
  }
  
  /// Eliminar dirección
  Future<Map<String, dynamic>> eliminarDireccion(String id) async {
    print('📍 Eliminando dirección $id...');
    
    try {
      final response = await delete('${ApiConfig.direccionesEndpoint}/$id');
      print('✅ Dirección eliminada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error eliminando dirección: $e');
      rethrow;
    }
  }
  
  /// ESTADÍSTICAS DE COMPRAS
  
  /// Obtener estadísticas de compras del usuario
  Future<Map<String, dynamic>> getEstadisticasCompras() async {
    print('📊 Obteniendo estadísticas de compras...');
    
    try {
      final response = await get('${ApiConfig.ordenesEndpoint}/estadisticas');
      print('✅ Estadísticas obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo estadísticas: $e');
      rethrow;
    }
  }
  
  /// Obtener historial de compras
  Future<Map<String, dynamic>> getHistorialCompras({
    int limit = 20,
    int offset = 0,
  }) async {
    print('📋 Obteniendo historial de compras...');
    
    try {
      String endpoint = '${ApiConfig.ordenesEndpoint}/historial';
      endpoint += '?limit=$limit&offset=$offset';
      
      final response = await get(endpoint);
      print('✅ Historial obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo historial: $e');
      rethrow;
    }
  }
}