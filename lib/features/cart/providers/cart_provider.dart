// lib/features/cart/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../repositories/cart_repository.dart';
import '../../products/models/product_model.dart';

class CartProvider with ChangeNotifier {
  final CartRepository _repository = CartRepository();
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get itemCount => _items.length;
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.total);

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _repository.getCartFromLocal();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addItem(Product product, double quantity) async {
    // Buscar si el producto ya está en el carrito
    final existingItemIndex = _items.indexWhere(
            (item) => item.productoId == product.id
    );

    if (existingItemIndex >= 0) {
      // Actualizar cantidad si ya existe
      final existingItem = _items[existingItemIndex];
      final newQuantity = existingItem.cantidad + quantity;
      final newTotal = product.precio * newQuantity;

      _items[existingItemIndex] = CartItem(
        id: existingItem.id,
        nombre: product.nombreproducto,
        cantidad: newQuantity,
        precio: product.precio,
        total: newTotal,
        productoId: product.id!,
      );
    } else {
      // Agregar nuevo item
      _items.add(CartItem(
        nombre: product.nombreproducto,
        cantidad: quantity,
        precio: product.precio,
        total: product.precio * quantity,
        productoId: product.id!,
      ));
    }

    await _repository.saveCartToLocal(_items);
    notifyListeners();
  }

  Future<void> removeItem(int productId) async {
    _items.removeWhere((item) => item.productoId == productId);
    await _repository.saveCartToLocal(_items);
    notifyListeners();
  }

  Future<void> updateItemQuantity(int productId, double quantity) async {
    final index = _items.indexWhere((item) => item.productoId == productId);

    if (index >= 0) {
      final item = _items[index];
      _items[index] = CartItem(
        id: item.id,
        nombre: item.nombre,
        cantidad: quantity,
        precio: item.precio,
        total: item.precio * quantity,
        productoId: item.productoId,
      );

      await _repository.saveCartToLocal(_items);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items = [];
    await _repository.saveCartToLocal(_items);
    notifyListeners();
  }

  Future<Map<String, dynamic>?> checkout(int userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repository.createOrder(_items, userId);
      // Limpiar el carrito después de crear la orden
      await clearCart();
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<String?> payWithPayPal(int orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final paypalUrl = await _repository.processPayPalPayment(orderId);
      _isLoading = false;
      notifyListeners();
      return paypalUrl;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<String?> payWithMercadoPago(int orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final status = await _repository.processMercadoPagoPayment(orderId, totalAmount);
      _isLoading = false;
      notifyListeners();
      return status;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}