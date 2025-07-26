import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Reserva con Facilidad',
      'description': 'Programa tus citas de barbería y spa en segundos. Elige tu servicio favorito, fecha y hora que más te convenga.',
      'imagePath': 'reserva',
      'color': const Color(0xFF4A90E2),
    },
    {
      'title': 'Productos Premium',
      'description': 'Explora nuestra exclusiva colección de productos para el cuidado personal. Calidad garantizada con envío a domicilio.',
      'imagePath': 'productos',
      'color': const Color(0xFFE27D4A),
    },
    {
      'title': 'Múltiples Sucursales',
      'description': 'Encuentra la sucursal más cercana a ti. Con ubicaciones estratégicas en toda la ciudad para tu comodidad.',
      'imagePath': 'ubicaciones',
      'color': const Color(0xFF50C878),
    },
    {
      'title': 'Experiencia Premium',
      'description': 'Disfruta de un servicio de primera clase con los mejores profesionales y un ambiente relajante.',
      'imagePath': 'pagos',
      'color': const Color(0xFF9B59B6),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Páginas del onboarding
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageWidget(
                title: _pages[index]['title'],
                description: _pages[index]['description'],
                imagePath: _pages[index]['imagePath'],
                backgroundColor: _pages[index]['color'],
                isLastPage: index == _pages.length - 1,
              );
            },
          ),
          // Indicador de páginas y botones
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Indicador de páginas
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: WormEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    spacing: 16,
                    dotColor: Colors.grey.shade300,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 40),
                // Botones de navegación
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Botón Skip
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Omitir',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      // Botón Next/Comenzar
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage == _pages.length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage]['color'],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentPage == _pages.length - 1 ? 'Comenzar' : 'Siguiente',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
