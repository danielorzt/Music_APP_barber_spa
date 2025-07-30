// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';
import 'package:music_app/core/widgets/simple_carousel.dart';
import 'package:music_app/core/services/catalog_api_service.dart';
import 'package:music_app/core/widgets/loading_indicator.dart';
import 'package:music_app/core/services/stories_api_service.dart';
import 'package:music_app/core/services/news_api_service.dart';
import 'package:music_app/core/widgets/story_card.dart';
import 'package:music_app/core/widgets/news_card.dart';
import 'package:music_app/core/widgets/auth_guard.dart';

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
  final CatalogApiService _catalogService = CatalogApiService();
  final StoriesApiService _storiesService = StoriesApiService();
  final NewsApiService _newsService = NewsApiService();
  
  // Estados de carga
  bool _isLoadingServices = false;
  bool _isLoadingProducts = false;
  bool _isLoadingPromotions = false;
  bool _isLoadingStories = false;
  bool _isLoadingNews = false;
  
  // Datos de la API
  List<Map<String, dynamic>> _featuredServices = [];
  List<Map<String, dynamic>> _popularProducts = [];
  List<Map<String, dynamic>> _promotions = [];
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
      _loadFeaturedServices(),
      _loadPopularProducts(),
      _loadPromotions(),
      _loadStories(),
      _loadNews(),
    ]);
  }

  /// Cargar servicios destacados
  Future<void> _loadFeaturedServices() async {
    setState(() => _isLoadingServices = true);
    
    try {
      final response = await _catalogService.getServiciosDestacados();
      if (response['success'] == true) {
        final servicesData = response['data'] ?? [];
        if (mounted) {
          setState(() {
            _featuredServices = List<Map<String, dynamic>>.from(servicesData);
          });
        }
      }
    } catch (e) {
      print('Error cargando servicios destacados: $e');
      // Mantener datos mock como fallback
      _featuredServices = [
        {
          'id': '1',
          'nombre': 'Corte Clásico',
          'precio': 25.0,
          'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=200&fit=crop',
        },
        {
          'id': '2',
          'nombre': 'Corte + Barba',
          'precio': 40.0,
          'imagen': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=300&h=200&fit=crop',
        },
        {
          'id': '3',
          'nombre': 'Tratamiento Facial',
          'precio': 35.0,
          'imagen': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=300&h=200&fit=crop',
        },
        {
          'id': '4',
          'nombre': 'Masaje Relajante',
          'precio': 60.0,
          'imagen': 'https://images.unsplash.com/photo-1544161512-4ab64f436453?w=300&h=200&fit=crop',
        },
      ];
    } finally {
      if (mounted) {
        setState(() => _isLoadingServices = false);
      }
    }
  }

  /// Cargar productos populares
  Future<void> _loadPopularProducts() async {
    setState(() => _isLoadingProducts = true);
    
    try {
      final response = await _catalogService.getProductosDestacados();
      if (response['success'] == true) {
        final productsData = response['data'] ?? [];
        if (mounted) {
          setState(() {
            _popularProducts = List<Map<String, dynamic>>.from(productsData);
          });
        }
      }
    } catch (e) {
      print('Error cargando productos populares: $e');
      // Mantener datos mock como fallback
      _popularProducts = [
        {
          'id': '1',
          'nombre': 'Aceite para Barba Premium',
          'precio': 25.0,
          'imagen': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
        },
        {
          'id': '2',
          'nombre': 'Pomada para Cabello',
          'precio': 18.0,
          'imagen': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=300&h=200&fit=crop',
        },
        {
          'id': '3',
          'nombre': 'Kit de Afeitado',
          'precio': 45.0,
          'imagen': 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=300&h=200&fit=crop',
        },
        {
          'id': '4',
          'nombre': 'Crema Hidratante',
          'precio': 22.0,
          'imagen': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=300&h=200&fit=crop',
        },
      ];
    } finally {
      if (mounted) {
        setState(() => _isLoadingProducts = false);
      }
    }
  }

  /// Cargar promociones
  Future<void> _loadPromotions() async {
    setState(() => _isLoadingPromotions = true);
    
    try {
      final response = await _catalogService.getOfertas();
      if (response['success'] == true) {
        final promotionsData = response['data'] ?? [];
        if (mounted) {
          setState(() {
            _promotions = List<Map<String, dynamic>>.from(promotionsData);
          });
        }
      }
    } catch (e) {
      print('Error cargando promociones: $e');
      // Mantener datos mock como fallback
      _promotions = [
        {
          'id': '1',
          'titulo': 'Descuento 20%',
          'descripcion': 'En todos los cortes de cabello',
          'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=200&fit=crop',
        },
        {
          'id': '2',
          'titulo': '2x1 en Productos',
          'descripcion': 'Lleva 2 productos por el precio de 1',
          'imagen': 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&h=200&fit=crop',
        },
      ];
    } finally {
      if (mounted) {
        setState(() => _isLoadingPromotions = false);
      }
    }
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
      final featuredNewsResponse = await _newsService.getTopNews();
      
      if (newsResponse['status'] == 'ok' && featuredNewsResponse['status'] == 'ok') {
        if (mounted) {
          setState(() {
            _news = List<Map<String, dynamic>>.from(newsResponse['articles'] ?? []);
            _featuredNews = List<Map<String, dynamic>>.from(featuredNewsResponse['articles'] ?? []);
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
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con saludo y notificaciones
              _buildHeader(),
              
              // Banner principal con carousel
              _buildMainBanner(),
              
              const SizedBox(height: 24),
              
              // Sección de categorías rápidas
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: _buildQuickCategories(context),
                    ),
                  );
                },
              ),
              
              // Sección de historias virales
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 1.2),
                      child: _buildStoriesSection(context),
                    ),
                  );
                },
              ),
              
              // Sección de noticias destacadas
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 1.4),
                      child: _buildFeaturedNews(context),
                    ),
                  );
                },
              ),
              
              // Sección de servicios destacados
              _buildFeaturedServices(context),
              
              // Sección de productos populares
              _buildPopularProducts(context),
              
              // Banner de descuentos con animación de pulso
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: _buildDiscountBanner(context),
                  );
                },
              ),
              
              // Sección de noticias generales
              _buildNewsSection(context),
              
              // Sección de promociones
              _buildPromotions(context),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authProvider.isAuthenticated
                        ? '¡Hola, ${authProvider.currentUser?['nombre'] ?? 'Usuario'}!'
                        : '¡Bienvenido!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    authProvider.isAuthenticated
                        ? '¿Qué servicio necesitas hoy?'
                        : 'Inicia sesión para continuar',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              if (authProvider.isAuthenticated)
                CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFDC3545),
                  child: Text(
                    (authProvider.currentUser?['nombre'] ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainBanner() {
    final banners = [
      {
        'title': '¡Bienvenido al Mejor Spa!',
        'subtitle': '20% OFF en tu primera visita',
        'image': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&h=400&fit=crop',
        'color': '0xFFE74C3C',
      },
      {
        'title': 'Cortes Premium',
        'subtitle': 'Estilo profesional garantizado',
        'image': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=800&h=400&fit=crop',
        'color': '0xFF2E86AB',
      },
      {
        'title': 'Tratamientos Exclusivos',
        'subtitle': 'Cuidado experto para tu piel',
        'image': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=800&h=400&fit=crop',
        'color': '0xFF6A994E',
      },
      {
        'title': 'Relajación Total',
        'subtitle': 'Masajes terapéuticos únicos',
        'image': 'https://images.unsplash.com/photo-1544161512-4ab64f436453?w=800&h=400&fit=crop',
        'color': '0xFF9B59B6',
      },
      {
        'title': 'Productos Premium',
        'subtitle': 'Calidad internacional',
        'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&h=400&fit=crop',
        'color': '0xFFF39C12',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: SimpleCarousel(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        items: banners.map((banner) => _buildBannerItem(banner)).toList(),
      ),
    );
  }

  Widget _buildBannerItem(Map<String, String> banner) {
    final themeColor = Color(int.parse(banner['color']!));
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
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

  Widget _buildFeaturedServices(BuildContext context) {
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
                onPressed: () => context.go('/servicios'),
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
          if (_isLoadingServices)
            const Center(child: LoadingIndicator())
          else
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _featuredServices.length,
                itemBuilder: (context, index) {
                  final service = _featuredServices[index];
                  return _buildServiceCard(
                    service['nombre'] ?? 'Servicio',
                    service['imagen'] ?? 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=200&fit=crop',
                    '\$${service['precio'] ?? 0}',
                    () {
                      // Navegar al detalle del servicio
                      context.go('/servicios');
                    },
                  );
                },
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

  Widget _buildPopularProducts(BuildContext context) {
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
                onPressed: () => context.go('/productos'),
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
          if (_isLoadingProducts)
            const Center(child: LoadingIndicator())
          else
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _popularProducts.length,
                itemBuilder: (context, index) {
                  final product = _popularProducts[index];
                  return _buildProductCard(
                    product['nombre'] ?? 'Producto',
                    '\$${product['precio'] ?? 0}',
                    product['imagen'] ?? 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=200&fit=crop',
                    () {
                      // Navegar al detalle del producto
                      context.go('/productos');
                    },
                  );
                },
              ),
            ),
        ],
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
        'route': '/servicios',
      },
      {
        'title': 'Productos',
        'icon': Icons.shopping_bag,
        'color': const Color(0xFF3498DB),
        'route': '/productos',
      },
      {
        'title': 'Citas',
        'icon': Icons.calendar_today,
        'color': const Color(0xFF2ECC71),
        'route': '/citas',
      },
      {
        'title': 'Ofertas',
        'icon': Icons.local_offer,
        'color': const Color(0xFFF39C12),
        'route': '/ofertas',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: categories.map((category) {
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
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: category['color'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category['icon'] as IconData,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: category['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStoriesSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.video_library,
                      color: Color(0xFFDC3545),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Videos Trending',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'VIRAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_isLoadingStories)
            const Center(child: LoadingIndicator())
          else if (_trendingStories.isNotEmpty || _stories.isNotEmpty)
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: (_trendingStories + _stories).length,
                itemBuilder: (context, index) {
                  final allStories = _trendingStories + _stories;
                  return StoryCard(
                    story: allStories[index],
                    onTap: () {
                      // TODO: Abrir reproductor de video
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Reproduciendo: ${allStories[index]['title']}'),
                          backgroundColor: const Color(0xFFDC3545),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('No hay videos disponibles'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturedNews(BuildContext context) {
    if (_isLoadingNews) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: const Center(child: LoadingIndicator()),
      );
    }

    if (_featuredNews.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Noticias Destacadas',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _featuredNews.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: NewsCard(
                    article: _featuredNews[index],
                    isFeatured: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context) {
    if (_isLoadingNews) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: const Center(child: LoadingIndicator()),
      );
    }

    if (_news.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.newspaper,
                      color: Color(0xFFDC3545),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Últimas Noticias',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navegar a pantalla de noticias completa
                  },
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(
                      color: Color(0xFFDC3545),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._news.take(3).map((article) => NewsCard(article: article)),
        ],
      ),
    );
  }

  Widget _buildDiscountBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFEE5A5A),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¡MEGA DESCUENTO!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Hasta 50% OFF en servicios premium',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'CÓDIGO: SPA50',
                            style: TextStyle(
                              color: Color(0xFFFF6B6B),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: const Text(
                '50%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotions(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promociones Especiales',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F9FA),
                    Color(0xFFE9ECEF),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC3545),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _promotions.isNotEmpty 
                                ? _promotions.first['titulo'] ?? '¡Primera Cita Gratis!'
                                : '¡Primera Cita Gratis!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _promotions.isNotEmpty 
                                ? _promotions.first['descripcion'] ?? 'Solo para nuevos clientes'
                                : 'Solo para nuevos clientes',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AuthRequiredButton(
                      onPressed: () => context.go('/agendar'),
                      isAuthenticated: authProvider.isAuthenticated,
                      onAuthRequired: () => _showAuthRequiredDialog(context, 'reservar una cita'),
                      child: const Text(
                        'Reservar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}