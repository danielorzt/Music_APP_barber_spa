import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Colores principales de la página web
  static const Color primaryRed = Color(0xFFDC3545);
  static const Color primaryRedDark = Color(0xFFC82333);
  static const Color primaryRedLight = Color(0xFFFDEDED);
  static const Color primaryRedSoft = Color(0xFFF28484);
  
  // Paleta completa de colores
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey100 = Color(0xFFF8F9FA);
  static const Color grey200 = Color(0xFFE9ECEF);
  static const Color grey300 = Color(0xFFDEE2E6);
  static const Color grey400 = Color(0xFFCED4DA);
  static const Color grey500 = Color(0xFFADB5BD);
  static const Color grey600 = Color(0xFF6C757D);
  static const Color grey700 = Color(0xFF495057);
  static const Color grey800 = Color(0xFF343A40);
  static const Color grey900 = Color(0xFF212529);
  
  // Colores específicos para tema oscuro
  static const Color darkBackground = Color(0xFF000000);  // Negro puro
  static const Color darkSurface = Color(0xFF121212);     // Negro con ligero matiz
  static const Color darkCard = Color(0xFF1E1E1E);        // Negro suave para tarjetas
  static const Color darkInput = Color(0xFF2A2A2A);       // Negro para inputs
  static const Color darkBorder = Color(0xFF404040);      // Bordes sutiles

  // Tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryRed),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.light,
        primary: primaryRed,
        onPrimary: white,
        secondary: primaryRedSoft,
        onSecondary: white,
        surface: white,
        onSurface: grey900,
        background: grey100,
        onBackground: grey900,
        error: primaryRed,
        onError: white,
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: grey900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: grey900,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: grey900),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: white,
        elevation: 2,
        shadowColor: grey400,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return primaryRedDark;
              }
              if (states.contains(MaterialState.hovered)) {
                return primaryRedDark;
              }
              if (states.contains(MaterialState.disabled)) {
                return grey400;
              }
              return primaryRed;
            },
          ),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryRed,
        unselectedItemColor: grey500,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: white,
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: grey900,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: grey900,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: grey900,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: grey900,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: grey900,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: grey800,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: grey700,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: grey600,
        ),
      ),

      iconTheme: const IconThemeData(
        color: grey700,
        size: 24,
      ),
    );
  }

  // Tema oscuro con negros profundos
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(primaryRed),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.dark,
        primary: primaryRed,
        onPrimary: white,
        secondary: primaryRedSoft,
        onSecondary: black,
        surface: darkSurface,
        onSurface: white,
        background: darkBackground,
        onBackground: white,
        error: primaryRed,
        onError: white,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: white),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 4,
        shadowColor: black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return primaryRedDark;
              }
              if (states.contains(MaterialState.hovered)) {
                return primaryRedDark;
              }
              if (states.contains(MaterialState.disabled)) {
                return darkBorder;
              }
              return primaryRed;
            },
          ),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryRed,
        unselectedItemColor: grey400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: darkSurface,
      ),

      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: white,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: grey200,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: grey300,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: grey400,
        ),
      ),

      iconTheme: const IconThemeData(
        color: grey300,
        size: 24,
      ),
    );
  }

  // Helper para crear MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}