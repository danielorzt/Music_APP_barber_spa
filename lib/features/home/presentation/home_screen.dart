// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/widgets/simple_carousel.dart';
import 'package:music_app/features/services/presentation/services_screen.dart';
import 'package:music_app/features/cart/presentation/cart_screen.dart';
import 'package:music_app/features/appointments/presentation/appointments_screen.dart';
import 'package:music_app/features/profile/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  // Lista de widgets para cada tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _screens = [
      _HomeTab(),
      const ServicesScreen(),
      const CartScreen(),
      const AppointmentsScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return false;
        }
        return await _showExitDialog(context) ?? false;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa_outlined),
              activeIcon: Icon(Icons.spa),
              label: 'Servicios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Citas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Salir de la aplicación'),
        content: const Text('¿Estás seguro de que quieres salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}

// Widget para la tab de Inicio
class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con saludo y notificaciones
              _buildHeader(),
              
              // Banner principal con carousel
              _buildMainBanner(),
              
              // Sección de servicios destacados
              _buildFeaturedServices(),
              
              // Sección de productos populares
              _buildPopularProducts(),
              
              // Sección de promociones
              _buildPromotions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bienvenido a BarberMusic & Spa',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implementar notificaciones
            },
            icon: Icon(
              Icons.notifications_outlined,
              size: 28,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBanner() {
    final banners = [
      {
        'title': 'Relájate con Nosotros',
        'subtitle': 'Experimenta el mejor spa de la ciudad',
        'image': 'https://picsum.photos/800/400?random=1',
      },
      {
        'title': 'Cortes Modernos',
        'subtitle': 'Estilo y elegancia en cada corte',
        'image': 'https://picsum.photos/800/400?random=2',
      },
      {
        'title': 'Tratamientos Especiales',
        'subtitle': 'Cuida tu piel con nuestros expertos',
        'image': 'https://picsum.photos/800/400?random=3',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SimpleCarousel(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        items: banners.map((banner) => _buildBannerItem(banner)).toList(),
      ),
    );
  }

  Widget _buildBannerItem(Map<String, String> banner) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              banner['image']!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 50),
                );
              },
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner['subtitle']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedServices() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Servicios Destacados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Cambiar a la tab de servicios
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildServiceCard('Corte + Barba', Icons.cut, '\$40'),
                _buildServiceCard('Masaje', Icons.spa, '\$50'),
                _buildServiceCard('Facial', Icons.face, '\$60'),
                _buildServiceCard('Manicure', Icons.back_hand, '\$25'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, String price) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: const Color(0xFFDC3545)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFDC3545),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularProducts() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Productos Populares',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navegar a productos
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildProductCard(
                  'Sérum Vitamina C',
                  '\$450',
                  'https://plus.unsplash.com/premium_photo-1675827055984-3588a445749a?w=300&h=300&fit=crop',
                ),
                _buildProductCard(
                  'Crema Hidratante',
                  '\$380',
                  'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=300&h=300&fit=crop',
                ),
                _buildProductCard(
                  'Aceite Corporal',
                  '\$280',
                  'https://images.unsplash.com/photo-1599387823531-b44c6a6f8737?w=300&h=300&fit=crop',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String price, String imageUrl) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFDC3545),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotions() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        color: const Color(0xFFFDEDED),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.local_offer,
                color: const Color(0xFFDC3545),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¡Oferta Especial!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '20% de descuento en tu primera cita',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementar reserva de cita
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC3545),
                ),
                child: const Text('Reservar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}