import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:music_app/config/router/app_router.dart';
import 'package:music_app/config/theme/app_theme.dart';
import 'package:music_app/core/repositories/auth_repository.dart';
import 'package:music_app/core/repositories/product_repository.dart';
import 'package:music_app/core/auth/session_bloc.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => SessionBloc(
          authRepository: context.read<AuthRepository>(),
        )..add(SessionStarted()),
        child: MaterialApp.router(
          title: 'BarberMusic & Spa',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
