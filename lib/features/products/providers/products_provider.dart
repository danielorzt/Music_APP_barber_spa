// lib/features/products/providers/products_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/models/producto.dart';
import '../../../core/repositories/product_repository.dart';

class ProductsProvider with ChangeNotifier {
  final ProductRepository _repository = ProductRepository();
  List<Producto> _products = [];
  Producto? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Producto> get products => _products;
  Producto? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _repository.getProducts();
      print('✅ ProductsProvider: ${_products.length} productos cargados');
    } catch (e) {
      _error = e.toString();
      print('❌ ProductsProvider: Error cargando productos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Buscar en la lista actual de productos
      _selectedProduct = _products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw Exception('Producto no encontrado'),
      );
    } catch (e) {
      _error = e.toString();
      print('❌ ProductsProvider: Error obteniendo producto: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}