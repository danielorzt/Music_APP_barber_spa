import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para gestionar órdenes/compras
class OrdersApiService extends BaseApiService {
  
  /// Construir endpoint con parámetros de consulta
  String buildEndpointWithParams(String baseEndpoint, Map<String, dynamic> params) {
    if (params.isEmpty) return baseEndpoint;
    
    final queryParams = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return '$baseEndpoint?$queryParams';
  }
  
  /// Obtener todas las órdenes del usuario autenticado
  Future<Map<String, dynamic>> getUserOrders({
    int? page,
    int? limit,
    String? estado,
    String? fechaInicio,
    String? fechaFin,
  }) async {
    final params = <String, dynamic>{};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;
    if (estado != null) params['estado'] = estado;
    if (fechaInicio != null) params['fecha_inicio'] = fechaInicio;
    if (fechaFin != null) params['fecha_fin'] = fechaFin;
    
    final endpoint = buildEndpointWithParams(ApiConfig.ordenesEndpoint, params);
    
    print('🔍 Obteniendo órdenes del usuario...');
    final result = await get(endpoint);
    
    if (result['success']) {
      final ordenes = extractList(result['data'], 'ordenes');
      print('✅ ${ordenes.length} órdenes obtenidas');
      
      return {
        'success': true,
        'ordenes': ordenes,
        'total': result['data']['total'] ?? ordenes.length,
        'current_page': result['data']['current_page'] ?? 1,
        'last_page': result['data']['last_page'] ?? 1,
      };
    }
    
    return result;
  }
  
  /// Obtener una orden específica por ID
  Future<Map<String, dynamic>> getOrder(String id) async {
    print('🔍 Obteniendo orden ID: $id');
    final result = await get('${ApiConfig.ordenesEndpoint}/$id');
    
    if (result['success']) {
      final orden = extractData(result['data'], 'orden') ?? result['data'];
      print('✅ Orden obtenida: ${orden['numero_orden'] ?? 'Sin número'}');
      
      return {
        'success': true,
        'orden': orden,
      };
    }
    
    return result;
  }
  
