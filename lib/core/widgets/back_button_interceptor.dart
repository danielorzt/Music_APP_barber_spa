import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget que intercepta el botón "atrás" de Android y maneja la navegación correctamente
class BackButtonInterceptor extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBackPressed;
  final bool shouldInterceptBack;
  final String? fallbackRoute;

  const BackButtonInterceptor({
    super.key,
    required this.child,
    this.onBackPressed,
    this.shouldInterceptBack = true,
    this.fallbackRoute,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldInterceptBack) {
      return child;
    }

    return WillPopScope(
      onWillPop: () async {
        // Si hay un callback personalizado, ejecutarlo
        if (onBackPressed != null) {
          onBackPressed!();
          return false; // No permite el pop por defecto
        }

        // Verificar si go_router puede manejar el "back"
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pop();
          return false; // No permite el pop por defecto del sistema
        }

        // Si hay una ruta de fallback, navegar a ella
        if (fallbackRoute != null) {
          context.go(fallbackRoute!);
          return false;
        }

        // Si llegamos aquí y estamos en la pantalla principal, mostrar diálogo de salida
        final currentRoute = GoRouterState.of(context).fullPath;
        if (currentRoute == '/home' || currentRoute == '/') {
          return await _showExitDialog(context) ?? false;
        }

        // Por defecto, navegar a home
        context.go('/home');
        return false;
      },
      child: child,
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
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
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }
} 