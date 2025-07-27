// import 'package:dio/dio.dart'; // Removido - no está instalado
// import 'package:music_app/core/api/api_client.dart';
// import 'package:music_app/core/constants/api_endpoints.dart';
import 'package:music_app/core/models/producto.dart';

class ProductRepository {
  // final Dio _dio = ApiClient().dio;

  Future<List<Producto>> getProducts() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Datos mock para productos
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
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _dio.get(ApiEndpoints.products);

    //   if (response.statusCode == 200 && response.data != null) {
    //     final List<dynamic> productList = response.data as List<dynamic>;
    //     return productList.map((json) => Producto.fromJson(json)).toList();
    //   } else {
    //     throw Exception('Error al obtener los productos: Respuesta no válida');
    //   }
    // } on DioException catch (e) {
    //   final errorMessage = e.response?.data['message'] ?? 'Error de red. Inténtalo de nuevo.';
    //   throw Exception(errorMessage);
    // } catch (e) {
    //   throw Exception('Ocurrió un error inesperado: ${e.toString()}');
    // }
  }
}
