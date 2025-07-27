import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:music_app/config/router/app_router.dart';
import 'package:music_app/config/theme/app_theme.dart';
import 'package:music_app/core/repositories/auth_repository.dart';
import 'package:music_app/core/repositories/product_repository.dart';
import 'package:music_app/core/auth/session_bloc.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';
import 'package:music_app/features/services/providers/services_provider.dart';
import 'package:music_app/features/branches/providers/branches_provider.dart';

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
        ChangeNotifierProvider<ServicesProvider>(
          create: (context) => ServicesProvider(),
        ),
        ChangeNotifierProvider<BranchesProvider>(
          create: (context) => BranchesProvider(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(),
        ),
        BlocProvider<SessionBloc>(
          create: (context) => SessionBloc(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'BarberMusic & Spa',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
