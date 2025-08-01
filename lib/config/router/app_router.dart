import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Screens - Auth
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/api_test_screen.dart';

// Screens - Main
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/shared/main_screen.dart';
import '../../features/home/presentation/home_screen.dart';

// Screens - Cliente
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/appointments/presentation/book_appointment_screen.dart';
import '../../features/products/presentation/product_detail_screen.dart';
import '../../features/products/presentation/products_screen.dart';
import '../../features/services/presentation/service_detail_screen.dart';
import '../../features/services/presentation/services_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/addresses_screen.dart';
import '../../features/profile/presentation/favorites_screen.dart';
import '../../features/profile/presentation/history_screen.dart';
import '../../features/profile/presentation/payment_methods_screen.dart';
import '../../features/profile/presentation/help_support_screen.dart';
import '../../features/profile/presentation/settings_screen.dart';
import '../../features/profile/presentation/edit_profile_screen.dart';

// Screens - Test
import '../../features/test/presentation/connection_test_screen.dart';

// Screens - Reviews
import '../../features/reviews/presentation/reviews_screen.dart';

// Providers
import '../../features/auth/providers/auth_provider.dart';
import '../../features/services/models/service_model.dart';
import '../../core/models/producto.dart';

// Services
import '../../core/services/unified_catalog_service.dart';

// Widgets
import '../../core/widgets/auth_guard.dart';

