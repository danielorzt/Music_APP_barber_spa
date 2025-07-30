import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/user_management_api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final UserManagementApiService _userService = UserManagementApiService();
  late TabController _tabController;
  bool _isLoading = false;
  List<Map<String, dynamic>> _appointments = [];
  List<Map<String, dynamic>> _orders = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Cargar citas y órdenes en paralelo
      final results = await Future.wait([
        _userService.getUserAppointments(),
        _userService.getUserOrders(),
      ]);

      if (results[0]['success'] == true) {
        setState(() {
          _appointments = List<Map<String, dynamic>>.from(results[0]['data'] ?? []);
        });
      }

      if (results[1]['success'] == true) {
        setState(() {
          _orders = List<Map<String, dynamic>>.from(results[1]['data'] ?? []);
        });
      }

      if (results[0]['success'] != true && results[1]['success'] != true) {
        setState(() {
          _error = 'Error al cargar historial';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error de conexión: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
      case 'completed':
        return '#4CAF50';
      case 'cancelado':
      case 'cancelled':
        return '#F44336';
      case 'pendiente':
      case 'pending':
        return '#FF9800';
      case 'en_proceso':
      case 'in_progress':
        return '#2196F3';
      default:
        return '#9E9E9E';
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completado':
      case 'completed':
        return 'Completado';
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      case 'pendiente':
      case 'pending':
        return 'Pendiente';
      case 'en_proceso':
      case 'in_progress':
        return 'En proceso';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Citas'),
            Tab(text: 'Compras'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar historial',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadHistory,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAppointmentsTab(),
                    _buildOrdersTab(),
                  ],
                ),
    );
  }

  Widget _buildAppointmentsTab() {
    if (_appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tienes citas en tu historial',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Agenda tu primera cita',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/agendar'),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Agendar cita'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final appointment = _appointments[index];
        final status = appointment['estado']?.toString() ?? 'pendiente';
        final statusColor = _getStatusColor(status);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: const Color(0xFFDC3545)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment['servicio_nombre'] ?? 'Servicio',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        appointment['sucursal_nombre'] ?? 'Sucursal no especificada',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      appointment['fecha_hora'] ?? 'Fecha no especificada',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (appointment['personal_nombre'] != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        appointment['personal_nombre'],
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
                if (appointment['precio'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '\$${appointment['precio']}',
                    style: const TextStyle(
                      color: Color(0xFFDC3545),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersTab() {
    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No tienes compras en tu historial',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Explora nuestros productos',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/products'),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Ver productos'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        final status = order['estado']?.toString() ?? 'pendiente';
        final statusColor = _getStatusColor(status);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_bag, color: const Color(0xFFDC3545)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Orden #${order['numero_orden'] ?? order['id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      order['fecha_orden'] ?? 'Fecha no especificada',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.inventory, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${order['cantidad_productos'] ?? 0} productos',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (order['total'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Total: \$${order['total']}',
                    style: const TextStyle(
                      color: Color(0xFFDC3545),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
                if (order['metodo_pago'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Pago: ${order['metodo_pago']}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
} 