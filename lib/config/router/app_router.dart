import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Screens - Auth
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/test_login_screen.dart';
import '../../features/auth/presentation/api_test_screen.dart';

// Screens - Main
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/main/presentation/main_screen.dart';

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
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    // Clave global para manejar el estado de navegación
    navigatorKey: GlobalKey<NavigatorState>(),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      
      // Rutas que no requieren autenticación
      final publicRoutes = ['/splash', '/onboarding', '/main', '/login', '/register'];
      
      // Si la ruta actual es pública, permitir acceso
      if (publicRoutes.any((route) => state.fullPath?.startsWith(route) == true)) {
        return null;
      }
      
      // Para rutas protegidas del cliente
      final protectedRoutes = ['/perfil', '/carrito', '/checkout', '/agendar', '/comprar'];
      if (protectedRoutes.any((route) => state.fullPath?.startsWith(route) == true)) {
        if (!isAuthenticated) {
          return '/login';
        }
      }
      
      return null;
    },
    routes: [
      // === PANTALLAS PRINCIPALES ===
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            // En la pantalla main, mostrar diálogo de confirmación para salir
            return await _showExitDialog(context) ?? false;
          },
          child: const MainScreen(),
        ),
      ),
      
      // === AUTENTICACIÓN ===
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/test-login',
        builder: (context, state) => const TestLoginScreen(),
      ),
      GoRoute(
        path: '/api-test',
        builder: (context, state) => const ApiTestScreen(),
      ),
      
      // === SERVICIOS ===
      GoRoute(
        path: '/servicios',
        builder: (context, state) => const ServicesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final service = state.extra as ServiceModel?;
              if (service != null) {
                return ServiceDetailScreen(service: service);
              }
              return const PlaceholderScreen(title: 'Detalle de Servicio');
            },
          ),
        ],
      ),
      
      // === PRODUCTOS ===
      GoRoute(
        path: '/productos',
        builder: (context, state) => const ProductsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final product = state.extra as Producto?;
              if (product != null) {
                return ProductDetailScreen(product: product);
              }
              return const PlaceholderScreen(title: 'Detalle de Producto');
            },
          ),
        ],
      ),
      
      // === CATEGORÍAS ===
      GoRoute(
        path: '/categoria/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return const ProductsScreen(); // Por ahora redirigimos a productos
        },
      ),
      
      // === AGENDAMIENTOS ===
      GoRoute(
        path: '/citas',
        builder: (context, state) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: '/agendar',
        builder: (context, state) {
          final service = state.extra as ServiceModel?;
          return BookAppointmentScreen(selectedService: service);
        },
      ),
      
      // === CARRITO Y CHECKOUT ===
      GoRoute(
        path: '/carrito',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      
      // === PERFIL ===
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'direcciones',
            builder: (context, state) => const AddressesScreen(),
          ),
          GoRoute(
            path: 'favoritos',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: 'historial',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'metodos-pago',
            builder: (context, state) => const PaymentMethodsScreen(),
          ),
          GoRoute(
            path: 'ayuda',
            builder: (context, state) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: 'configuracion',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
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