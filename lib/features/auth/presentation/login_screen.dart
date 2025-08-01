// lib/features/auth/presentation/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _shakeController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
    
    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  void _showErrorShake() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // Logo y Título con animaciones
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC3545),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFDC3545).withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.spa,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          Text(
                            'Bienvenido',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFDC3545),
                              fontSize: 32,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 8),
                          
                          Text(
                            'Inicia sesión en tu cuenta',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Campos de formulario con animaciones
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // Campo Email
                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_shakeAnimation.value * 10 * (1 - _shakeAnimation.value), 0),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDarkMode ? Colors.white30 : Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFDC3545),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Por favor ingresa un email válido';
                                  }
                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Campo Contraseña
                        AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_shakeAnimation.value * 10 * (1 - _shakeAnimation.value), 0),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDarkMode ? Colors.white30 : Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFDC3545),
                                      width: 2,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor ingresa tu contraseña';
                                  }
                                  if (value.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Enlace "Olvidé mi contraseña"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Función en desarrollo'),
                          backgroundColor: const Color(0xFFDC3545),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: const Color(0xFFDC3545),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Botón Iniciar Sesión
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      bool success;
                                      
                                      // Intentar login normal primero
                                      success = await authProvider.login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                      
                                      // Si falla y es por conectividad, intentar login mock
                                      if (!success && !authProvider.isApiAvailable) {
                                        print('🔄 Intentando login con datos mock...');
                                        success = await authProvider.loginWithMockData(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                      }
                                      
                                      if (success && mounted) {
                                        // Mostrar éxito con animación
                                        String message = authProvider.isApiAvailable 
                                            ? 'Inicio de sesión exitoso'
                                            : 'Modo offline - Datos de prueba';
                                        
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(Icons.check_circle, color: Colors.white),
                                                const SizedBox(width: 10),
                                                Expanded(child: Text(message)),
                                              ],
                                            ),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        context.go('/main');
                                      } else if (mounted) {
                                        // Mostrar error con shake
                                        _showErrorShake();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(Icons.error, color: Colors.white),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    authProvider.error ?? 'Error al iniciar sesión',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: const Color(0xFFDC3545),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      _showErrorShake();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC3545),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              shadowColor: const Color(0xFFDC3545).withOpacity(0.3),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Iniciar Sesión',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Link para registro
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿No tienes una cuenta?',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push('/register');
                            },
                            child: const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                color: Color(0xFFDC3545),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          context.push('/api-test');
                        },
                        child: Text(
                          '🔧 Configuración API',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}