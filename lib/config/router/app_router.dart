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
import '../../features/main/presentation/main_screen.dart';
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

// Providers
import '../../features/auth/providers/auth_provider.dart';
import '../../features/services/models/service_model.dart';
import '../../core/models/producto.dart';

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
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Si está en la pantalla de splash, no redirigir
      if (state.matchedLocation == '/') {
        return null;
      }
      
      // Si no está autenticado y no está en rutas públicas, redirigir a login
      if (!authProvider.isAuthenticated && 
          !state.matchedLocation.startsWith('/login') &&
          !state.matchedLocation.startsWith('/register') &&
          !state.matchedLocation.startsWith('/api-test') &&
          !state.matchedLocation.startsWith('/onboarding')) {
        return '/login';
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
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      
      // Rutas protegidas que requieren autenticación
      GoRoute(
        path: '/appointments',
        builder: (context, state) => AuthGuard(
          child: const AppointmentsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => AuthGuard(
          child: const ProfileScreen(),
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
        path: '/service/:id',
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          // Crear un ServiceModel mock basado en el ID
          final service = ServiceModel(
            id: serviceId,
            name: 'Servicio $serviceId',
            description: 'Descripción del servicio $serviceId',
            price: 25.0 + (int.parse(serviceId) * 5.0),
            duration: 30 + (int.parse(serviceId) * 10),
            imagen: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop',
          );
          return ServiceDetailScreen(service: service);
        },
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          // Crear un Producto mock basado en el ID
          final product = Producto(
            id: int.parse(productId),
            nombre: 'Producto $productId',
            descripcion: 'Descripción del producto $productId',
            precio: 15.0 + (int.parse(productId) * 2.0),
            urlImagen: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=400&fit=crop',
          );
          return ProductDetailScreen(product: product);
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
}