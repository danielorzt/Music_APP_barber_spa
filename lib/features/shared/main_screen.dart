// lib/features/shared/main_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../home/presentation/home_screen.dart';
import '../services/presentation/services_screen.dart';
import '../products/presentation/products_screen.dart';
import '../profile/presentation/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String? initialPath;
  
  const MainScreen({
    super.key,
    this.initialPath,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ServicesScreen(),
    const ProductsScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.spa_outlined),
      activeIcon: Icon(Icons.spa),
      label: 'Servicios',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag_outlined),
      activeIcon: Icon(Icons.shopping_bag),
      label: 'Productos',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    
    // Configurar índice inicial basado en la ruta
    if (widget.initialPath != null) {
      _setInitialIndex(widget.initialPath!);
    }
  }

  void _setInitialIndex(String path) {
    switch (path) {
      case '/':
      case '/home':
        _currentIndex = 0;
        break;
      case '/services':
        _currentIndex = 1;
        break;
      case '/products':
        _currentIndex = 2;
        break;
      case '/profile':
        _currentIndex = 3;
        break;
      default:
        _currentIndex = 0;
    }
    
    if (mounted) {
      _pageController = PageController(initialPage: _currentIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    // Actualizar la URL sin navigation (opcional)
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/services');
        break;
      case 2:
        context.go('/products');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  void _onPageChanged(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFDC3545),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          backgroundColor: Colors.white,
          elevation: 8,
          items: _navigationItems,
        ),
      ),
    );
  }
}