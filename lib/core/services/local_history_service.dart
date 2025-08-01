import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalHistoryService {
  static const String _appointmentsKey = 'local_appointments';
  static const String _ordersKey = 'local_orders';

  // Guardar cita local
  static Future<void> saveAppointment(Map<String, dynamic> appointment) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingAppointments = await getAppointments();
      
      // Agregar timestamp si no existe
      if (!appointment.containsKey('created_at')) {
        appointment['created_at'] = DateTime.now().toIso8601String();
      }
      
      existingAppointments.add(appointment);
      
      await prefs.setString(_appointmentsKey, jsonEncode(existingAppointments));
      print('✅ Cita guardada localmente: ${appointment['servicio_nombre']}');
    } catch (e) {
      print('❌ Error guardando cita local: $e');
    }
  }

  // Obtener citas locales
  static Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appointmentsJson = prefs.getString(_appointmentsKey);
      
      if (appointmentsJson != null) {
        final List<dynamic> appointmentsList = jsonDecode(appointmentsJson);
        return appointmentsList.cast<Map<String, dynamic>>();
      }
      
      return [];
    } catch (e) {
      print('❌ Error obteniendo citas locales: $e');
      return [];
    }
  }

  // Guardar orden local
  static Future<void> saveOrder(Map<String, dynamic> order) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingOrders = await getOrders();
      
      // Agregar timestamp si no existe
      if (!order.containsKey('created_at')) {
        order['created_at'] = DateTime.now().toIso8601String();
      }
      
      existingOrders.add(order);
      
      await prefs.setString(_ordersKey, jsonEncode(existingOrders));
      print('✅ Orden guardada localmente: ${order['total']}');
    } catch (e) {
      print('❌ Error guardando orden local: $e');
    }
  }

  // Obtener órdenes locales
  static Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString(_ordersKey);
      
      if (ordersJson != null) {
        final List<dynamic> ordersList = jsonDecode(ordersJson);
        return ordersList.cast<Map<String, dynamic>>();
      }
      
      return [];
    } catch (e) {
      print('❌ Error obteniendo órdenes locales: $e');
      return [];
    }
  }

  // Limpiar historial local
  static Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_appointmentsKey);
      await prefs.remove(_ordersKey);
      print('✅ Historial local limpiado');
    } catch (e) {
      print('❌ Error limpiando historial local: $e');
    }
  }

  // Obtener historial combinado (local + API)
  static Future<Map<String, dynamic>> getCombinedHistory() async {
    try {
      final localAppointments = await getAppointments();
      final localOrders = await getOrders();
      
      return {
        'appointments': localAppointments,
        'orders': localOrders,
        'has_local_data': localAppointments.isNotEmpty || localOrders.isNotEmpty,
      };
    } catch (e) {
      print('❌ Error obteniendo historial combinado: $e');
      return {
        'appointments': [],
        'orders': [],
        'has_local_data': false,
      };
    }
  }
} 