import 'dart:convert';
import 'dart:io';

void main() async {
  print('🔍 === TESTING LARAVEL API ENDPOINTS ===\n');

  const String baseUrl = 'http://192.168.39.148:8000/api';
  
  // Lista completa de endpoints a probar
  final endpoints = [
    // Autenticación
    '/Client_usuarios/auth/login',
    '/Client_usuarios/auth/register',
    '/Client_usuarios/auth/logout',
    
    // Catálogo
    '/Catalog_servicios/servicios',
    '/Catalog_productos/productos',
    '/Admin_categorias/categorias',
    '/Admin_sucursales/sucursales',
    '/Admin_personal/personal',
    '/Admin_promociones/promociones',
    
    // Agendamientos
    '/Scheduling_agendamientos/agendamientos',
    '/Scheduling_horarios_sucursal/horarios',
    '/Scheduling_agendamientos/disponibilidad',
    
    // Órdenes
    '/Client_ordenes/ordenes',
    '/Client_ordenes/carrito',
    
    // Usuario
    '/Client_usuarios/perfil',
    '/Client_direcciones/direcciones',
    '/Client_reseñas/reseñas',
    
    // Pagos
    '/Payments_transacciones_pago/transacciones',
  ];

  print('📍 Base URL: $baseUrl\n');

  for (final endpoint in endpoints) {
    await testEndpoint(baseUrl + endpoint, endpoint);
  }

  print('\n🎯 === TEST COMPLETED ===');
}

Future<void> testEndpoint(String fullUrl, String endpoint) async {
  print('📍 Testing: $endpoint');
  
  try {
    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(fullUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');
    
    final response = await request.close();
    
    print('📡 Status: ${response.statusCode}');
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ AVAILABLE: $endpoint');
    } else if (response.statusCode == 404) {
      print('❌ NOT FOUND: $endpoint');
    } else if (response.statusCode == 401) {
      print('🔐 UNAUTHORIZED (needs auth): $endpoint');
    } else if (response.statusCode == 405) {
      print('⚠️ METHOD NOT ALLOWED (needs POST): $endpoint');
    } else {
      print('⚠️ OTHER STATUS (${response.statusCode}): $endpoint');
    }
  } catch (e) {
    print('❌ ERROR: $endpoint - $e');
  }
  
  print('---');
} 