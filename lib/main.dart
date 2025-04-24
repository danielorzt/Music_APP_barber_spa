// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/themes.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/products/providers/products_provider.dart';
import 'features/services/providers/services_provider.dart';
import 'features/cart/providers/cart_provider.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/products/presentation/products_screen.dart';
import 'features/products/presentation/product_detail_screen.dart';
import 'features/services/presentation/services_screen.dart';
import 'features/services/presentation/service_detail_screen.dart';
import 'features/cart/presentation/cart_screen.dart';
import 'features/profile/presentation/profile_screen.dart';
import 'features/appointments/presentation/appointments_screen.dart';
// Otras importaciones que necesites

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
          // lib/main.dart (continuación)
          ChangeNotifierProvider(create: (_) => ProductsProvider()),
          ChangeNotifierProvider(create: (_) => ServicesProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
          ChangeNotifierProvider(create: (_) => BranchesProvider()),
        ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'BarberMusic & Spa',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          localizationsDelegates: const [
            // Asegúrate de inicializar los delegates para la localización
            // GlobalMaterialLocalizations.delegate,
            // GlobalWidgetsLocalizations.delegate,
            // GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'ES'), // Español
            Locale('en', 'US'), // Inglés
          ],
          initialRoute: '/',
          routes: {
            '/': (_) => const SplashScreen(),
            '/home': (_) => const HomeScreen(),
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/products': (_) => const ProductsScreen(),
            '/services': (_) => const ServicesScreen(),
            '/cart': (_) => const CartScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/appointments': (_) => const AppointmentsScreen(),
            '/book-appointment': (_) => const BookAppointmentScreen(),
            '/change-password': (_) => const ChangePasswordScreen(),
            '/purchase-history': (_) => const PurchaseHistoryScreen(),
            '/order-success': (_) => const OrderSuccessScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/product-detail') {
              final int productId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => ProductDetailScreen(productId: productId),
              );
            } else if (settings.name == '/service-detail') {
              final int serviceId = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => ServiceDetailScreen(serviceId: serviceId),
              );
            } else if (settings.name == '/paypal-webview') {
              final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => PayPalWebViewScreen(
                  url: args['url'] as String,
                  orderId: args['orderId'] as int,
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}

// Agreguemos una pantalla de Splash para iniciar la app
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // Simular carga

    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // Esperar a que se cargue el estado de autenticación
      if (authProvider.status == AuthStatus.initial) {
        await Future.doWhile(() => Future.delayed(const Duration(milliseconds: 100))
            .then((_) => authProvider.status == AuthStatus.initial));
      }

      // Navegar a la pantalla apropiada
      Navigator.of(context).pushReplacementNamed(
        authProvider.isAuthenticated ? '/home' : '/home', // Cambia el segundo '/home' a '/login' si quieres forzar login
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Asegúrate de tener esta imagen
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 24),
            const Text(
              'BarberMusic & Spa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}