import 'package:dio/dio.dart';
import 'package:music_app/core/api/api_client.dart';
import 'package:music_app/core/config/api_config.dart';
import 'package:music_app/core/models/producto.dart';

class ProductRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<Producto>> getProducts() async {
    print('🔍 Obteniendo productos desde API...');
    
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.productosEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> productosData = data['data'];
          final productos = productosData.map((json) => Producto.fromJson(json)).toList();
          
          print('✅ Productos obtenidos exitosamente: ${productos.length} productos');
          return productos;
        } else {
          print('❌ Formato de respuesta inválido');
          return _getMockProducts();
        }
      } else {
        print('❌ Error en la respuesta: ${response.statusCode}');
        return _getMockProducts();
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      print('📋 Usando datos mock...');
      return _getMockProducts();
    } catch (e) {
      print('❌ Error inesperado: $e');
      return _getMockProducts();
    }
  }

  // Datos mock como fallback
  List<Producto> _getMockProducts() {
    return [
      Producto(
        id: 1,
        nombre: 'Aceite para Barba Premium',
        descripcion: 'Aceite hidratante para barba con aceites esenciales naturales',
        precio: 25000.0,
        urlImagen: 'https://picsum.photos/400/400?random=20',
      ),
      Producto(
        id: 2,
        nombre: 'Navaja de Afeitar Profesional',
        descripcion: 'Navaja de acero inoxidable para un afeitado perfecto',
        precio: 45000.0,
        urlImagen: 'https://picsum.photos/400/400?random=21',
      ),
      Producto(
        id: 3,
        nombre: 'Crema de Afeitar Suave',
        descripcion: 'Crema hidratante para un afeitado suave y sin irritación',
        precio: 18000.0,
        urlImagen: 'https://picsum.photos/400/400?random=22',
      ),
      Producto(
        id: 4,
        nombre: 'Cepillo para Barba',
        descripcion: 'Cepillo de cerdas naturales para dar forma a la barba',
        precio: 22000.0,
        urlImagen: 'https://picsum.photos/400/400?random=23',
      ),
      Producto(
        id: 5,
        nombre: 'Aceite Esencial de Lavanda',
        descripcion: 'Aceite esencial para relajación y aromaterapia',
        precio: 35000.0,
        urlImagen: 'https://picsum.photos/400/400?random=24',
      ),
    ];
  }
}
