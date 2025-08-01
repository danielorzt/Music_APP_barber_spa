// lib/features/cart/providers/cart_provider.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  final String type; // 'product' o 'service'
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.type,
    this.quantity = 1,
  });

  double get total => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    String? type,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  static const String _cartKey = 'cart_items';
  bool _shouldAnimate = false;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get shouldAnimate => _shouldAnimate;

  // Cargar carrito desde SharedPreferences
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      
      if (cartJson != null) {
        final List<dynamic> cartList = jsonDecode(cartJson);
        _items.clear();
        
        for (final item in cartList) {
          _items.add(CartItem(
            id: item['id'],
            name: item['name'],
            price: item['price'].toDouble(),
            image: item['image'],
            type: item['type'],
            quantity: item['quantity'],
          ));
        }
        
        notifyListeners();
        print('✅ Carrito cargado: ${_items.length} items');
      }
    } catch (e) {
      print('❌ Error cargando carrito: $e');
    }
  }

  // Guardar carrito en SharedPreferences
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartList = _items.map((item) => {
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'image': item.image,
        'type': item.type,
        'quantity': item.quantity,
      }).toList();
      
      await prefs.setString(_cartKey, jsonEncode(cartList));
      print('✅ Carrito guardado: ${_items.length} items');
    } catch (e) {
      print('❌ Error guardando carrito: $e');
    }
  }

  int get itemCount => _items.length;

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.total);
  }

  double get tax => subtotal * 0.16; // 16% IVA

  double get shipping => subtotal > 1000 ? 0.0 : 50.0; // Envío gratis por compras > $1000

  double get total => subtotal + tax + shipping;

  bool get isEmpty => _items.isEmpty;

  // Agregar producto al carrito y navegar automáticamente
  void addItemAndNavigate(String id, String name, double price, String image, String type, BuildContext context) {
    addItem(id, name, price, image, type);
    
    // Navegar automáticamente al carrito después de agregar un item
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.go('/cart');
      }
    });
  }

  // Agregar producto al carrito
  void addItem(String id, String name, double price, String image, String type) {
    final existingIndex = _items.indexWhere((item) => item.id == id && item.type == type);
    
    if (existingIndex >= 0) {
      // Si ya existe, aumentar cantidad
      _items[existingIndex].quantity++;
    } else {
      // Si no existe, agregar nuevo item
      _items.add(CartItem(
        id: id,
        name: name,
        price: price,
        image: image,
        type: type,
      ));
    }
    
    // Trigger animation
    _shouldAnimate = true;
    notifyListeners();
    
    // Reset animation flag after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      _shouldAnimate = false;
      notifyListeners();
    });
    
    _saveCart(); // Guardar automáticamente
  }

  // Actualizar cantidad
  void updateQuantity(String id, String type, int quantity) {
    final index = _items.indexWhere((item) => item.id == id && item.type == type);
    
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
      _saveCart(); // Guardar automáticamente
    }
  }

  // Eliminar item del carrito
  void removeItem(String id, String type) {
    final index = _items.indexWhere((item) => item.id == id && item.type == type);
    
    if (index >= 0) {
      _items.removeAt(index);
      notifyListeners();
      _saveCart(); // Guardar automáticamente
    }
  }

  // Limpiar carrito
  void clear() {
    _items.clear();
    notifyListeners();
    _saveCart(); // Guardar automáticamente
  }

  // Verificar si un item está en el carrito
  bool isInCart(String id, String type) {
    return _items.any((item) => item.id == id && item.type == type);
  }

  // Obtener cantidad de un item
  int getItemQuantity(String id, String type) {
    final item = _items.firstWhere(
      (item) => item.id == id && item.type == type,
      orElse: () => CartItem(id: '', name: '', price: 0, image: '', type: ''),
    );
    return item.id.isNotEmpty ? item.quantity : 0;
  }

  // Navegar al carrito desde cualquier parte de la app
  void navigateToCart(BuildContext context) {
    if (context.mounted) {
      context.go('/cart');
    }
  }

  // Agregar múltiples items de una vez
  void addMultipleItems(List<CartItem> items) {
    for (final item in items) {
      addItem(item.id, item.name, item.price, item.image, item.type);
    }
  }

  // Obtener items por tipo
  List<CartItem> getItemsByType(String type) {
    return _items.where((item) => item.type == type).toList();
  }

  // Obtener total por tipo
  double getTotalByType(String type) {
    return _items
        .where((item) => item.type == type)
        .fold(0.0, (sum, item) => sum + item.total);
  }

  // Verificar si el carrito tiene items de un tipo específico
  bool hasItemsOfType(String type) {
    return _items.any((item) => item.type == type);
  }

  // Obtener resumen del carrito
  Map<String, dynamic> getCartSummary() {
    final products = getItemsByType('product');
    final services = getItemsByType('service');
    
    return {
      'total_items': itemCount,
      'products_count': products.length,
      'services_count': services.length,
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'total': total,
      'has_products': products.isNotEmpty,
      'has_services': services.isNotEmpty,
    };
  }

  // Validar carrito antes del checkout
  bool isValidForCheckout() {
    // Verificar que hay al menos un item
    if (_items.isEmpty) return false;
    
    // Verificar que todos los items tienen información válida
    for (final item in _items) {
      if (item.name.isEmpty || item.price <= 0) {
        return false;
      }
    }
    
    return true;
  }

  // Obtener items para checkout
  List<Map<String, dynamic>> getItemsForCheckout() {
    return _items.map((item) => {
      'id': item.id,
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
      'type': item.type,
      'total': item.total,
    }).toList();
  }
}