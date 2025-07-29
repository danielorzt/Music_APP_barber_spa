import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';
import 'package:music_app/features/home/presentation/home_screen.dart';
import 'package:music_app/features/services/presentation/services_screen.dart';
import 'package:music_app/features/products/presentation/products_screen.dart';
import 'package:music_app/features/appointments/presentation/appointments_screen.dart';
import 'package:music_app/features/profile/presentation/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ServicesScreen(),
    const ProductsScreen(),
    const AppointmentsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      
      // Reiniciar animación para la nueva pantalla
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final isAuthenticated = authProvider.isAuthenticated;
          
          return Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAnimatedTabItem(
                      icon: Icons.home,
                      label: 'Inicio',
                      index: 0,
                      isSelected: _currentIndex == 0,
                    ),
                    _buildAnimatedTabItem(
                      icon: Icons.spa,
                      label: 'Servicios',
                      index: 1,
                      isSelected: _currentIndex == 1,
                    ),
                    _buildAnimatedTabItem(
                      icon: Icons.shopping_bag,
                      label: 'Productos',
                      index: 2,
                      isSelected: _currentIndex == 2,
                    ),
                    _buildAnimatedTabItem(
                      icon: isAuthenticated ? Icons.calendar_today : Icons.calendar_today_outlined,
                      label: 'Mis Citas',
                      index: 3,
                      isSelected: _currentIndex == 3,
                    ),
                    _buildAnimatedTabItem(
                      icon: isAuthenticated ? Icons.person : Icons.person_outline,
                      label: 'Perfil',
                      index: 4,
                      isSelected: _currentIndex == 4,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedTabItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDC3545).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFFDC3545) : Colors.grey[600],
                size: isSelected ? 28 : 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFDC3545) : Colors.grey[600],
              ),
              child: Text(label),
            ),
            if (isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC3545),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 