import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/onboarding_page_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'image': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?fit=crop&w=600&h=400',
      'title': 'Bienvenido a BarberMusic & Spa',
      'description': 'Descubre la experiencia perfecta de cuidado personal y relajación en un solo lugar.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1599387823531-b44c6a6f8737?fit=crop&w=600&h=400',
      'title': 'Servicios Profesionales',
      'description': 'Nuestros expertos te ofrecen servicios de corte, barba, spa y tratamientos premium.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?fit=crop&w=600&h=400',
      'title': 'Reserva Fácil',
      'description': 'Agenda tus citas de manera rápida y sencilla desde la comodidad de tu teléfono.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _goToHome(),
                    child: const Text('Saltar'),
                  ),
                ],
              ),
            ),
            
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    image: _onboardingData[index]['image'],
                    title: _onboardingData[index]['title'],
                    description: _onboardingData[index]['description'],
                  );
                },
              ),
            ),
            
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicators(),
              ),
            ),
            
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous button
                  _currentPage > 0
                      ? TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text('Anterior'),
                        )
                      : const SizedBox(width: 80),
                  
                  // Next/Finish button
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _goToHome();
                      }
                    },
                    child: Text(
                      _currentPage < _onboardingData.length - 1 
                          ? 'Siguiente' 
                          : 'Comenzar',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _onboardingData.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i 
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
        ),
      );
    }
    return indicators;
  }

  void _goToHome() {
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