  /// Crear una nueva orden
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> productos,
    required String direccionEnvioId,
    required String metodoPago,
    String? notasEspeciales,
    String? cuponDescuento,
  }) async {
    final data = {
      'productos': productos,
      'direccion_envio_id': direccionEnvioId,
      'metodo_pago': metodoPago,
      if (notasEspeciales != null) 'notas_especiales': notasEspeciales,
      if (cuponDescuento != null) 'cupon_descuento': cuponDescuento,
    };
    
    print('🛒 Creando nueva orden...');
    print('🛒 Productos: ${productos.length} items');
    final result = await post(ApiConfig.ordenesEndpoint, data);
    
    if (result['success']) {
      final orden = extractData(result['data'], 'orden') ?? result['data'];
      print('✅ Orden creada exitosamente');
      
      return {
        'success': true,
        'orden': orden,
        'message': 'Orden creada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Actualizar el estado de una orden
  Future<Map<String, dynamic>> updateOrderStatus(String id, String nuevoEstado) async {
    final data = {
      'estado': nuevoEstado,
    };
    
    print('📝 Actualizando estado de orden ID: $id a $nuevoEstado');
    final result = await put('${ApiConfig.ordenesEndpoint}/$id', data);
    
    if (result['success']) {
      final orden = extractData(result['data'], 'orden') ?? result['data'];
      print('✅ Estado de orden actualizado exitosamente');
      
      return {
        'success': true,
        'orden': orden,
        'message': 'Estado actualizado exitosamente',
      };
    }
    
    return result;
  }
  
  /// Cancelar una orden
  Future<Map<String, dynamic>> cancelOrder(String id, {String? motivoCancelacion}) async {
    final data = {
      'estado': 'CANCELADA',
      if (motivoCancelacion != null) 'motivo_cancelacion': motivoCancelacion,
    };
    
    print('❌ Cancelando orden ID: $id');
    final result = await put('${ApiConfig.ordenesEndpoint}/$id', data);
    
    if (result['success']) {
      print('✅ Orden cancelada exitosamente');
      return {
        'success': true,
        'message': 'Orden cancelada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Obtener detalles de una orden con productos
  Future<Map<String, dynamic>> getOrderDetails(String id) async {
    print('🔍 Obteniendo detalles completos de orden ID: $id');
    final result = await get('${ApiConfig.detalleOrdenesEndpoint}?orden_id=$id');
    
    if (result['success']) {
      final detalles = extractList(result['data'], 'detalles');
      print('✅ ${detalles.length} detalles de productos obtenidos');
      
      return {
        'success': true,
        'detalles': detalles,
      };
    }
    
    return result;
  }
  
  /// Calcular total del carrito antes de crear orden
  Future<Map<String, dynamic>> calculateCartTotal({
    required List<Map<String, dynamic>> productos,
    String? cuponDescuento,
    String? direccionEnvioId,
  }) async {
    final data = {
      'productos': productos,
      if (cuponDescuento != null) 'cupon_descuento': cuponDescuento,
      if (direccionEnvioId != null) 'direccion_envio_id': direccionEnvioId,
    };
    
    print('💰 Calculando total del carrito...');
    // Este endpoint podría ser una extensión personalizada en tu API
    final result = await post('${ApiConfig.ordenesEndpoint}/calculate', data);
    
    if (result['success']) {
      final calculo = extractData(result['data'], 'calculo') ?? result['data'];
      print('✅ Total calculado exitosamente');
      
      return {
        'success': true,
        'calculo': calculo,
      };
    }
    
    return result;
  }
  
  /// Obtener órdenes por estado
  Future<Map<String, dynamic>> getOrdersByStatus(String estado) async {
    return getUserOrders(estado: estado);
  }
  
  /// Obtener historial de compras (órdenes completadas)
  Future<Map<String, dynamic>> getPurchaseHistory() async {
    return getUserOrders(estado: 'COMPLETADA');
  }
  
  /// Obtener órdenes pendientes
  Future<Map<String, dynamic>> getPendingOrders() async {
    final estados = ['PENDIENTE', 'PROCESANDO', 'EN_CAMINO'];
    
    print('🔍 Obteniendo órdenes pendientes...');
    final allResults = <Map<String, dynamic>>[];
    
    for (final estado in estados) {
      final result = await getUserOrders(estado: estado);
      if (result['success']) {
        allResults.addAll(List<Map<String, dynamic>>.from(result['ordenes']));
      }
    }
    
    return {
      'success': true,
      'ordenes': allResults,
      'total': allResults.length,
    };
  }
  
  /// Verificar estado de entrega
  Future<Map<String, dynamic>> trackOrder(String id) async {
    print('📦 Rastreando orden ID: $id');
    // Este endpoint podría ser una extensión personalizada para tracking
    final result = await get('${ApiConfig.ordenesEndpoint}/$id/tracking');
    
    if (result['success']) {
      final tracking = extractData(result['data'], 'tracking') ?? result['data'];
      print('✅ Información de rastreo obtenida');
      
      return {
        'success': true,
        'tracking': tracking,
      };
    }
    
    return result;
  }
  
  /// Solicitar reembolso
  Future<Map<String, dynamic>> requestRefund(String id, {String? motivo}) async {
    final data = {
      'tipo_solicitud': 'REEMBOLSO',
      if (motivo != null) 'motivo': motivo,
    };
    
    print('💸 Solicitando reembolso para orden ID: $id');
    final result = await post('${ApiConfig.ordenesEndpoint}/$id/refund', data);
    
    if (result['success']) {
      print('✅ Solicitud de reembolso enviada exitosamente');
      return {
        'success': true,
        'message': 'Solicitud de reembolso enviada exitosamente',
      };
    }
    
    return result;
  }
  
  /// Confirmar recepción de orden
  Future<Map<String, dynamic>> confirmDelivery(String id) async {
    return updateOrderStatus(id, 'ENTREGADA');
  }
  
  /// Obtener facturación de una orden
  Future<Map<String, dynamic>> getOrderInvoice(String id) async {
    print('🧾 Obteniendo factura de orden ID: $id');
    final result = await get('${ApiConfig.ordenesEndpoint}/$id/invoice');
    
    if (result['success']) {
      final factura = extractData(result['data'], 'factura') ?? result['data'];
      print('✅ Factura obtenida exitosamente');
      
      return {
        'success': true,
        'factura': factura,
      };
    }
    
    return result;
  }
} 