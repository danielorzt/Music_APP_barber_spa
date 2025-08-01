import 'dart:convert';
import 'package:dio/dio.dart';

void main() async {
  print('🧪 Iniciando pruebas de endpoints de la API...');
  
  final dio = Dio();
  dio.options.baseUrl = 'https://bc3996b129b5.ngrok-free.app/api';
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  
  // Endpoints a probar
  final endpoints = [
    '/Catalog_productos/productos',
    '/Catalog_servicios/servicios',
    '/Admin_sucursales/sucursales',
    '/Admin_personal/personal',
    '/Admin_categorias/categorias',
    '/Admin_promociones/promociones',
  ];
  
  for (final endpoint in endpoints) {
    print('\n🔍 Probando endpoint: $endpoint');
    try {
      final response = await dio.get(endpoint);
      print('✅ Status: ${response.statusCode}');
      print('📄 Datos: ${jsonEncode(response.data).substring(0, 500)}...');
      
      if (response.data is List) {
        print('📊 Cantidad de elementos: ${response.data.length}');
        if (response.data.isNotEmpty) {
          print('📋 Primer elemento: ${jsonEncode(response.data.first)}');
        }
      } else if (response.data is Map) {
        if (response.data['data'] is List) {
          print('📊 Cantidad de elementos en data: ${response.data['data'].length}');
          if (response.data['data'].isNotEmpty) {
            print('📋 Primer elemento en data: ${jsonEncode(response.data['data'].first)}');
          }
        }
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }
  
  print('\n✅ Pruebas completadas');
} 