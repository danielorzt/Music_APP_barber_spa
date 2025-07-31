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
    
    try {
      final result = await get(endpoint);
      
      if (result['success']) {
        final ordenes = extractList(result['data'], 'ordenes');
        print('✅ ${ordenes.length} órdenes obtenidas de la API');
        
        return {
          'success': true,
          'ordenes': ordenes,
          'total': result['data']['total'] ?? ordenes.length,
          'current_page': result['data']['current_page'] ?? 1,
          'last_page': result['data']['last_page'] ?? 1,
        };
      }
      
      return result;
    } catch (e) {
      print('❌ Error obteniendo órdenes: $e');
      print('📋 Usando datos mock para órdenes...');
      
      // Datos mock para órdenes
      return {
        'success': true,
        'ordenes': [
          {
            'id': 1,
            'numero_orden': 'ORD0001',
            'fecha_orden': '2025-07-20 10:00:00',
            'fecha_recibida': '2025-07-20 10:15:00',
            'subtotal': 150.00,
            'descuento_total': 0.00,
            'impuestos_total': 24.00,
            'total_orden': 174.00,
            'estado_orden': 'COMPLETADA',
            'notas_orden': 'Compra de productos para cabello.',
            'detalles': [
              {
                'id': 1,
                'producto_id': 1,
                'nombre_producto': 'Aceite para Barba Premium',
                'cantidad': 2,
                'precio_unitario': 75.00,
                'subtotal': 150.00,
              }
            ],
          },
          {
            'id': 2,
            'numero_orden': 'ORD0002',
            'fecha_orden': '2025-07-21 11:30:00',
            'fecha_recibida': '2025-07-21 11:45:00',
            'subtotal': 200.00,
            'descuento_total': 10.00,
            'impuestos_total': 32.00,
            'total_orden': 222.00,
            'estado_orden': 'COMPLETADA',
            'notas_orden': 'Crema facial y serum.',
            'detalles': [
              {
                'id': 2,
                'producto_id': 2,
                'nombre_producto': 'Crema Facial Hidratante',
                'cantidad': 1,
                'precio_unitario': 120.00,
                'subtotal': 120.00,
              },
              {
                'id': 3,
                'producto_id': 3,
                'nombre_producto': 'Serum Antienvejecimiento',
                'cantidad': 1,
                'precio_unitario': 80.00,
                'subtotal': 80.00,
              }
            ],
          },
          {
            'id': 3,
            'numero_orden': 'ORD0003',
            'fecha_orden': '2025-07-22 09:00:00',
            'fecha_recibida': '2025-07-22 09:10:00',
            'subtotal': 75.00,
            'descuento_total': 0.00,
            'impuestos_total': 12.00,
            'total_orden': 87.00,
            'estado_orden': 'COMPLETADA',
            'notas_orden': 'Champú y acondicionador.',
            'detalles': [
              {
                'id': 4,
                'producto_id': 4,
                'nombre_producto': 'Champú Profesional',
                'cantidad': 1,
                'precio_unitario': 45.00,
                'subtotal': 45.00,
              },
              {
                'id': 5,
                'producto_id': 5,
                'nombre_producto': 'Acondicionador Profesional',
                'cantidad': 1,
                'precio_unitario': 30.00,
                'subtotal': 30.00,
              }
            ],
          },
          {
            'id': 4,
            'numero_orden': 'ORD0004',
            'fecha_orden': '2025-07-22 14:00:00',
            'fecha_recibida': '2025-07-22 14:20:00',
            'subtotal': 300.00,
            'descuento_total': 20.00,
            'impuestos_total': 48.00,
            'total_orden': 328.00,
            'estado_orden': 'COMPLETADA',
            'notas_orden': 'Kit de afeitado premium.',
            'detalles': [
              {
                'id': 6,
                'producto_id': 6,
                'nombre_producto': 'Kit de Afeitado Premium',
                'cantidad': 1,
                'precio_unitario': 300.00,
                'subtotal': 300.00,
              }
            ],
          },
          {
            'id': 5,
            'numero_orden': 'ORD0005',
            'fecha_orden': '2025-07-23 10:30:00',
            'fecha_recibida': '2025-07-23 10:45:00',
            'subtotal': 120.00,
            'descuento_total': 0.00,
            'impuestos_total': 19.20,
            'total_orden': 139.20,
            'estado_orden': 'PENDIENTE',
            'notas_orden': 'Entrega a domicilio.',
            'detalles': [
              {
                'id': 7,
                'producto_id': 7,
                'nombre_producto': 'Gel para Cabello',
                'cantidad': 2,
                'precio_unitario': 60.00,
                'subtotal': 120.00,
              }
            ],
          },
        ],
        'total': 5,
        'current_page': 1,
        'last_page': 1,
        'message': 'Datos mock - API no disponible',
      };
    }
  }
  
  /// Obtener una orden específica por ID
  Future<Map<String, dynamic>> getOrder(String id) async {
    print('🔍 Obteniendo orden ID: $id');
    
    try {
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
    } catch (e) {
      print('❌ Error obteniendo orden: $e');
      
      // Buscar en datos mock
      final allOrders = await getUserOrders();
      if (allOrders['success']) {
        final ordenes = allOrders['ordenes'] as List;
        final orden = ordenes.firstWhere(
          (orden) => orden['id'].toString() == id,
          orElse: () => throw Exception('Orden no encontrada'),
        );
        
        return {
          'success': true,
          'orden': orden,
        };
      }
      
      rethrow;
    }
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
    
    try {
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
    } catch (e) {
      print('❌ Error creando orden: $e');
      throw Exception('Error al crear la orden: $e');
    }
  }
  
  /// Actualizar estado de una orden
  Future<Map<String, dynamic>> updateOrderStatus(String orderId, String newStatus) async {
    print('🔄 Actualizando estado de orden $orderId a $newStatus...');
    
    try {
      final data = {'estado_orden': newStatus};
      final result = await put('${ApiConfig.ordenesEndpoint}/$orderId', data);
      
      if (result['success']) {
        print('✅ Estado de orden actualizado exitosamente');
        return result;
      }
      
      return result;
    } catch (e) {
      print('❌ Error actualizando estado de orden: $e');
      throw Exception('Error al actualizar el estado de la orden: $e');
    }
  }
  
  /// Cancelar una orden
  Future<Map<String, dynamic>> cancelOrder(String orderId, String motivo) async {
    print('❌ Cancelando orden $orderId...');
    
    try {
      final data = {
        'estado_orden': 'CANCELADA',
        'motivo_cancelacion': motivo,
      };
      
      final result = await put('${ApiConfig.ordenesEndpoint}/$orderId', data);
      
      if (result['success']) {
        print('✅ Orden cancelada exitosamente');
        return result;
      }
      
      return result;
    } catch (e) {
      print('❌ Error cancelando orden: $e');
      throw Exception('Error al cancelar la orden: $e');
    }
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
    
    try {
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
    } catch (e) {
      print('❌ Error calculando total: $e');
      print('📋 Usando cálculo mock...');
      
      // Cálculo mock
      double subtotal = 0;
      for (final producto in productos) {
        subtotal += (producto['precio'] ?? 0) * (producto['cantidad'] ?? 1);
      }
      
      final descuento = cuponDescuento != null ? subtotal * 0.1 : 0; // 10% descuento
      final impuestos = (subtotal - descuento) * 0.16; // 16% IVA
      final envio = subtotal > 1000 ? 0 : 50; // Envío gratis por compras > $1000
      final total = subtotal - descuento + impuestos + envio;
      
      return {
        'success': true,
        'calculo': {
          'subtotal': subtotal,
          'descuento': descuento,
          'impuestos': impuestos,
          'envio': envio,
          'total': total,
        },
        'message': 'Cálculo mock - API no disponible',
      };
    }
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
    print('📦 Rastreando orden $id...');
    
    try {
      final result = await get('${ApiConfig.ordenesEndpoint}/$id/track');
      
      if (result['success']) {
        final tracking = extractData(result['data'], 'tracking') ?? result['data'];
        print('✅ Información de rastreo obtenida');
        
        return {
          'success': true,
          'tracking': tracking,
        };
      }
      
      return result;
    } catch (e) {
      print('❌ Error rastreando orden: $e');
      
      // Datos mock para rastreo
      return {
        'success': true,
        'tracking': {
          'estado': 'EN_CAMINO',
          'ubicacion': 'Centro de Distribución',
          'fecha_estimada': '2025-07-25',
          'hora_estimada': '14:00',
          'mensaje': 'Tu pedido está en camino',
        },
        'message': 'Datos mock - API no disponible',
      };
    }
  }
} 