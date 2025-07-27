import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }
enum AppLanguage { spanish, english, portuguese }

class SettingsProvider with ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'app_language';

  AppThemeMode _themeMode = AppThemeMode.system;
  AppLanguage _language = AppLanguage.spanish;
  SharedPreferences? _prefs;

  AppThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;

  // Getters para uso en la UI
  String get themeModeString {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Claro';
      case AppThemeMode.dark:
        return 'Oscuro';
      case AppThemeMode.system:
        return 'Sistema';
    }
  }

  String get languageString {
    switch (_language) {
      case AppLanguage.spanish:
        return 'Español';
      case AppLanguage.english:
        return 'English';
      case AppLanguage.portuguese:
        return 'Português';
    }
  }

  String get languageCode {
    switch (_language) {
      case AppLanguage.spanish:
        return 'es';
      case AppLanguage.english:
        return 'en';
      case AppLanguage.portuguese:
        return 'pt';
    }
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Cargar tema
    final themeIndex = _prefs?.getInt(_themeModeKey) ?? 2; // Default: system
    _themeMode = AppThemeMode.values[themeIndex];

    // Cargar idioma
    final languageIndex = _prefs?.getInt(_languageKey) ?? 0; // Default: spanish
    _language = AppLanguage.values[languageIndex];

    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _prefs?.setInt(_themeModeKey, mode.index);
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language != language) {
      _language = language;
      await _prefs?.setInt(_languageKey, language.index);
      notifyListeners();
    }
  }

  // Método para obtener el ThemeMode de Flutter basado en nuestro enum
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  // Método para obtener el Locale basado en el idioma
  Locale get locale {
    switch (_language) {
      case AppLanguage.spanish:
        return const Locale('es', 'ES');
      case AppLanguage.english:
        return const Locale('en', 'US');
      case AppLanguage.portuguese:
        return const Locale('pt', 'BR');
    }
  }
} 