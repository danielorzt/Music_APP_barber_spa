// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';
import 'package:music_app/core/widgets/simple_carousel.dart';
import 'package:music_app/core/services/bmspa_api_service.dart';
import 'package:music_app/core/widgets/loading_indicator.dart';
import 'package:music_app/core/services/stories_api_service.dart';
import 'package:music_app/core/services/news_api_service.dart';
import 'package:music_app/core/widgets/story_card.dart';
import 'package:music_app/core/widgets/news_card.dart';
import 'package:music_app/core/widgets/auth_guard.dart';
import 'package:music_app/features/services/providers/services_provider.dart';
import 'package:music_app/features/products/providers/products_provider.dart';

// Widget helper para mostrar diálogo de autenticación requerida
void _showAuthRequiredDialog(BuildContext context, String action) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Iniciar Sesión Requerido'),
      content: Text('Necesitas iniciar sesión para $action.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC3545),
          ),
          child: const Text(
            'Iniciar Sesión',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  // Servicios API
  final BMSPAApiService _apiService = BMSPAApiService();
  final StoriesApiService _storiesService = StoriesApiService();
  final NewsApiService _newsService = NewsApiService();
  
  // Estados de carga
  bool _isLoadingStories = false;
  bool _isLoadingNews = false;
  
  // Datos de la API
  List<Map<String, dynamic>> _stories = [];
  List<Map<String, dynamic>> _trendingStories = [];
  List<Map<String, dynamic>> _news = [];
  List<Map<String, dynamic>> _featuredNews = [];

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores de animación
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Configurar animaciones
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Iniciar animaciones
    _animationController.forward();
    _pulseController.repeat(reverse: true);
    
    _loadHomeData();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  /// Cargar datos de la pantalla de inicio
  Future<void> _loadHomeData() async {
    await Future.wait([
      _loadStories(),
      _loadNews(),
    ]);
  }

  /// Cargar historias de videos
  Future<void> _loadStories() async {
    setState(() => _isLoadingStories = true);
    
    try {
      final storiesResponse = await _storiesService.getStories();
      final trendingResponse = await _storiesService.getTrendingStories();
      
      if (storiesResponse['success'] == true && trendingResponse['success'] == true) {
        if (mounted) {
          setState(() {
            _stories = List<Map<String, dynamic>>.from(storiesResponse['data'] ?? []);
            _trendingStories = List<Map<String, dynamic>>.from(trendingResponse['data'] ?? []);
          });
        }
      }
    } catch (e) {
      print('Error cargando historias: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingStories = false);
      }
    }
  }

  /// Cargar noticias
  Future<void> _loadNews() async {
    setState(() => _isLoadingNews = true);
    
    try {
      final newsResponse = await _newsService.getBarberSpaNews();
      final featuredResponse = await _newsService.getTopNews();
      
      if (newsResponse['status'] == 'ok' && featuredResponse['status'] == 'ok') {
        if (mounted) {
          setState(() {
            _news = List<Map<String, dynamic>>.from(newsResponse['articles'] ?? []);
            _featuredNews = List<Map<String, dynamic>>.from(featuredResponse['articles'] ?? []);
          });
        }
      }
    } catch (e) {
      print('Error cargando noticias: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingNews = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              _buildBannerSection(),
              _buildFeaturedServicesSection(),
              _buildPopularProductsSection(),
              _buildPromotionsSection(),
              _buildQuickCategories(context),
              _buildStoriesSection(),
              _buildNewsSection(),
              const SizedBox(height: 100), // Espacio para bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFDC3545),
            const Color(0xFFDC3545).withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Barber Music Spa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tu estilo, nuestra pasión',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      if (authProvider.isAuthenticated) {
                        context.go('/profile');
                      } else {
                        context.go('/login');
                      }
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        authProvider.isAuthenticated ? Icons.person : Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Buscar servicios, productos...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
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

  Widget _buildBannerSection() {
    final banners = [
      {
        'title': 'Corte Premium',
        'subtitle': 'Desde \$25',
        'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=200&fit=crop',
      },
      {
        'title': 'Tratamiento Facial',
        'subtitle': 'Desde \$50',
        'image': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400&h=200&fit=crop',
      },
    ];

    return Container(
      height: 200,
      margin: const EdgeInsets.all(20),
      child: SimpleCarousel(
        items: banners.map((banner) => _buildBannerCard(banner)).toList(),
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner) {
    const themeColor = Color(0xFFDC3545);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [themeColor, themeColor.withOpacity(0.7)],
                    ),
                  ),
                  child: const Icon(Icons.image_not_supported, size: 50, color: Colors.white),
                );
              },
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeColor.withOpacity(0.8),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    banner['subtitle']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedServicesSection() {
    // Datos mock para servicios destacados
    final mockServices = [
      {
        'nombre': 'Corte Premium',
        'precio': 25.0,
        'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=200&fit=crop',
      },
      {
        'nombre': 'Arreglo de Barba',
        'precio': 18.0,
        'imagen': 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=300&h=200&fit=crop',
      },
      {
        'nombre': 'Tratamiento Facial',
        'precio': 45.0,
        'imagen': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=300&h=200&fit=crop',
      },
      {
        'nombre': 'Masaje Relajante',
        'precio': 35.0,
        'imagen': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=300&h=200&fit=crop',
      },
    ];

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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/services'),
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    color: Color(0xFFDC3545),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockServices.length,
              itemBuilder: (context, index) {
                final service = mockServices[index];
                return _buildServiceCard(
                  service['nombre'] as String,
                  service['imagen'] as String,
                  '\$${service['precio']}',
                  () {
                    context.go('/services');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularProductsSection() {
    // Datos mock para productos populares
    final mockProducts = [
      {
        'nombre': 'Pomada Clásica',
        'precio': 15.0,
        'imagen': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
      },
      {
        'nombre': 'Aceite para Barba',
        'precio': 22.0,
        'imagen': 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=300&h=200&fit=crop',
      },
      {
        'nombre': 'Shampoo Premium',
        'precio': 18.0,
        'imagen': 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=300&h=200&fit=crop',
      },
      {
        'nombre': 'Cera Híbrida',
        'precio': 25.0,
        'imagen': 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=300&h=200&fit=crop',
      },
    ];

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
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/products'),
                child: const Text(
                  'Ver todos',
                  style: TextStyle(
                    color: Color(0xFFDC3545),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockProducts.length,
              itemBuilder: (context, index) {
                final product = mockProducts[index];
                return _buildProductCard(
                  product['nombre'] as String,
                  '\$${product['precio']}',
                  product['imagen'] as String,
                  () {
                    context.go('/products');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ofertas Especiales',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFDC3545),
                  const Color(0xFFDC3545).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descuento 20%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'En todos los servicios premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.go('/services'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFDC3545),
                        ),
                        child: const Text('Ver Ofertas'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String imageUrl, String price, VoidCallback? onTap) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: imageUrl.isNotEmpty ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ) : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
                        fontSize: 16,
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

  Widget _buildProductCard(String title, String price, String imageUrl, VoidCallback? onTap) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: imageUrl.isNotEmpty ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ) : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
                        fontSize: 16,
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

  Widget _buildQuickCategories(BuildContext context) {
    final categories = [
      {
        'title': 'Servicios',
        'icon': Icons.spa,
        'color': const Color(0xFFE74C3C),
        'route': '/services',
      },
      {
        'title': 'Productos',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF3498DB),
        'route': '/products',
      },
      {
        'title': 'Citas',
        'icon': Icons.calendar_today,
        'color': const Color(0xFF2ECC71),
        'route': '/appointments',
      },
      {
        'title': 'Carrito',
        'icon': Icons.shopping_cart,
        'color': const Color(0xFF9B59B6),
        'route': '/cart',
      },
      {
        'title': 'Ofertas',
        'icon': Icons.local_offer,
        'color': const Color(0xFFF39C12),
        'route': '/promotions',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: categories.take(4).map((category) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: InkWell(
                    onTap: () => context.go(category['route'] as String),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (category['color'] as Color).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['title'] as String,
                            style: TextStyle(
                              color: category['color'] as Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection() {
    // Datos mock para historias
    final mockStories = [
      {
        'title': 'Técnicas de Corte',
        'thumbnail': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=200&h=200&fit=crop',
        'duration': '2:30',
      },
      {
        'title': 'Cuidado de Barba',
        'thumbnail': 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=200&h=200&fit=crop',
        'duration': '1:45',
      },
      {
        'title': 'Tratamientos Spa',
        'thumbnail': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=200&h=200&fit=crop',
        'duration': '3:15',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockStories.length,
              itemBuilder: (context, index) {
                final story = mockStories[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFDC3545),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            story['thumbnail'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.play_circle, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        story['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection() {
    // Datos mock para noticias
    final mockNews = [
      {
        'title': 'Tendencias de Corte 2025',
        'description': 'Descubre los estilos más populares de este año',
        'urlToImage': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=200&fit=crop',
        'publishedAt': '2025-01-15',
      },
      {
        'title': 'Cuidado de Barba en Invierno',
        'description': 'Tips para mantener tu barba saludable',
        'urlToImage': 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=300&h=200&fit=crop',
        'publishedAt': '2025-01-10',
      },
      {
        'title': 'Nuevos Tratamientos Spa',
        'description': 'Relajación y bienestar para ti',
        'urlToImage': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=300&h=200&fit=crop',
        'publishedAt': '2025-01-08',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Noticias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mockNews.length,
              itemBuilder: (context, index) {
                final news = mockNews[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Manejar tap en noticia
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                            child: Image.network(
                              news['urlToImage'] as String,
                              width: 100,
                              height: 140,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 140,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.article, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    news['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    news['description'] as String,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    news['publishedAt'] as String,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}