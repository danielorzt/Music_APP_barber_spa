import 'package:flutter/material.dart';
import 'package:music_app/core/models/producto.dart';

class CategoryItemsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryItemsScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo simplificados
    final List<Producto> allProducts = [
      const Producto(
        id: 1, 
        nombre: 'Sérum Vitamina C Premium', 
        descripcion: 'Sérum antioxidante con vitamina C pura',
        precio: 450.0, 
        urlImagen: 'https://plus.unsplash.com/premium_photo-1675827055984-3588a445749a?q=80&w=1974&auto=format&fit=crop'
      ),
      const Producto(
        id: 2, 
        nombre: 'Crema Hidratante Facial', 
        descripcion: 'Crema hidratante con SPF 30',
        precio: 380.0, 
        urlImagen: 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?q=80&w=1974&auto=format&fit=crop'
      ),
      const Producto(
        id: 3, 
        nombre: 'Aceite Corporal Relajante', 
        descripcion: 'Aceite natural para masajes',
        precio: 280.0, 
        urlImagen: 'https://images.unsplash.com/photo-1599387823531-b44c6a6f8737?q=80&w=1974&auto=format&fit=crop'
      ),
      const Producto(
        id: 4, 
        nombre: 'Mascarilla Purificante', 
        descripcion: 'Mascarilla de arcilla para pieles grasas',
        precio: 180.0, 
        urlImagen: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1974&auto=format&fit=crop'
      ),
    ];

    // Para este ejemplo, mostramos todos los productos
    // En una implementación real, aquí filtrarías por categoría
    final List<Producto> filteredProducts = allProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay productos en esta categoría',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final producto = filteredProducts[index];
                return _buildProductCard(context, producto);
              },
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, Producto producto) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                producto.urlImagen,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${producto.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 