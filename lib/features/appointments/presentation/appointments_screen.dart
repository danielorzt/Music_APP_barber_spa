// lib/features/appointments/presentation/appointments_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/appointments_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/appointment_model.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        Provider.of<AppointmentsProvider>(context, listen: false)
          .fetchUserAppointments(authProvider.currentUser!.id!.toString());
      }
    });
  }

  Future<void> _loadAppointments() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated && authProvider.currentUser != null) {
      await Provider.of<AppointmentsProvider>(context, listen: false)
          .fetchUserAppointments(authProvider.currentUser!.id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsProvider = Provider.of<AppointmentsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mis Citas'),
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
                'Inicia sesión para ver tus citas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/book-appointment');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAppointments,
        child: appointmentsProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : appointmentsProvider.error != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${appointmentsProvider.error}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadAppointments,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        )
            : appointmentsProvider.appointments.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No tienes citas programadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Agenda una cita para comenzar',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/book-appointment');
                },
                child: const Text('Agendar Cita'),
              ),
            ],
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: appointmentsProvider.appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointmentsProvider.appointments[index];
            return _buildAppointmentCard(context, appointment);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/book-appointment');
        },
        tooltip: 'Agendar Cita',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> appointment) {
    final appointmentsProvider = Provider.of<AppointmentsProvider>(context, listen: false);
    final dateFormat = DateFormat('EEEE, d MMMM, yyyy', 'es_ES');
    final timeFormat = DateFormat('HH:mm');
    
    // Extraer datos del Map
    final serviceName = appointment['servicio']?['nombre'] ?? 'Servicio';
    final branchName = appointment['sucursal']?['nombre'] ?? 'Sucursal';
    final estado = appointment['estado'] ?? 'PENDIENTE';
    final fechaHora = DateTime.tryParse(appointment['fecha_hora'] ?? '') ?? DateTime.now();

    Color statusColor;
    IconData statusIcon;

    switch (estado.toUpperCase()) {
      case 'SOLICITADA':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'CONFIRMADA':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'CANCELADA':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'COMPLETADA':
        statusColor = Colors.purple;
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Fecha de la cita
                Text(
                  dateFormat.format(fechaHora),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // Estado de la cita
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        estado,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Información del servicio
            Row(
              children: [
                Icon(Icons.spa, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    serviceName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
            
            // Información de la sucursal
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                        branchName,
                        style: TextStyle(
                          color: Colors.grey[600],
                      fontSize: 14,
                    ),
                        ),
                      ),
                    ],
            ),
            
            const SizedBox(height: 4),
            
            // Hora de la cita
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  timeFormat.format(fechaHora),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            
              const SizedBox(height: 16),
            
            // Botones de acción
            Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                if (estado == 'CONFIRMADA')
                  TextButton.icon(
                      onPressed: () {
                      // TODO: Implementar reprogramar cita
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Reprogramar'),
                            ),
                if (estado != 'CANCELADA' && estado != 'COMPLETADA')
                  TextButton.icon(
                                onPressed: () async {
                      final success = await appointmentsProvider.cancelAppointment(appointment['id'].toString());
                      if (success['success'] == true && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cita cancelada exitosamente'),
                            backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                    icon: const Icon(Icons.cancel, size: 16),
                    label: const Text('Cancelar'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      ),
                    ),
                  ],
              ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    final dateFormat = DateFormat('EEEE, d MMMM, yyyy', 'es_ES');
    final timeFormat = DateFormat('HH:mm');
    final serviceName = appointment.servicio?['nombre'] ?? 'Servicio';
    final branchName = appointment.sucursal?['nombre'] ?? 'Sucursal';
    final servicePrice = appointment.servicio?['precio'] ?? 0.0;
    final serviceDuration = appointment.servicio?['duracion'] ?? 0;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detalles de la Cita',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Fecha'),
                subtitle: Text(dateFormat.format(appointment.fechaHora)),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Hora'),
                subtitle: Text(timeFormat.format(appointment.fechaHora)),
              ),
              ListTile(
                leading: const Icon(Icons.spa),
                title: const Text('Servicio'),
                subtitle: Text(serviceName),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Precio'),
                subtitle: Text('\$${servicePrice.toStringAsFixed(2)}'),
              ),
              ListTile(
                leading: const Icon(Icons.timelapse),
                title: const Text('Duración'),
                subtitle: Text('$serviceDuration minutos'),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Sucursal'),
                subtitle: Text(branchName),
              ),
              if (appointment.mensaje != null && appointment.mensaje!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text('Notas'),
                  subtitle: Text(appointment.mensaje!),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}