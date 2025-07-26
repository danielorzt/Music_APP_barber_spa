import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Paleta de colores de lujo
  static const Color primaryColor = Color(0xFF1A1A1A); // Negro profundo
  static const Color accentColor = Color(0xFFD4AF37);  // Dorado
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFF5F5F5); // Un gris muy claro para fondos
  static const Color textColor = Color(0xFF333333); // Gris oscuro para texto

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        onPrimary: whiteColor,
        onSecondary: primaryColor,
        surface: whiteColor,
        onSurface: textColor,
        error: Colors.redAccent,
        onError: whiteColor,
      ),

      // Estilos de texto
      textTheme: GoogleFonts.montserratTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
          bodyLarge: TextStyle(fontSize: 16, color: textColor),
          bodyMedium: TextStyle(fontSize: 14, color: textColor),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: whiteColor),
        ),
      ),

      // Estilos de botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),

      // Estilos de campos de texto
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: accentColor, width: 2.0),
        ),
        labelStyle: const TextStyle(color: textColor),
      ),

      // Estilo de la barra de aplicación
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: whiteColor),
        iconTheme: const IconThemeData(color: whiteColor),
      ),
    );
  }
}