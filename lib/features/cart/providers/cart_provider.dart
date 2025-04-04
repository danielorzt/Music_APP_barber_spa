// lib/features/cart/providers/cart_provider.dart

import 'package:flutter/material.dart';
import 'package:music_app/features/cart/models/cart_item_model.dart';
import 'package:music_app/features/cart/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;
  List<CartItem> _items = [];

  CartProvider(this._repository) {
    _loadCartItems();
  }

  List<CartItem> get items => _items;

  // Cargar items del repositorio
  Future<void> _loadCartItems() async {
    _items = await _repository.getCartItems();
    notifyListeners();
  }

  // Añadir un item al carrito
  Future<void> addItem(CartItem item) async {
    await _repository.addCartItem(item);
    _loadCartItems();
  }

  // Eliminar un item del carrito
  Future<void> removeItem(int index) async {
    if (index >= 0 && index < _items.length) {
      await _repository.removeCartItem(_items[index].id);
      _loadCartItems();
    }
  }

  // Actualizar cantidad de un item
  Future<void> updateQuantity(int itemId, int quantity) async {
    await _repository.updateCartItemQuantity(itemId, quantity);
    _loadCartItems();
  }

  // Limpiar carrito
  Future<void> clearCart() async {
    await _repository.clearCart();
    _loadCartItems();
  }

  // Calcular total del carrito
  double get total {
    double sum = 0;
    for (var item in _items) {
      sum += item.price * item.quantity;
    }
    return sum;
  }
}