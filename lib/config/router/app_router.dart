import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music_app/features/auth/screens/login_screen.dart';
import 'package:music_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:music_app/features/splash/presentation/splash_screen.dart';
import 'package:music_app/features/products/screens/product_list_screen.dart';
import 'package:music_app/features/home/presentation/home_screen.dart';
import 'package:music_app/features/profile/presentation/profile_screen.dart';
import 'package:music_app/features/profile/presentation/history_screen.dart';
import 'package:music_app/features/profile/presentation/favorites_screen.dart';
import 'package:music_app/features/profile/presentation/addresses_screen.dart';
import 'package:music_app/features/profile/presentation/payment_methods_screen.dart';
import 'package:music_app/features/profile/presentation/help_support_screen.dart';
import 'package:music_app/features/cart/presentation/cart_screen.dart';
import 'package:music_app/features/appointments/presentation/appointments_screen.dart';
import 'package:music_app/features/appointments/presentation/book_appointment_screen.dart';
// import 'package:music_app/core/api/api_interceptors.dart';

// --- Marcadores de posición de pantalla ---
// Reemplazaremos estos con las pantallas reales en los próximos pasos.
class ProductDetailScreen extends StatelessWidget { final String id; const ProductDetailScreen({super.key, required this.id}); @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Product Detail Screen for ID: $id'))); }

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
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
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/productos',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductDetailScreen(id: id);
            },
          ),
        ],
      ),
      // Rutas protegidas que requieren autenticación
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
        ],
      ),
      GoRoute(
        path: '/carrito',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/citas',
        builder: (context, state) => const AppointmentsScreen(),
        routes: [
          GoRoute(
            path: 'agendar',
            builder: (context, state) => const BookAppointmentScreen(),
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      // Función simple para verificar si hay token
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');
      final isLoggedIn = token != null && token.isNotEmpty;
      
      final location = state.matchedLocation;

      // Rutas públicas (no requieren autenticación)
      final publicRoutes = [
        '/splash', 
        '/onboarding', 
        '/login',
        '/home',
        '/productos',
      ];

      // Rutas protegidas (requieren autenticación)
      final protectedRoutes = [
        '/perfil',
        '/carrito',
        '/citas',
      ];

      // Si el usuario no está logueado y intenta acceder a una ruta protegida
      if (!isLoggedIn && protectedRoutes.any((route) => location.startsWith(route))) {
        return '/login'; // Redirigir a la pantalla de login
      }

      // Si el usuario está logueado y trata de ir a /login, redirigir a /home
      if (isLoggedIn && location == '/login') {
        return '/home';
      }

      // No se necesita redirección en otros casos
      return null;
    },
  );
}