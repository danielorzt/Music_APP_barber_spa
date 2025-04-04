import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart'; // Asegúrate de que esta ruta sea correcta

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios ✂️', style: TextStyle(color: Colors.amber)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.amber),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildServiceCard(context, 'Corte de Cabello', '\$250', Icons.cut),
          _buildServiceCard(context, 'Afeitado Clásico', '\$180', Icons.face),
          _buildServiceCard(context, 'Masaje Relajante', '\$400', Icons.spa),
          _buildServiceCard(context, 'Tratamiento Facial', '\$350', Icons.face),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String price, IconData icon) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.grey[900],
      child: ListTile(
        leading: Icon(icon, color: Colors.amber),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(price, style: const TextStyle(color: Colors.amber)),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart, color: Colors.amber),
          onPressed: () {
            // Agrega el servicio al carrito
            Provider.of<CartProvider>(context, listen: false).addItem(title, price);

            // Muestra un mensaje de confirmación
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$title agregado al carrito'),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
  }
}