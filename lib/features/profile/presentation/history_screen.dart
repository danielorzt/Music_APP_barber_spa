import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/orders_api_service.dart';
import '../../../core/services/appointments_api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  final OrdersApiService _ordersService = OrdersApiService();
  final AppointmentsApiService _appointmentsService = AppointmentsApiService();
  
  late TabController _tabController;
  bool _isLoading = false;
  
  Map<String, dynamic>? _purchaseHistory;
  Map<String, dynamic>? _appointmentHistory;

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
    setState(() => _isLoading = true);
    
    try {
      // Cargar historial de compras
      final purchaseResult = await _ordersService.getPurchaseHistory();
      if (purchaseResult['success']) {
        setState(() {
          _purchaseHistory = purchaseResult;
        });
      }
      
      // Cargar historial de citas
      final appointmentResult = await _appointmentsService.getMisAgendamientos();
      setState(() {
        _appointmentHistory = {
          'success': true,
          'agendamientos': appointmentResult.map((a) => a.toJson()).toList(),
        };
      });
    } catch (e) {
      print('❌ Error cargando historial: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Historial'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFDC3545),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFFDC3545),
          tabs: const [
            Tab(
              icon: Icon(Icons.shopping_bag),
              text: 'Compras',
            ),
            Tab(
              icon: Icon(Icons.calendar_today),
              text: 'Citas',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPurchaseHistoryTab(),
          _buildAppointmentHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildPurchaseHistoryTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_purchaseHistory == null || 
        _purchaseHistory!['ordenes'] == null ||
        _purchaseHistory!['ordenes'].isEmpty) {
      return _buildEmptyState(
        icon: Icons.shopping_bag,
        title: 'No tienes compras',
        subtitle: 'Aún no has realizado ninguna compra',
      );
    }

    final orders = _purchaseHistory!['ordenes'] as List;

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildAppointmentHistoryTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_appointmentHistory == null || 
        _appointmentHistory!['agendamientos'] == null ||
        _appointmentHistory!['agendamientos'].isEmpty) {
      return _buildEmptyState(
        icon: Icons.calendar_today,
        title: 'No tienes citas',
        subtitle: 'Aún no has agendado ninguna cita',
      );
    }

    final appointments = _appointmentHistory!['agendamientos'] as List;

    return RefreshIndicator(
      onRefresh: _loadHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final fecha = DateTime.tryParse(order['fecha_orden'] ?? '');
    final fechaStr = fecha != null 
        ? '${fecha.day}/${fecha.month}/${fecha.year}'
        : 'Fecha no disponible';
    
    final status = order['estado_orden'] ?? 'PENDIENTE';
    final statusColor = _getOrderStatusColor(status);
    final statusIcon = _getOrderStatusIcon(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor,
                  child: Icon(statusIcon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Orden ${order['numero_orden'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        fechaStr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${(order['total_orden'] ?? 0).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC3545),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            if (order['detalles'] != null && order['detalles'].isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'Productos:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ...(order['detalles'] as List).take(3).map((detail) => 
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '• ${detail['nombre_producto'] ?? 'Producto'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        'x${detail['cantidad'] ?? 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if ((order['detalles'] as List).length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '... y ${(order['detalles'] as List).length - 3} más',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final fecha = DateTime.tryParse(appointment['fecha_hora'] ?? '');
    final fechaStr = fecha != null 
        ? '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}'
        : 'Fecha no disponible';
    
    final status = appointment['estado'] ?? 'PENDIENTE';
    final statusColor = _getAppointmentStatusColor(status);
    final statusIcon = _getAppointmentStatusIcon(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor,
                  child: Icon(statusIcon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['nombre_servicio'] ?? 'Servicio',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment['nombre_sucursal'] ?? 'Sucursal',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        fechaStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (appointment['precio'] != null)
                  Text(
                    '\$${appointment['precio'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFDC3545),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            if (appointment['nombre_personal'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Profesional: ${appointment['nombre_personal']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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

  Color _getAppointmentStatusColor(String status) {
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

  IconData _getAppointmentStatusIcon(String status) {
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
} 