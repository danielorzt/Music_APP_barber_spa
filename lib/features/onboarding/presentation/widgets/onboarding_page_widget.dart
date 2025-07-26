import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color backgroundColor;
  final bool isLastPage;

  const OnboardingPageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            backgroundColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Imagen o ícono grande
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: backgroundColor.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    _getIconForPage(imagePath),
                    size: 150,
                    color: backgroundColor,
                  ),
                ),
              ).animate()
                .fadeIn(duration: 800.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms),
              const SizedBox(height: 50),
              // Título
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: backgroundColor.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ).animate()
                .fadeIn(delay: 400.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
              const SizedBox(height: 20),
              // Descripción
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  height: 1.6,
                  letterSpacing: 0.3,
                ),
              ).animate()
                .fadeIn(delay: 600.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForPage(String key) {
    switch (key) {
      case 'reserva':
        return Icons.event_available_rounded;
      case 'productos':
        return Icons.shopping_basket_rounded;
      case 'ubicaciones':
        return Icons.place_rounded;
      case 'pagos':
        return Icons.credit_card_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}
