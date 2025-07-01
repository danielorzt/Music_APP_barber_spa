// lib/features/cart/presentation/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../auth/providers/auth_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartProvider.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tu carrito está vacío',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Agrega productos para comenzar a comprar',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/products');
              },
              child: const Text('Ver Productos'),
            ),
          ],
        ),
      )
          : Column(
        children: [
      Expanded(
      child: ListView.builder(
      itemCount: cartProvider.items.length,
        itemBuilder: (context, index) {
          final item = cartProvider.items[index];
          return Dismissible(
            key: ValueKey(item.productoId),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (direction) {
              cartProvider.removeItem(item.productoId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.nombre} eliminado del carrito'),
                  action: SnackBarAction(
                    label: 'Deshacer',
                    onPressed: () {
                      // Comentado temporalmente hasta que se implemente correctamente
                      // cartProvider.addItem(
                      //   // Recrear el producto a partir del CartItem
                      //   {
                      //     'id': item.productoId,
                      //     'nombreproducto': item.nombre,
                      //     'precio': item.precio,
                      //     'cantidad': 999, // Valor arbitrario alto
                      //     'usuarioId': 1, // Valor por defecto
                      //   },
                      //   item.cantidad,
                      // );
                    },
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Imagen del producto
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Información del producto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item.precio.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              IconButton(
                                onPressed: item.cantidad > 1
                                    ? () {
                                  cartProvider.updateItemQuantity(
                                    item.productoId,
                                    item.cantidad - 1,
                                  );
                                }
                                    : null,
                                icon: const Icon(Icons.remove),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.cantidad.toStringAsFixed(0),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cartProvider.updateItemQuantity(
                                    item.productoId,
                                    item.cantidad + 1,
                                  );
                                },
                                icon: const Icon(Icons.add),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                iconSize: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Precio total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            cartProvider.removeItem(item.productoId);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${item.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),

    // Resumen del carrito
    Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Colors.white,
    boxShadow: [
    BoxShadow(
    offset: const Offset(0, -2),
    blurRadius: 6,
    color: Colors.black.withOpacity(0.1),
    ),
    ],
    ),
    child: Column(
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    const Text(
    'Subtotal',
    style: TextStyle(
    fontSize: 16,
    ),
    ),
    Text(
    '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
    style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    const SizedBox(height: 8),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
    Text(
    'Envío',
    style: TextStyle(
    fontSize: 16,
    ),
    ),
    Text(
    'Gratis',
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.green,
    ),
    ),
    ],
    ),
    const Divider(height: 24),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    const Text(
    'Total',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    Text(
    '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).primaryColor,
    ),
    ),
    ],
    ),
    const SizedBox(height: 16),
    SizedBox(
    width: double.infinity,
    child: ElevatedButton(
    onPressed: () async {
    // Verificar si el usuario está autenticado
    if (!authProvider.isAuthenticated) {
    // Mostrar diálogo para iniciar sesión
    final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
    title: const Text('Iniciar Sesión'),
    content: const Text(
    'Debes iniciar sesión para continuar con la compra',
    ),
    actions: [
    TextButton(
    onPressed: () {
    Navigator.of(context).pop(false);
    },
    child: const Text('Cancelar'),
    ),
    ElevatedButton(
    onPressed: () {
    Navigator.of(context).pop(true);
    },
    child: const Text('Iniciar Sesión'),
    ),
    ],
    ),
    );

    if (result == true) {
    // Navegar a la pantalla de inicio de sesión
    if (context.mounted) {
    Navigator.pushNamed(context, '/login');
    }
    }
    return;
    }

    // Si está autenticado, proceder con el checkout
    if (authProvider.currentUser != null) {
    // Mostrar diálogo para elegir método de pago
    final paymentMethod = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
    title: const Text('Método de Pago'),
    content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
    ListTile(
    leading: const Icon(Icons.payment),
    title: const Text('MercadoPago'),
    onTap: () {
    Navigator.of(context).pop('mercadopago');
    },
    ),
    ListTile(
    leading: const Icon(Icons.payment),
    title: const Text('PayPal'),
    onTap: () {
    Navigator.of(context).pop('paypal');
    },
    ),
    ],
    ),
    ),
    );

    if (paymentMethod != null && context.mounted) {
    // Crear la orden
    final result = await cartProvider.checkout(
    authProvider.currentUser!.id!,
    );

    if (result != null && context.mounted) {
    final orderId = result['orderId'] as int;

    // Procesar el pago según el método elegido
    if (paymentMethod == 'mercadopago') {
    final status = await cartProvider.payWithMercadoPago(orderId);

    if (status != null && context.mounted) {
    // Mostrar resultado del pago
    ScaffoldMessenger.of(context).showSnackBar(
      // lib/features/cart/presentation/cart_screen.dart (continuación)
      SnackBar(
        content: Text(
          status == 'approved'
              ? 'Pago realizado con éxito'
              : status == 'pending'
              ? 'Pago pendiente'
              : 'Error en el pago',
        ),
        backgroundColor: status == 'approved'
            ? Colors.green
            : status == 'pending'
            ? Colors.orange
            : Colors.red,
      ),
    );

    if (status == 'approved' || status == 'pending') {
      // Navegar a la pantalla de éxito
      Navigator.pushReplacementNamed(
        context,
        '/order-success',
        arguments: orderId,
      );
    }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al procesar el pago'),
          backgroundColor: Colors.red,
        ),
      );
    }
    } else if (paymentMethod == 'paypal') {
      final paypalUrl = await cartProvider.payWithPayPal(orderId);

      if (paypalUrl != null && context.mounted) {
        // Abrir URL de PayPal para completar el pago
        // Aquí puedes usar url_launcher o webview_flutter
        // para abrir la URL de PayPal

        // Ejemplo:
        // await launchUrl(Uri.parse(paypalUrl));

        // O navegar a una pantalla WebView personalizada
        Navigator.pushNamed(
          context,
          '/paypal-webview',
          arguments: {
            'url': paypalUrl,
            'orderId': orderId,
          },
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al procesar el pago con PayPal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al crear la orden: ${cartProvider.error}',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
    }
    }
    },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
      ),
      child: const Text(
        'Proceder al Pago',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    ),
    ],
    ),
    ),
        ],
      ),
    );
  }
}