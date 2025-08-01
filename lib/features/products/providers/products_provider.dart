// lib/features/products/providers/products_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

  ProductsProvider() {
    // Usar addPostFrameCallback para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProducts();
    });
  }

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

  // Datos mock para presentación
  List<Producto> _getMockProducts() {
    return [
      Producto(
        id: 1,
        nombre: 'Aceite para Barba Premium',
        descripcion: 'Aceite hidratante para barba con aceites esenciales naturales',
        precio: 25000.0,
        urlImagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      ),
      Producto(
        id: 2,
        nombre: 'Navaja de Afeitar Profesional',
        descripcion: 'Navaja de acero inoxidable para un afeitado perfecto',
        precio: 45000.0,
        urlImagen: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
      ),
      Producto(
        id: 3,
        nombre: 'Crema de Afeitar Suave',
        descripcion: 'Crema hidratante para un afeitado suave y sin irritación',
        precio: 18000.0,
        urlImagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      ),
      Producto(
        id: 4,
        nombre: 'Cepillo para Barba',
        descripcion: 'Cepillo de cerdas naturales para dar forma a la barba',
        precio: 22000.0,
        urlImagen: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
      ),
      Producto(
        id: 5,
        nombre: 'Aceite Esencial de Lavanda',
        descripcion: 'Aceite esencial para relajación y aromaterapia',
        precio: 35000.0,
        urlImagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      ),
    ];
  }
}