// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../products/providers/products_provider.dart';
import '../../services/providers/services_provider.dart';
import '../../auth/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar datos al iniciar
    Future.microtask(() {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
      Provider.of<ServicesProvider>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final servicesProvider = Provider.of<ServicesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BarberMusic & Spa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    authProvider.currentUser?.nombre ?? 'Invitado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    authProvider.currentUser?.email ?? 'Inicia sesión',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Productos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/products');
              },
            ),
            ListTile(
              leading: const Icon(Icons.spa),
              title: const Text('Servicios'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/services');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Mis Citas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Carrito'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
            ),
            const Divider(),
            if (authProvider.isAuthenticated)
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  await authProvider.logout();
                  Navigator.pop(context);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sesión'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login');
                },
              ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await productsProvider.fetchProducts();
          await servicesProvider.fetchServices();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                ),
                child: const Center(
                  child: Text(
                    'Bienvenido a BarberMusic & Spa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Sección de Productos Destacados
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Productos Destacados',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/products'),
                          child: const Text('Ver Todos'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    productsProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : productsProvider.error != null
                        ? Center(child: Text('Error: ${productsProvider.error}'))
                        : SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: productsProvider.products.length > 5
                            ? 5
                            : productsProvider.products.length,
                        itemBuilder: (context, index) {
                          final product = productsProvider.products[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-detail',
                                arguments: product.id,
                              );
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                      image: product.imagen != null
                                          ? DecorationImage(
                                        image: NetworkImage(
                                          'http://192.168.1.X:63106/images/${product.imagen}',
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: product.imagen == null
                                        ? const Center(
                                      child: Icon(Icons.image_not_supported),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.nombreproducto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.precio.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Sección de Servicios
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nuestros Servicios',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/services'),
                          child: const Text('Ver Todos'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    servicesProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : servicesProvider.error != null
                        ? Center(child: Text('Error: ${servicesProvider.error}'))
                        : SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: servicesProvider.services.length > 5
                            ? 5
                            : servicesProvider.services.length,
                        itemBuilder: (context, index) {
                          final service = servicesProvider.services[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/service-detail',
                                arguments: service.id,
                              );
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                      image: service.imagen != null
                                          ? DecorationImage(
                                        image: NetworkImage(
                                          'http://192.168.1.X:63106/images/${service.imagen}',
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                    ),
                                    child: service.imagen == null
                                        ? const Center(
                                      child: Icon(Icons.image_not_supported),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    service.nombre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${service.precio.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Duración: ${service.duracion} min',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}