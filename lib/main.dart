import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/core/theme/theme_provider.dart';
import 'package:music_app/core/services/api_service.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/home.dart';
import 'package:music_app/features/services/presentation/services_screen.dart';
import 'package:music_app/features/cart/presentation/cart_screen.dart';
import 'package:music_app/features/profile/presentation/profile_screen.dart';
import 'package:music_app/features/auth/presentation/login_screen.dart';
import 'package:music_app/features/auth/presentation/register_screen.dart';

// Importar repositorios
import 'package:music_app/features/services/repositories/services_repository.dart';
import 'package:music_app/features/cart/repositories/cart_repository.dart';
import 'package:music_app/features/profile/repositories/user_repository.dart';
import 'package:music_app/features/promotions/repositories/promotions_repository.dart';
import 'package:music_app/features/auth/repositories/auth_repository.dart';

// Importar providers
import 'package:music_app/features/auth/providers/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Core providers
        Provider(create: (_) => ApiService()),

        // Repositorios
        Provider(
          create: (context) => ServicesRepository(context.read<ApiService>()),
        ),
        Provider(
          create: (_) => CartRepository(),
        ),
        Provider(
          create: (context) => UserRepository(context.read<ApiService>()),
        ),
        Provider(
          create: (context) => PromotionsRepository(context.read<ApiService>()),
        ),
        Provider(
          create: (context) => AuthRepository(context.read<ApiService>()),
        ),

        // Proveedores de estado
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => CartProvider(context.read<CartRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
            context.read<UserRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'BarberMusic&Spa',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/services': (context) => const ServicesScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFf9b99c),
        secondary: Color(0xFF5dc1b9),
        tertiary: Color(0xFF0fe1d0),
        surface: Colors.white,
        background: Color(0xFFf5f5f5),
        error: Color(0xFFc31c1c),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFf9b99c),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFee8c3a),
        secondary: Color(0xFF0fe1d0),
        surface: Color(0xFF1e1e1e),
        background: Color(0xFF121212),
        onPrimary: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}