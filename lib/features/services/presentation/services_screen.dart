import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/cart/models/cart_item_model.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/features/services/models/service_model.dart';
import 'package:music_app/features/services/repositories/services_repository.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final servicesRepository = Provider.of<ServicesRepository>(context, listen: false);

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
      body: FutureBuilder<List<Service>>(
          future: servicesRepository.getServices(),
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

            final services = snapshot.data!;
            return ListView.builder(
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                IconData icon;

                // Mapeo de strings a IconData
                switch(service.icon) {
                  case 'cut': icon = Icons.cut; break;
                  case 'face': icon = Icons.face; break;
                  case 'spa': icon = Icons.spa; break;
                  default: icon = Icons.cut;
                }

                return _buildServiceCard(
                    context,
                    service,
                    icon
                );
              },
            );
          }
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(8),
      color: colorScheme.surfaceVariant,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(service.name, style: TextStyle(color: colorScheme.onSurfaceVariant)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${service.price}',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
            if (service.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(service.description,
                    style: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7))),
              ),
          ],
        ),
        isThreeLine: service.description.isNotEmpty,
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart, color: colorScheme.primary),
          onPressed: () {
            // Crear item del carrito a partir del servicio
            final cartItem = CartItem(
              id: DateTime.now().millisecondsSinceEpoch,
              name: service.name,
              price: service.price,
              type: CartItemType.service,
              serviceId: service.id,
            );

            // Añadir al carrito
            cartProvider.addItem(cartItem);

            // Mostrar mensaje de confirmación
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: colorScheme.primaryContainer,
                content: Text(
                  '${service.name} agregado al carrito',
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