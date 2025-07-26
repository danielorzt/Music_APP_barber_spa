import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/auth/screens/login_screen.dart';
import 'package:music_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:music_app/features/splash/presentation/splash_screen.dart';
import 'package:music_app/features/products/screens/product_list_screen.dart';
import 'package:music_app/core/api/api_interceptors.dart';

// --- Marcadores de posición de pantalla ---
// Reemplazaremos estos con las pantallas reales en los próximos pasos.
class HomeScreen extends StatelessWidget { const HomeScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Home Screen'))); }

class ProductDetailScreen extends StatelessWidget { final String id; const ProductDetailScreen({super.key, required this.id}); @override Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Product Detail Screen for ID: $id'))); }
class ProfileScreen extends StatelessWidget { const ProfileScreen({super.key}); @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Profile Screen'))); }

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
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final isLoggedIn = await ApiInterceptor.hasValidToken();
      final location = state.matchedLocation;

      final publicRoutes = ['/splash', '/onboarding', '/login'];

      // Si el usuario no está logueado y intenta acceder a una ruta protegida
      if (!isLoggedIn && !publicRoutes.contains(location)) {
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