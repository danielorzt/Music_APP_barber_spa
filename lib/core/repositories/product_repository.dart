import 'package:dio/dio.dart';
import 'package:music_app/core/api/api_client.dart';
import 'package:music_app/core/constants/api_endpoints.dart';
import 'package:music_app/core/models/producto.dart';

class ProductRepository {
  final Dio _dio = ApiClient().dio;

  Future<List<Producto>> getProducts() async {
    try {
      final response = await _dio.get(ApiEndpoints.products);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> productList = response.data as List<dynamic>;
        return productList.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener los productos: Respuesta no válida');
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'Error de red. Inténtalo de nuevo.';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Ocurrió un error inesperado: ${e.toString()}');
    }
  }
}
