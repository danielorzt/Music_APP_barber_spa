// lib/features/cart/repositories/cart_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_app/features/cart/models/cart_item_model.dart';

class CartRepository {
  static const String _cartKey = 'user_cart';

  // Obtener items del carrito desde almacenamiento local
  Future<List<CartItem>> getCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString == null || cartString.isEmpty) {
        return [];
      }

      final List<dynamic> cartData = jsonDecode(cartString);
      return cartData.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      print('Error al obtener carrito: $e');
      return [];
    }
  }

  // Guardar items en el carrito
  Future<bool> saveCartItems(List<CartItem> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = items.map((item) => item.toJson()).toList();

      return await prefs.setString(_cartKey, jsonEncode(cartData));
    } catch (e) {
      print('Error al guardar carrito: $e');
      return false;
    }
  }

  // Añadir item al carrito
  Future<bool> addCartItem(CartItem item) async {
    final items = await getCartItems();
    items.add(item);
    return saveCartItems(items);
  }

  // Eliminar item del carrito
  Future<bool> removeCartItem(int itemId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.id == itemId);
    return saveCartItems(items);
  }

  // Actualizar cantidad de un item
  Future<bool> updateCartItemQuantity(int itemId, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: quantity);
      return saveCartItems(items);
    }

    return false;
  }

  // Limpiar carrito
  Future<bool> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_cartKey);
    } catch (e) {
      print('Error al limpiar carrito: $e');
      return false;
    }
  }
}