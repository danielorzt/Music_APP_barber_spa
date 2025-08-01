import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/orders_api_service.dart';
import '../../../core/services/appointments_api_service.dart';
import '../../../core/services/local_history_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final OrdersApiService _ordersService = OrdersApiService();
  final AppointmentsApiService _appointmentsService = AppointmentsApiService();
  
  bool _isLoadingHistory = false;
  Map<String, dynamic>? _purchaseHistory;
  Map<String, dynamic>? _appointmentHistory;
  Map<String, dynamic>? _localProfileData;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadLocalProfileData();
  }

  Future<void> _loadHistory() async {
    if (!mounted) return;
    
    setState(() => _isLoadingHistory = true);
    
    try {
      // Cargar historial combinado (local + API)
      final combinedHistory = await LocalHistoryService.getCombinedHistory();
      
      if (mounted) {
        setState(() {
          // Combinar datos locales con datos de API
          final localAppointments = combinedHistory['appointments'] as List<Map<String, dynamic>>;
          final localOrders = combinedHistory['orders'] as List<Map<String, dynamic>>;
          
          // Historial de citas (local + API)
          _appointmentHistory = {
            'success': true,
            'agendamientos': localAppointments,
            'has_local_data': combinedHistory['has_local_data'],
          };
          
          // Historial de compras (local + API)
          _purchaseHistory = {
            'success': true,
            'ordenes': localOrders,
            'has_local_data': combinedHistory['has_local_data'],
          };
        });
      }
    } catch (e) {
      print('❌ Error cargando historial: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingHistory = false);
      }
    }
  }

  Future<void> _loadLocalProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localData = prefs.getString('profile_data');
      if (localData != null) {
        final profileData = Map<String, dynamic>.from(jsonDecode(localData));
        if (mounted) {
          setState(() {
            _localProfileData = profileData;
          });
        }
      }
    } catch (e) {
      print('❌ Error cargando datos locales del perfil: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    if (authProvider.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Inicia sesión para ver tu perfil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC3545),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      );
    }

    final user = authProvider.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario
            _buildUserInfo(user),
            
            const SizedBox(height: 24),
            
            // Configuración de tema
            _buildThemeSection(settingsProvider),
            
            const SizedBox(height: 24),
            
            // Historial de agendamientos
            _buildAppointmentHistory(),
            
            const SizedBox(height: 24),
            
            // Historial de compras
            _buildPurchaseHistory(),
            
            const SizedBox(height: 24),
            
            // Configuración de notificaciones
            _buildNotificationSettings(),
            
            const SizedBox(height: 24),
            
            // Enlaces de ayuda
            _buildHelpLinks(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> user) {
    // Usar datos locales si están disponibles, sino usar datos del usuario
    final displayName = _localProfileData?['nombre'] ?? user['nombre'] ?? 'Usuario';
    final displayEmail = _localProfileData?['email'] ?? user['email'] ?? '';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFDC3545),
                  child: Text(
                    displayName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        displayEmail,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => context.push('/edit-profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(SettingsProvider settingsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tema de la App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: const Text('Claro'),
                    trailing: Radio<AppThemeMode>(
                      value: AppThemeMode.light,
                      groupValue: settingsProvider.themeMode,
                      onChanged: (AppThemeMode? value) {
                        if (value != null) {
                          settingsProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Oscuro'),
                    trailing: Radio<AppThemeMode>(
                      value: AppThemeMode.dark,
                      groupValue: settingsProvider.themeMode,
                      onChanged: (AppThemeMode? value) {
                        if (value != null) {
                          settingsProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: const Icon(Icons.settings_system_daydream),
                    title: const Text('Sistema'),
                    trailing: Radio<AppThemeMode>(
                      value: AppThemeMode.system,
                      groupValue: settingsProvider.themeMode,
                      onChanged: (AppThemeMode? value) {
                        if (value != null) {
                          settingsProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Historial de Agendamientos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/appointments'),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoadingHistory)
              const Center(child: CircularProgressIndicator())
            else if (_appointmentHistory != null && 
                     _appointmentHistory!['agendamientos'] != null &&
                     _appointmentHistory!['agendamientos'].isNotEmpty)
              Column(
                children: (_appointmentHistory!['agendamientos'] as List)
                    .take(3)
                    .map((appointment) => _buildAppointmentItem(appointment))
                    .toList(),
              )
            else
              const Text(
                'No tienes citas agendadas',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(Map<String, dynamic> appointment) {
    final fecha = DateTime.tryParse(appointment['fecha_hora'] ?? '');
    final fechaStr = fecha != null 
        ? '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}'
        : 'Fecha no disponible';
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(appointment['estado'] ?? ''),
        child: Icon(
          _getStatusIcon(appointment['estado'] ?? ''),
          color: Colors.white,
          size: 16,
        ),
      ),
      title: Text(appointment['nombre_servicio'] ?? 'Servicio'),
      subtitle: Text(fechaStr),
      trailing: Text(
        appointment['estado'] ?? 'PENDIENTE',
        style: TextStyle(
          color: _getStatusColor(appointment['estado'] ?? ''),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPurchaseHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Historial de Compras',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/orders'),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoadingHistory)
              const Center(child: CircularProgressIndicator())
            else if (_purchaseHistory != null && 
                     _purchaseHistory!['ordenes'] != null &&
                     _purchaseHistory!['ordenes'].isNotEmpty)
              Column(
                children: (_purchaseHistory!['ordenes'] as List)
                    .take(3)
                    .map((order) => _buildOrderItem(order))
                    .toList(),
              )
            else
              const Text(
                'No tienes compras realizadas',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    final fecha = DateTime.tryParse(order['fecha_orden'] ?? '');
    final fechaStr = fecha != null 
        ? '${fecha.day}/${fecha.month}/${fecha.year}'
        : 'Fecha no disponible';
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getOrderStatusColor(order['estado_orden'] ?? ''),
        child: Icon(
          _getOrderStatusIcon(order['estado_orden'] ?? ''),
          color: Colors.white,
          size: 16,
        ),
      ),
      title: Text('Orden ${order['numero_orden'] ?? ''}'),
      subtitle: Text(fechaStr),
      trailing: Text(
        '\$${(order['total_orden'] ?? 0).toStringAsFixed(2)}',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFFDC3545),
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Recordatorios de citas'),
              subtitle: const Text('Recibe notificaciones antes de tus citas'),
              value: true, // TODO: Implementar con SharedPreferences
              onChanged: (bool value) {
                // TODO: Implementar guardado de preferencias
              },
            ),
            SwitchListTile(
              title: const Text('Ofertas y promociones'),
              subtitle: const Text('Recibe notificaciones de descuentos'),
              value: false, // TODO: Implementar con SharedPreferences
              onChanged: (bool value) {
                // TODO: Implementar guardado de preferencias
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpLinks() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ayuda y Soporte',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Cambiar información de perfil'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/edit-profile'),
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Ayuda y soporte'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/help-support'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADA':
      case 'COMPLETADA':
        return Colors.green;
      case 'PENDIENTE':
      case 'PROGRAMADA':
        return Colors.orange;
      case 'CANCELADA':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'CONFIRMADA':
      case 'COMPLETADA':
        return Icons.check_circle;
      case 'PENDIENTE':
      case 'PROGRAMADA':
        return Icons.schedule;
      case 'CANCELADA':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Color _getOrderStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETADA':
      case 'ENTREGADA':
        return Colors.green;
      case 'PENDIENTE':
      case 'PROCESANDO':
        return Colors.orange;
      case 'CANCELADA':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getOrderStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETADA':
      case 'ENTREGADA':
        return Icons.check_circle;
      case 'PENDIENTE':
      case 'PROCESANDO':
        return Icons.schedule;
      case 'CANCELADA':
        return Icons.cancel;
      default:
        return Icons.shopping_bag;
    }
  }
}