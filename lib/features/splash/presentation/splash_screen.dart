import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotateController;
  late AnimationController _slideController;
  
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Controlador de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Controlador de escala
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Controlador de rotación
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Controlador de deslizamiento
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    // Animaciones
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.bounceOut,
    ));
    
    // Iniciar animaciones secuencialmente
    _startAnimations();
    
    // Navegar a main después de 3.5 segundos
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go('/main');
      }
    });
  }

  void _startAnimations() async {
    // Iniciar fade
    _fadeController.forward();
    
    // Esperar un poco y iniciar escala
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    
    // Esperar y iniciar rotación
    await Future.delayed(const Duration(milliseconds: 500));
    _rotateController.repeat();
    
    // Esperar y iniciar deslizamiento
    await Future.delayed(const Duration(milliseconds: 800));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotateController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : const Color(0xFFDC3545);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Logo con animaciones
              AnimatedBuilder(
                animation: Listenable.merge([_fadeController, _scaleController, _rotateController]),
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 0.1, // Rotación sutil
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: iconColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 5,
                              ),
                            ],
                            border: Border.all(
                              color: iconColor.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.spa,
                            size: 70,
                            color: iconColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Título principal con animación de slide
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'BarberMusic & Spa',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: iconColor.withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtítulo con animación de fade
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Tu experiencia premium te espera',
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor.withOpacity(0.7),
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Indicador de carga con animación de pulso
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1.2),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                              strokeWidth: 3,
                            ),
                          );
                        },
                        onEnd: () {
                          // Reiniciar la animación de pulso
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Texto de carga con animación de fade
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Cargando...',
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