// Placeholder widget para pantallas no implementadas
class PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const PlaceholderScreen({super.key, required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (GoRouter.of(context).canPop()) {
              GoRouter.of(context).pop();
            } else {
              context.go('/main');
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('En construcción...'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/main'),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: '/main',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Si está en la pantalla de splash, no redirigir
      if (state.matchedLocation == '/') {
        return null;
      }
      
      // Si está autenticado y está en login/register, redirigir a main
      if (authProvider.isAuthenticated && 
          (state.matchedLocation.startsWith('/login') ||
           state.matchedLocation.startsWith('/register'))) {
        return '/main';
      }
      
      return null;
    },
    routes: [
      // Rutas de autenticación
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/api-test',
        builder: (context, state) => const ApiTestScreen(),
      ),
      
      // Rutas principales (requieren autenticación)
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainScreen(initialPath: '/'),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(initialPath: '/home'),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const MainScreen(initialPath: '/services'),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const MainScreen(initialPath: '/products'),
      ),
      GoRoute(
        path: '/promotions',
        builder: (context, state) => const PlaceholderScreen(title: 'Ofertas y Promociones'),
      ),
      GoRoute(
        path: '/reviews/:type/:id',
        builder: (context, state) {
          final type = state.pathParameters['type']!;
          final id = state.pathParameters['id']!;
          final name = state.uri.queryParameters['name'] ?? 'Item';
          final image = state.uri.queryParameters['image'] ?? 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=200&fit=crop';
          
          return ReviewsScreen(
            itemId: id,
            itemName: name,
            itemType: type,
            itemImage: image,
          );
        },
      ),
      GoRoute(
        path: '/appointments',
        builder: (context, state) => AuthGuard(
          child: const AppointmentsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => AuthGuard(
          child: const MainScreen(initialPath: '/profile'),
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => AuthGuard(
          child: const CartScreen(),
        ),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => AuthGuard(
          child: const CheckoutScreen(),
        ),
      ),
      GoRoute(
        path: '/agendar',
        builder: (context, state) => AuthGuard(
          child: const BookAppointmentScreen(),
        ),
      ),
      
      // Rutas de detalle (pueden ser públicas pero con funcionalidades protegidas)
      GoRoute(
        path: '/servicios/:id',
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          print('🔍 Navegando a detalle de servicio ID: $serviceId');
          
          // Usar datos reales de la API con fallback
          return FutureBuilder<ServiceModel?>(
            future: _loadServiceFromApiWithFallback(int.parse(serviceId)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Cargando...')),
                  body: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando detalles del servicio...'),
                      ],
                    ),
                  ),
                );
              }
              
              if (snapshot.hasError) {
                print('❌ Error en FutureBuilder: ${snapshot.error}');
                return Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('Error al cargar el servicio'),
                        const SizedBox(height: 8),
                        Text('${snapshot.error}', textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              if (!snapshot.hasData) {
                print('⚠️ No hay datos del servicio para ID: $serviceId');
                return Scaffold(
                  appBar: AppBar(title: const Text('Servicio no encontrado')),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('Servicio no encontrado'),
                        const SizedBox(height: 8),
                        const Text('El servicio que buscas no está disponible'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              print('✅ Mostrando detalles del servicio: ${snapshot.data!.name}');
              return ServiceDetailScreen(service: snapshot.data!);
            },
          );
        },
      ),
      
      // Ruta de prueba de conexión
      GoRoute(
        path: '/test-connection',
        builder: (context, state) => const ConnectionTestScreen(),
      ),
      GoRoute(
        path: '/productos/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          // Usar datos reales de la API
          return FutureBuilder<Producto?>(
            future: _loadProductFromApi(int.parse(productId)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              
              if (snapshot.hasError || !snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Error')),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('Error al cargar el producto'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              
              return ProductDetailScreen(product: snapshot.data!);
            },
          );
        },
      ),
      
      // Rutas de perfil protegidas
      GoRoute(
        path: '/profile/addresses',
        builder: (context, state) => AuthGuard(
          child: const AddressesScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/favorites',
        builder: (context, state) => AuthGuard(
          child: const FavoritesScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/history',
        builder: (context, state) => AuthGuard(
          child: const HistoryScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/payment-methods',
        builder: (context, state) => AuthGuard(
          child: const PaymentMethodsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/help-support',
        builder: (context, state) => AuthGuard(
          child: const HelpSupportScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/settings',
        builder: (context, state) => AuthGuard(
          child: const SettingsScreen(),
        ),
      ),
      
      // Nuevas rutas para funcionalidades mejoradas
      GoRoute(
        path: '/orders',
        builder: (context, state) => AuthGuard(
          child: const HistoryScreen(), // Usar la misma pantalla de historial
        ),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => AuthGuard(
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => AuthGuard(
          child: const PlaceholderScreen(title: 'Cambiar Contraseña'),
        ),
      ),
    ],
  );

  static Future<bool?> _showExitDialog(BuildContext context) async {
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
            ),
            child: const Text(
              'Salir',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Cargar servicio desde la API con fallback
  static Future<ServiceModel?> _loadServiceFromApiWithFallback(int serviceId) async {
    try {
      print('🔄 Intentando cargar servicio con ID: $serviceId');
      final catalogService = UnifiedCatalogService();
      
      // Intento 1: Cargar servicio específico
      try {
        final servicio = await catalogService.getServicio(serviceId);
        if (servicio != null) {
          print('✅ Servicio encontrado directamente: ${servicio.nombre}');
          return ServiceModel(
            id: servicio.id.toString(),
            name: servicio.nombre,
            description: servicio.descripcion,
            price: servicio.precio,
            duration: servicio.duracionEnMinutos,
            imagen: null,
          );
        }
      } catch (e) {
        print('⚠️ Error cargando servicio específico: $e');
      }
      
      // Intento 2: Buscar en la lista de servicios
      print('🔄 Buscando servicio en la lista de servicios...');
      try {
        final servicios = await catalogService.getServicios();
        final servicio = servicios.firstWhere(
          (s) => s.id == serviceId,
          orElse: () => throw Exception('Servicio no encontrado en lista'),
        );
        
        print('✅ Servicio encontrado en lista: ${servicio.nombre}');
        return ServiceModel(
          id: servicio.id.toString(),
          name: servicio.nombre,
          description: servicio.descripcion,
          price: servicio.precio,
          duration: servicio.duracionEnMinutos,
          imagen: null,
        );
      } catch (e) {
        print('⚠️ Error buscando servicio en lista: $e');
      }
      
      // Intento 3: Crear servicio mock como último recurso
      print('🔄 Creando servicio mock para pruebas...');
      return ServiceModel(
        id: serviceId.toString(),
        name: 'Servicio de Barbería',
        description: 'Un excelente servicio de barbería profesional con atención personalizada. Incluye corte, lavado y peinado con productos de la más alta calidad.',
        price: 25.0,
        duration: 45,
        imagen: null,
      );
      
    } catch (e) {
      print('❌ Error crítico cargando servicio $serviceId: $e');
      throw Exception('No se pudo cargar el servicio: $e');
    }
  }

  /// Cargar servicio desde la API (método original mantenido para compatibilidad)
  static Future<ServiceModel?> _loadServiceFromApi(int serviceId) async {
    try {
      print('🔄 Cargando servicio con ID: $serviceId');
      final catalogService = UnifiedCatalogService();
      final servicio = await catalogService.getServicio(serviceId);
      
      if (servicio != null) {
        print('✅ Servicio encontrado: ${servicio.nombre}');
        return ServiceModel(
          id: servicio.id.toString(),
          name: servicio.nombre,
          description: servicio.descripcion,
          price: servicio.precio,
          duration: servicio.duracionEnMinutos,
          imagen: null, // Por ahora sin imagen, se puede mapear después
        );
      }
      
      print('⚠️ Servicio no encontrado para ID: $serviceId');
      return null;
    } catch (e) {
      print('❌ Error cargando servicio $serviceId: $e');
      return null;
    }
  }

  /// Cargar producto desde la API
  static Future<Producto?> _loadProductFromApi(int productId) async {
    try {
      final catalogService = UnifiedCatalogService();
      final producto = await catalogService.getProducto(productId);
      
      if (producto != null) {
        return producto;
      }
      
      return null;
    } catch (e) {
      print('❌ Error cargando producto $productId: $e');
      return null;
    }
  }
}