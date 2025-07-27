import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

// Config
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';

// Providers
import 'features/auth/providers/auth_provider.dart';
import 'core/providers/settings_provider.dart';
import 'features/appointments/providers/appointments_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // En caso de error con Firebase, continuar sin él
    debugPrint('Firebase initialization failed: $e');
  }

  // Inicializar el provider de configuraciones
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();

  runApp(MyApp(settingsProvider: settingsProvider));
}

class MyApp extends StatelessWidget {
  final SettingsProvider settingsProvider;

  const MyApp({super.key, required this.settingsProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp.router(
            title: 'BarberMusic & Spa',
            debugShowCheckedModeBanner: false,
            
            // Configuración de tema
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.flutterThemeMode,
            
            // Configuración de idioma y localizaciones
            locale: settings.locale,
            supportedLocales: const [
              Locale('es', 'ES'), // Español
              Locale('en', 'US'), // Inglés
              Locale('pt', 'BR'), // Portugués
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Router
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
