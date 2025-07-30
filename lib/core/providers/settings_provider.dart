import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }
enum AppLanguage { spanish, english, portuguese }

class SettingsProvider with ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'app_language';
  static const String _appointmentRemindersKey = 'appointment_reminders';
  static const String _promotionNotificationsKey = 'promotion_notifications';
  static const String _orderUpdatesKey = 'order_updates';
  static const String _biometricAuthKey = 'biometric_auth';
  static const String _locationSharingKey = 'location_sharing';
  static const String _analyticsEnabledKey = 'analytics_enabled';

  AppThemeMode _themeMode = AppThemeMode.system;
  AppLanguage _language = AppLanguage.spanish;
  
  // Configuraciones de notificaciones
  bool _appointmentReminders = true;
  bool _promotionNotifications = true;
  bool _orderUpdates = true;
  
  // Configuraciones de privacidad y seguridad
  bool _biometricAuth = false;
  bool _locationSharing = true;
  bool _analyticsEnabled = true;
  
  SharedPreferences? _prefs;

  AppThemeMode get themeMode => _themeMode;
  AppLanguage get language => _language;

  // Getters para notificaciones
  bool get appointmentReminders => _appointmentReminders;
  bool get promotionNotifications => _promotionNotifications;
  bool get orderUpdates => _orderUpdates;

  // Getters para privacidad y seguridad
  bool get biometricAuth => _biometricAuth;
  bool get locationSharing => _locationSharing;
  bool get analyticsEnabled => _analyticsEnabled;

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

    // Cargar configuraciones de notificaciones
    _appointmentReminders = _prefs?.getBool(_appointmentRemindersKey) ?? true;
    _promotionNotifications = _prefs?.getBool(_promotionNotificationsKey) ?? true;
    _orderUpdates = _prefs?.getBool(_orderUpdatesKey) ?? true;

    // Cargar configuraciones de privacidad
    _biometricAuth = _prefs?.getBool(_biometricAuthKey) ?? false;
    _locationSharing = _prefs?.getBool(_locationSharingKey) ?? true;
    _analyticsEnabled = _prefs?.getBool(_analyticsEnabledKey) ?? true;

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

  // Métodos para configuraciones de notificaciones
  Future<void> setAppointmentReminders(bool value) async {
    if (_appointmentReminders != value) {
      _appointmentReminders = value;
      await _prefs?.setBool(_appointmentRemindersKey, value);
      notifyListeners();
    }
  }

  Future<void> setPromotionNotifications(bool value) async {
    if (_promotionNotifications != value) {
      _promotionNotifications = value;
      await _prefs?.setBool(_promotionNotificationsKey, value);
      notifyListeners();
    }
  }

  Future<void> setOrderUpdates(bool value) async {
    if (_orderUpdates != value) {
      _orderUpdates = value;
      await _prefs?.setBool(_orderUpdatesKey, value);
      notifyListeners();
    }
  }

  // Métodos para configuraciones de privacidad y seguridad
  Future<void> setBiometricAuth(bool value) async {
    if (_biometricAuth != value) {
      _biometricAuth = value;
      await _prefs?.setBool(_biometricAuthKey, value);
      notifyListeners();
    }
  }

  Future<void> setLocationSharing(bool value) async {
    if (_locationSharing != value) {
      _locationSharing = value;
      await _prefs?.setBool(_locationSharingKey, value);
      notifyListeners();
    }
  }

  Future<void> setAnalyticsEnabled(bool value) async {
    if (_analyticsEnabled != value) {
      _analyticsEnabled = value;
      await _prefs?.setBool(_analyticsEnabledKey, value);
      notifyListeners();
    }
  }

  // Métodos para compatibilidad con Flutter
  Future<void> setFlutterThemeMode(ThemeMode mode) async {
    AppThemeMode appMode;
    switch (mode) {
      case ThemeMode.light:
        appMode = AppThemeMode.light;
        break;
      case ThemeMode.dark:
        appMode = AppThemeMode.dark;
        break;
      case ThemeMode.system:
        appMode = AppThemeMode.system;
        break;
    }
    await setThemeMode(appMode);
  }

  Future<void> setLocale(Locale locale) async {
    AppLanguage appLanguage;
    switch (locale.languageCode) {
      case 'es':
        appLanguage = AppLanguage.spanish;
        break;
      case 'en':
        appLanguage = AppLanguage.english;
        break;
      case 'pt':
        appLanguage = AppLanguage.portuguese;
        break;
      default:
        appLanguage = AppLanguage.spanish;
    }
    await setLanguage(appLanguage);
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