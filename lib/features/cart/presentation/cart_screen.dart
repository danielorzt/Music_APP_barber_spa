// lib/features/cart/presentation/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Datos mock del carrito
  List<Map<String, dynamic>> _cartItems = [
    {
      'id': '1',
      'name': 'Sérum Vitamina C Premium',
      'price': 450.0,
      'quantity': 1,
      'image': 'https://plus.unsplash.com/premium_photo-1675827055984-3588a445749a?q=80&w=300&auto=format&fit=crop',
      'type': 'product',
    },
    {
      'id': '2',
      'name': 'Crema Hidratante Facial',
      'price': 380.0,
      'quantity': 2,
      'image': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=300&auto=format&fit=crop',
      'type': 'product',
    },
  ];

  double get _subtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double get _tax {
    return _subtotal * 0.16; // 16% IVA
  }

  double get _shipping {
    return _subtotal > 1000 ? 0.0 : 50.0; // Envío gratis por compras > $1000
  }

  double get _total {
    return _subtotal + _tax + _shipping;
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonInterceptor(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mi Carrito'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/home');
            },
          ),
          actions: [
            if (_cartItems.isNotEmpty)
              TextButton(
                onPressed: () {
                  _showClearCartDialog();
                },
                child: const Text('Limpiar'),
              ),
          ],
        ),
        body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartContent(),
        bottomNavigationBar: _cartItems.isNotEmpty ? _buildCheckoutButton() : null,
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos para comenzar a comprar',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/productos');
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Explorar Productos'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Column(
      children: [
        // Lista de productos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return _buildCartItemCard(item, index);
            },
          ),
        ),
        
        // Resumen de precio
        _buildPriceSummary(),
      ],
    );
  }

  Widget _buildCartItemCard(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['image'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Información del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    '\$${item['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Controles de cantidad
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          _updateQuantity(index, item['quantity'] - 1);
                        },
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '${item['quantity']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          _updateQuantity(index, item['quantity'] + 1);
                        },
                      ),
                      
                      const Spacer(),
                      
                      // Botón eliminar
                      IconButton(
                        onPressed: () {
                          _removeItem(index);
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red[400],
                        tooltip: 'Eliminar producto',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal:', _subtotal),
          _buildPriceRow('IVA (16%):', _tax),
          _buildPriceRow('Envío:', _shipping, showFree: _shipping == 0),
          const Divider(height: 20),
          _buildPriceRow('Total:', _total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool showFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            showFree ? 'Gratis' : '\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal 
                  ? Theme.of(context).primaryColor 
                  : showFree 
                      ? Colors.green 
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          context.push('/checkout');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment),
            const SizedBox(width: 8),
            Text(
              'Proceder al Pago - \$${_total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
      return;
    }
    
    setState(() {
      _cartItems[index]['quantity'] = newQuantity;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto eliminado del carrito'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar Carrito'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los productos del carrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrito limpiado'),
                ),
              );
            },
            child: Text(
              'Limpiar',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }
}