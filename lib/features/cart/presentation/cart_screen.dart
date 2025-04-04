import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/features/cart/models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito', style: TextStyle(color: colorScheme.primary)),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: colorScheme.error),
            onPressed: () {
              _showClearCartDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.items;

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 64, color: colorScheme.primary.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Ver Servicios'),
                    onPressed: () => Navigator.pushNamed(context, '/services'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildCartItemTile(context, item, index);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '\$${cartProvider.total.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment),
                  label: const Text('Pagar ahora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: cartProvider.items.isEmpty
                      ? null
                      : () {
                    // Acción de pago
                    _showPaymentDialog(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItemTile(BuildContext context, CartItem item, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    IconData itemIcon;
    if (item.type == CartItemType.service) {
      switch (item.serviceId) {
        case 1: itemIcon = Icons.cut; break;
        case 2: itemIcon = Icons.face; break;
        case 3: itemIcon = Icons.spa; break;
        default: itemIcon = Icons.category;
      }
    } else {
      itemIcon = Icons.shopping_bag;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(itemIcon, color: colorScheme.primary),
        ),
        title: Text(item.name),
        subtitle: Row(
          children: [
            Text('\$${item.price}', style: TextStyle(color: colorScheme.primary)),
            if (item.type == CartItemType.product) ...[
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: item.quantity > 1
                          ? () => cartProvider.updateQuantity(item.id, item.quantity - 1)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.remove, size: 16,
                            color: item.quantity > 1
                                ? colorScheme.primary
                                : colorScheme.onSurface.withOpacity(0.3)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('${item.quantity}', style: const TextStyle(fontSize: 14)),
                    ),
                    InkWell(
                      onTap: () => cartProvider.updateQuantity(item.id, item.quantity + 1),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(Icons.add, size: 16, color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: colorScheme.error),
          onPressed: () => cartProvider.removeItem(index),
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text('¿Estás seguro de que deseas vaciar tu carrito?'),
        actions: [
          TextButton(
            child: Text('Cancelar', style: TextStyle(color: colorScheme.onSurface)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Vaciar', style: TextStyle(color: colorScheme.error)),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Pago', style: TextStyle(color: colorScheme.primary)),
        content: const Text('Esta acción te llevaría a la pantalla de pago (aún no implementada).'),
        actions: [
          TextButton(
            child: Text('Cancelar', style: TextStyle(color: colorScheme.onSurface)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text('Continuar'),
            onPressed: () {
              // Aquí iría la navegación a la pantalla de pago
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función de pago aún no implementada'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}