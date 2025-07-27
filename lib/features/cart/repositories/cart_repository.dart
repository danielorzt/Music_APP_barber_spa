// lib/features/cart/repositories/cart_repository.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';
import '../models/cart_item_model.dart';

class CartRepository {
  final ApiService _apiService = ApiService();
  static const String _cartKey = 'cart_items';

  // Guardar carrito localmente
  Future<void> saveCartToLocal(List<CartItem> cartItems) async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(_cartKey, jsonEncode(cartJson));
  }

  // Obtener carrito local
  Future<List<CartItem>> getCartFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString == null || cartString.isEmpty) {
        return [];
      }

      final List<dynamic> cartJson = jsonDecode(cartString);
      return cartJson.map((item) => CartItem.fromJson(item)).toList();
    } catch (e) {
      return [];
    }
  }

  // Crear orden con carrito actual
  Future<Map<String, dynamic>> createOrder(List<CartItem> cartItems, int userId) async {
    try {
      final data = {
        'items': cartItems.map((item) => item.toJson()).toList(),
        'userId': userId,
      };

      final response = await _apiService.post('/saveOrder', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Procesar pago con PayPal
  Future<String> processPayPalPayment(int orderId) async {
    try {
      final response = await _apiService.post('/paypal/create', data: {'orderId': orderId});
      return response['approval_url'];
    } catch (e) {
      rethrow;
    }
  }

  // Procesar pago con MercadoPago
  Future<String> processMercadoPagoPayment(int orderId, double amount) async {
    try {
      final response = await _apiService.post('/mercadopago/process_payment',
          data: {
            'order_id': orderId,
            'transaction_amount': amount
          }
      );
      return response['status'];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CartItem>> getCartItems() async {
    // final response = await _apiService.get('/cart');
    // return (response['items'] as List)
    //     .map((item) => CartItem.fromJson(item))
    //     .toList();
    return []; // Devolver una lista vacía
  }

  Future<void> addToCart(String productId, int quantity) async {
    // await _apiService.post('/cart', data: {
    //   'productId': productId,
    //   'quantity': quantity,
    // });
  }

  Future<void> removeFromCart(String itemId) async {
    // await _apiService.delete('/cart/$itemId');
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    // await _apiService.put('/cart/$itemId', data: {'quantity': quantity});
  }
}