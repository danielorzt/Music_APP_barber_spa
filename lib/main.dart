import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'core/providers/settings_provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/appointments/providers/appointments_provider.dart';
import 'features/services/providers/services_provider.dart';
import 'features/products/providers/products_provider.dart';
import 'features/cart/providers/cart_provider.dart';
import 'config/router/app_router.dart';
import 'features/splash/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicializar providers
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();
  final authProvider = AuthProvider();

  runApp(MyApp(
    settingsProvider: settingsProvider,
    authProvider: authProvider,
  ));
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;
  final AuthProvider authProvider;

  const MyApp({
    super.key,
    required this.settingsProvider,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp.router(
            title: 'Barber Music Spa',
            debugShowCheckedModeBanner: false,
            themeMode: settings.flutterThemeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            routerConfig: AppRouter.router,
            locale: settings.locale,
            supportedLocales: const [
              Locale('es', 'ES'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
