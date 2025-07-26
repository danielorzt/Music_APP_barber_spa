// lib/features/products/repositories/products_repository.dart
import '../../../core/services/api_service.dart';
import '../models/product_model.dart';

class ProductsRepository {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _apiService.get('/products');
      return (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _apiService.get('/products/$id');
      return Product.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Para administradores
  Future<Product> createProduct(Product product) async {
    try {
      final response = await _apiService.post('/products', data: product.toJson());
      return Product.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Para administradores
  Future<Product> updateProduct(Product product) async {
    try {
      final response = await _apiService.put('/products/${product.id}', data: product.toJson());
      return Product.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Para administradores
  Future<void> deleteProduct(int id) async {
    try {
      await _apiService.delete('/products/$id');
    } catch (e) {
      rethrow;
    }
  }
}