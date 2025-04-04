import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String price;
  CartItem(this.name, this.price);
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(String name, String price) {
    _items.add(CartItem(name, price));
    notifyListeners(); // Actualiza la UI
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  String get total {
    double sum = 0;
    for (var item in _items) {
      sum += double.parse(item.price.replaceAll('\$', ''));
    }
    return '\$${sum.toStringAsFixed(2)}';
  }
}