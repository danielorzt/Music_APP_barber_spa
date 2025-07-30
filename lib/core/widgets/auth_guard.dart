import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String? redirectTo;
  final bool showDialog;

  const AuthGuard({
    super.key,
    required this.child,
    this.redirectTo,
    this.showDialog = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          if (showDialog) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showLoginRequiredDialog(context);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(redirectTo ?? '/login');
            });
          }
          return const SizedBox.shrink();
        }
        return child;
      },
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: const Color(0xFFDC3545),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Inicio de Sesión Requerido',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Para acceder a esta funcionalidad, necesitas iniciar sesión en tu cuenta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go('/main');
                            },
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC3545),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AuthRequiredButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isAuthenticated;
  final VoidCallback? onAuthRequired;

  const AuthRequiredButton({
    super.key,
    required this.child,
    this.onPressed,
    required this.isAuthenticated,
    this.onAuthRequired,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isAuthenticated ? onPressed : () {
        if (onAuthRequired != null) {
          onAuthRequired!();
        } else {
          _showLoginRequiredDialog(context);
        }
      },
      child: child,
    );
  }

  void _showLoginRequiredDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: const Color(0xFFDC3545),
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Inicio de Sesión Requerido',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Para realizar esta acción, necesitas iniciar sesión en tu cuenta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.go('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC3545),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 