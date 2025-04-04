import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/core/services/api_service.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios ✂️',
            style: TextStyle(color: colorScheme.primary)),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: colorScheme.primary),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: Provider.of<ApiService>(context, listen: false).getServices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: colorScheme.error)),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No hay servicios disponibles',
                    style: TextStyle(color: colorScheme.onSurface)),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final service = snapshot.data![index];
                IconData icon;

                // Mapeo de strings a IconData
                switch(service['icon']) {
                  case 'cut': icon = Icons.cut; break;
                  case 'face': icon = Icons.face; break;
                  case 'spa': icon = Icons.spa; break;
                  default: icon = Icons.cut;
                }

                return _buildServiceCard(
                    context,
                    service['name'],
                    '\$${service['price']}',
                    icon
                );
              },
            );
          }
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String price, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.all(8),
      color: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(title, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        subtitle: Text(price, style: TextStyle(color: colorScheme.primary)),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart, color: colorScheme.primary),
          onPressed: () {
            // Agrega el servicio al carrito
            Provider.of<CartProvider>(context, listen: false).addItem(title, price);

            // Muestra un mensaje de confirmación
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colorScheme.primaryContainer,
                content: Text(
                  '$title agregado al carrito',
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}