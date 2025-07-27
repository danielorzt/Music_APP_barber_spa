import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Screens - Auth
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';

// Screens - Main
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';

// Screens - Cliente
import '../../features/appointments/presentation/appointments_screen.dart';
import '../../features/appointments/presentation/book_appointment_screen.dart';
import '../../features/products/presentation/product_detail_screen.dart';
import '../../features/products/presentation/category_items_screen.dart';
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
              context.go('/home');
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
              onPressed: () => context.go('/home'),
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
      final publicRoutes = ['/splash', '/onboarding', '/home', '/login', '/register', '/servicios', '/productos', '/categoria'];
      
      // Si la ruta actual es pública, permitir acceso
      if (publicRoutes.any((route) => state.fullPath?.startsWith(route) == true)) {
        return null;
      }
      
      // Para rutas protegidas del cliente
      final protectedRoutes = ['/perfil', '/citas', '/carrito', '/checkout'];
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
        path: '/home',
        builder: (context, state) => WillPopScope(
          onWillPop: () async {
            // En la pantalla home, mostrar diálogo de confirmación para salir
            return await _showExitDialog(context) ?? false;
          },
          child: const HomeScreen(),
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
      
      // === SERVICIOS ===
      GoRoute(
        path: '/servicios',
        builder: (context, state) => const ServicesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ServiceDetailScreen(serviceId: id);
            },
          ),
        ],
      ),
      
      // === PRODUCTOS ===
      GoRoute(
        path: '/productos',
        builder: (context, state) => const CategoryItemsScreen(categoryName: 'Todos'),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductDetailScreen(productId: id);
            },
          ),
        ],
      ),
      
      // === CATEGORÍAS ===
      GoRoute(
        path: '/categoria/:categoryName',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return CategoryItemsScreen(categoryName: categoryName);
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
      
      // === CITAS ===
      GoRoute(
        path: '/citas',
        builder: (context, state) => const AppointmentsScreen(),
        routes: [
          GoRoute(
            path: 'agendar',
            builder: (context, state) => const BookAppointmentScreen(),
          ),
          // Placeholder para citas individuales
          GoRoute(
            path: ':id',
            builder: (context, state) {
              return const PlaceholderScreen(title: 'Detalle de Cita');
            },
          ),
        ],
      ),
      
      // === PERFIL ===
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'historial',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: 'favoritos',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: 'direcciones',
            builder: (context, state) => const AddressesScreen(),
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
      
      // === EXTRAS (Placeholders por ahora) ===
      GoRoute(
        path: '/galeria',
        builder: (context, state) => const PlaceholderScreen(title: 'Galería'),
      ),
      GoRoute(
        path: '/notificaciones',
        builder: (context, state) => const PlaceholderScreen(title: 'Notificaciones'),
      ),
    ],
  );

  // Función para mostrar diálogo de salida
  static Future<bool?> _showExitDialog(BuildContext context) {
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
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop(); // Cierra la aplicación
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
}