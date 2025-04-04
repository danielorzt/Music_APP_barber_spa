import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Forma 1: Usando Provider.of
    final cartProvider = Provider.of<CartProvider>(context);

    // O Forma 2: Usando Consumer (recomendado para widgets específicos)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.price),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => cart.removeItem(index),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Total: ${cartProvider.total}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}