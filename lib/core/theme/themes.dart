import 'package:flutter/material.dart';

class AppThemes {
  // Tema Claro
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFf9b99c),
        secondary: Color(0xFF5dc1b9),
        tertiary: Color(0xFF0fe1d0),
        surface: Colors.white,
        error: Color(0xFFc31c1c),
        onPrimary: Colors.black,
        onSecondary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFf9b99c),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Tema Oscuro
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFee8c3a),
        secondary: Color(0xFF0fe1d0),
        surface: Color(0xFF1e1e1e),
        onPrimary: Colors.white,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}