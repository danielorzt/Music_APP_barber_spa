// lib/features/products/providers/products_provider.dart
import 'package:flutter/foundation.dart';
import '../../../core/models/producto.dart';
import '../../../core/services/bmspa_api_service.dart';

class ProductsProvider with ChangeNotifier {
  final BMSPAApiService _apiService = BMSPAApiService();
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
      _products = await _apiService.getProductos();
      print('✅ ProductsProvider: ${_products.length} productos cargados desde API');
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
      // Intentar obtener desde la API
      _selectedProduct = await _apiService.getProducto(id);
      if (_selectedProduct == null) {
        // Si no se encuentra en la API, buscar en la lista local
        _selectedProduct = _products.firstWhere(
          (product) => product.id == id,
          orElse: () => throw Exception('Producto no encontrado'),
        );
      }
      print('✅ ProductsProvider: Producto $id obtenido desde API');
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