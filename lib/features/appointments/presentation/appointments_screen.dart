// lib/features/appointments/presentation/appointments_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../providers/appointments_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/appointment_model.dart';
import '../../../core/services/bmspa_api_service.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Future<List<Map<String, dynamic>>>? _futureAppointments;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Usar addPostFrameCallback para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _futureAppointments = _loadAppointments();
        });
      }
    });
  }

  /// Cargar agendamientos del usuario desde la API real
  Future<List<Map<String, dynamic>>> _loadAppointments() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final apiService = BMSPAApiService();
      final agendamientos = await apiService.getMisAgendamientos();
      
      // Convertir List<Agendamiento> a List<Map<String, dynamic>> para compatibilidad
      return agendamientos.map((agendamiento) => {
        'id': agendamiento.id,
        'fecha_hora': agendamiento.fechaHora.toIso8601String(),
        'usuario_id': agendamiento.usuarioId,
        'servicio_id': agendamiento.servicioId,
        'sucursal_id': agendamiento.sucursalId,
        'estado': agendamiento.estado,
        'personal_id': agendamiento.personalId,
        'notas': agendamiento.notas,
        'precio': agendamiento.precio,
        'servicio': {
          'nombre': 'Servicio ID ${agendamiento.servicioId}',
          'precio': agendamiento.precio,
          'duracion': 30, // Valor por defecto
        },
        'sucursal': {
          'nombre': 'Sucursal ID ${agendamiento.sucursalId}',
        },
        'personal': agendamiento.personalId != null ? {
          'nombre': 'Personal ID ${agendamiento.personalId}',
        } : null,
      }).toList();
    } catch (e) {
      print('❌ Error cargando agendamientos desde API: $e');
      throw Exception('Error al cargar las citas: $e');
    }
  }

  /// Recargar agendamientos (para pull-to-refresh)
  Future<void> _refreshAppointments() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });

    try {
      _futureAppointments = _loadAppointments();
      await _futureAppointments;
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Si no está autenticado, mostrar pantalla de login
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
                  context.push('/login');
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
              context.push('/agendar');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAppointments,
        child: _futureAppointments == null
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Inicializando...'),
                ],
              ),
            )
          : FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureAppointments,
              builder: (context, snapshot) {
                // Mostrar loading
                if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando tus citas...'),
                  ],
                ),
              );
            }

            // Mostrar error
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar las citas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _futureAppointments = _loadAppointments();
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            // Obtener la lista de agendamientos
            final appointments = snapshot.data ?? [];

            // Si no hay agendamientos, mostrar mensaje
            if (appointments.isEmpty) {
              return Center(
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
                        context.push('/agendar');
                      },
                      child: const Text('Agendar Cita'),
                    ),
                  ],
                ),
              );
            }

            // Mostrar lista de agendamientos
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return _buildAppointmentCard(context, appointment);
              },
            );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/agendar');
        },
        tooltip: 'Agendar Cita',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> appointment) {
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
            
            const SizedBox(height: 12),
            
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showAppointmentDetails(context, appointment);
                    },
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Detalles'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (estado.toUpperCase() == 'CONFIRMADA' || estado.toUpperCase() == 'SOLICITADA')
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCancelDialog(context, appointment);
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 16),
                      label: const Text('Cancelar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        foregroundColor: Colors.red,
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

  void _showAppointmentDetails(BuildContext context, Map<String, dynamic> appointment) {
    final dateFormat = DateFormat('EEEE, d MMMM, yyyy', 'es_ES');
    final timeFormat = DateFormat('HH:mm');
    
    final serviceName = appointment['servicio']?['nombre'] ?? 'Servicio';
    final servicePrice = appointment['servicio']?['precio'] ?? 0.0;
    final serviceDuration = appointment['servicio']?['duracion'] ?? 30;
    final branchName = appointment['sucursal']?['nombre'] ?? 'Sucursal';
    final fechaHora = DateTime.tryParse(appointment['fecha_hora'] ?? '') ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles de la Cita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha'),
              subtitle: Text(dateFormat.format(fechaHora)),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Hora'),
              subtitle: Text(timeFormat.format(fechaHora)),
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
            if (appointment['mensaje'] != null && appointment['mensaje'].toString().isNotEmpty)
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Notas'),
                subtitle: Text(appointment['mensaje'].toString()),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Cita'),
        content: const Text(
          '¿Estás seguro de que quieres cancelar esta cita? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _cancelAppointment(appointment);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sí, Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAppointment(Map<String, dynamic> appointment) async {
    final appointmentId = appointment['id'];
    if (appointmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se pudo identificar la cita')),
      );
      return;
    }

    try {
      final apiService = BMSPAApiService();
      final success = await apiService.cancelAppointment(appointmentId);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita cancelada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Recargar la lista
        setState(() {
          _futureAppointments = _loadAppointments();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al cancelar la cita'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}