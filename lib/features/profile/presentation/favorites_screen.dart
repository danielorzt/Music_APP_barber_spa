import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Productos'),
            Tab(text: 'Servicios'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoriteProducts(),
          _buildFavoriteServices(),
        ],
      ),
    );
  }

  Widget _buildFavoriteProducts() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        final products = [
          {
            'name': 'Aceite para Barba Premium',
            'price': 25.0,
            'originalPrice': 35.0,
            'image': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&h=200&fit=crop',
            'rating': 4.8,
            'reviews': 156,
            'inStock': true,
          },
          {
            'name': 'Navaja de Afeitar Profesional',
            'price': 45.0,
            'originalPrice': 60.0,
            'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
            'rating': 4.9,
            'reviews': 89,
            'inStock': true,
          },
          {
            'name': 'Crema de Afeitar Suave',
            'price': 18.0,
            'originalPrice': 25.0,
            'image': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&h=200&fit=crop',
            'rating': 4.6,
            'reviews': 203,
            'inStock': false,
          },
          {
            'name': 'Cepillo para Barba Natural',
            'price': 22.0,
            'originalPrice': 30.0,
            'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
            'rating': 4.7,
            'reviews': 67,
            'inStock': true,
          },
          {
            'name': 'Aceite Esencial de Lavanda',
            'price': 35.0,
            'originalPrice': 45.0,
            'image': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&h=200&fit=crop',
            'rating': 4.5,
            'reviews': 124,
            'inStock': true,
          },
          {
            'name': 'Kit de Afeitado Completo',
            'price': 85.0,
            'originalPrice': 120.0,
            'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
            'rating': 4.9,
            'reviews': 45,
            'inStock': true,
          },
        ];

        final product = products[index];
        final hasDiscount = product['originalPrice'] != product['price'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Imagen del producto
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product['image'] as String,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: Icon(Icons.image, color: Colors.grey.shade600),
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
                        product['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${product['rating']}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product['reviews']})',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${product['price']}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 8),
                            Text(
                              '\$${product['originalPrice']}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (!(product['inStock'] as bool))
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Sin stock',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Botones de acción
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // TODO: Remover de favoritos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removido de favoritos')),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: (product['inStock'] as bool) ? () {
                        // TODO: Agregar al carrito
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Agregado al carrito')),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Agregar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteServices() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        final services = [
          {
            'name': 'Corte Clásico',
            'price': 25.0,
            'duration': '30 min',
            'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=200&fit=crop',
            'rating': 4.8,
            'reviews': 234,
            'available': true,
          },
          {
            'name': 'Afeitado Tradicional',
            'price': 18.0,
            'duration': '20 min',
            'image': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=300&h=200&fit=crop',
            'rating': 4.9,
            'reviews': 156,
            'available': true,
          },
          {
            'name': 'Masaje Relajante',
            'price': 45.0,
            'duration': '60 min',
            'image': 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=300&h=200&fit=crop',
            'rating': 4.7,
            'reviews': 89,
            'available': false,
          },
          {
            'name': 'Tratamiento de Barba',
            'price': 22.0,
            'duration': '25 min',
            'image': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&h=200&fit=crop',
            'rating': 4.6,
            'reviews': 67,
            'available': true,
          },
        ];

        final service = services[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagen del servicio
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    service['image'] as String,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: Icon(Icons.spa, color: Colors.grey.shade600),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Información del servicio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            service['duration'] as String,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${service['rating']}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${service['reviews']})',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${service['price']}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (!(service['available'] as bool))
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'No disponible',
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Botones de acción
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // TODO: Remover de favoritos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removido de favoritos')),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: (service['available'] as bool) ? () {
                        // TODO: Agendar servicio
                        context.go('/citas/agendar');
                      } : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Agendar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 