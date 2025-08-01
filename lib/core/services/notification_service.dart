import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Solicitar permisos
    await _requestPermissions();
    
    // Configurar notificaciones locales
    await _setupLocalNotifications();
    
    // Configurar handlers para notificaciones en primer plano
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Configurar handlers para cuando se toca una notificación
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Obtener token de FCM
    String? token = await _firebaseMessaging.getToken();
    print('🔔 FCM Token: $token');
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('🔔 Permisos de notificación: ${settings.authorizationStatus}');
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    
    await _localNotifications.initialize(initializationSettings);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('🔔 Notificación recibida en primer plano: ${message.notification?.title}');
    
    // Mostrar notificación local
    _showLocalNotification(
      title: message.notification?.title ?? 'Nueva notificación',
      body: message.notification?.body ?? '',
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('🔔 Notificación tocada: ${message.notification?.title}');
    // Aquí puedes navegar a una pantalla específica basada en el tipo de notificación
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'barber_spa_channel',
      'Barber & Spa Notifications',
      channelDescription: 'Notificaciones de Barber & Spa',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // Métodos para enviar notificaciones mock
  Future<void> showAppointmentNotification() async {
    // Verificar si las notificaciones de citas están habilitadas
    final appointmentNotificationsEnabled = await areAppointmentNotificationsEnabled();
    if (!appointmentNotificationsEnabled) {
      print('🔕 Notificación de cita deshabilitada por el usuario');
      return;
    }
    
    await _showLocalNotification(
      title: '¡Cita Agendada!',
      body: 'Tu cita ha sido agendada exitosamente. Revisa los detalles en tu perfil.',
    );
  }

  Future<void> showPurchaseNotification() async {
    // Verificar si las notificaciones de compras están habilitadas
    final purchaseNotificationsEnabled = await arePurchaseNotificationsEnabled();
    if (!purchaseNotificationsEnabled) {
      print('🔕 Notificación de compra deshabilitada por el usuario');
      return;
    }
    
    await _showLocalNotification(
      title: '¡Compra Exitosa!',
      body: 'Tu pedido ha sido procesado correctamente. Revisa tu historial de compras.',
    );
  }

  // Métodos para gestionar preferencias de notificaciones
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    
    if (enabled) {
      await _firebaseMessaging.requestPermission();
    }
  }

  Future<bool> areAppointmentNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('appointment_notifications_enabled') ?? true;
  }

  Future<void> setAppointmentNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('appointment_notifications_enabled', enabled);
  }

  Future<bool> arePurchaseNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('purchase_notifications_enabled') ?? true;
  }

  Future<void> setPurchaseNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('purchase_notifications_enabled', enabled);
  }
} 