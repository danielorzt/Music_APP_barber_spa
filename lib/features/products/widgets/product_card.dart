import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/core/utils/image_mapper.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String productId;
  final VoidCallback? onTap;

  const ProductCard({
    super.key, 
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.productId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: ImageMapper.buildImageWidget(
                  imageUrl,
                  name,
                  false, // isService = false for products
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final isInCart = cart.isInCart(productId, 'product');
                          return IconButton(
                            onPressed: () {
                              if (isInCart) {
                                cart.removeItem(productId, 'product');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Producto removido del carrito'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              } else {
                                cart.addItem(
                                  productId,
                                  name,
                                  double.parse(price.replaceAll('\$', '')),
                                  imageUrl,
                                  'product',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Producto agregado al carrito'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                              color: isInCart ? Colors.red : Colors.green,
                            ),
                            tooltip: isInCart ? 'Remover del carrito' : 'Agregar al carrito',
                          );
                        },
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
}
