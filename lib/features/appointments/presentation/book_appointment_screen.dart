// lib/features/appointments/presentation/book_appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/appointments_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../services/providers/services_provider.dart';
import '../models/appointment_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedServiceId;
  int? _selectedBranchId;
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ServicesProvider>(context, listen: false).fetchServices();
      Provider.of<BranchesProvider>(context, listen: false).fetchBranches();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      // Validar que el horario esté dentro del horario de atención
      if (picked.hour < 8 || picked.hour >= 20 ||
          (picked.hour == 20 && picked.minute > 0)) {
        // Mostrar error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor selecciona un horario entre 8:00 AM y 8:00 PM'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Validar que el minuto sea múltiplo de 15
      if (picked.minute % 15 != 0) {
        // Mostrar error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Por favor selecciona un horario en intervalos de 15 minutos (00, 15, 30, 45)'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final servicesProvider = Provider.of<ServicesProvider>(context);
    final branchesProvider = Provider.of<BranchesProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Agendar Cita'),
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
                'Inicia sesión para agendar una cita',
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
          title: const Text('Agendar Cita'),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
              // Seleccionar servicio
              const Text(
              'Servicio',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            servicesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : servicesProvider.error != null
                ? Center(
              child: Text('Error: ${servicesProvider.error}'),
            )
                : DropdownButtonFormField<int>(
              value: _selectedServiceId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seleccionar servicio',
              ),
              items: servicesProvider.services.map((service) {
                return DropdownMenuItem<int>(
                  value: service.id,
                  child: Text('${service.nombre} - \$${service.precio.toStringAsFixed(2)}'),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Por favor selecciona un servicio';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _selectedServiceId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Seleccionar sucursal
            const Text(
              'Sucursal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            branchesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : branchesProvider.error != null
                ? Center(
              child: Text('Error: ${branchesProvider.error}'),
            )
                : DropdownButtonFormField<int>(
              value: _selectedBranchId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seleccionar sucursal',
              ),
              items: branchesProvider.branches.map((branch) {
                return DropdownMenuItem<int>(
                  value: branch.id,
                  child: Text(branch.nombre),
                );
              }).toList(),
              validator: (value) {
                if (value == null) {
                  return 'Por favor selecciona una sucursal';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _selectedBranchId = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Seleccionar fecha
            const Text(
              'Fecha',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                child: _selectedDate == null
                    ? const Text('Seleccionar fecha')
                    : Text(
                  DateFormat('EEEE, d MMMM, yyyy', 'es_ES').format(_selectedDate!),
                ),
              ),
            ),
            if (_selectedDate == null)
        const Padding(
    padding: EdgeInsets.only(top: 8, left: 12),
    child: Text(
// lib/features/appointments/presentation/book_appointment_screen.dart (continuación)
      'Por favor selecciona una fecha',
      style: TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
    ),
        ),
                const SizedBox(height: 16),

                // Seleccionar hora
                const Text(
                  'Hora',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                    child: _selectedTime == null
                        ? const Text('Seleccionar hora')
                        : Text(
                      _selectedTime!.format(context),
                    ),
                  ),
                ),
                if (_selectedTime == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      'Por favor selecciona una hora',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Notas o comentarios
                const Text(
                  'Notas (opcional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Agrega información adicional si lo necesitas',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Botón para agendar
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _bookAppointment(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Agendar Cita',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
        ),
    );
  }

  Future<void> _bookAppointment(BuildContext context) async {
    // Validar el formulario
    if (_formKey.currentState?.validate() != true ||
        _selectedDate == null ||
        _selectedTime == null) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos requeridos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated || authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor inicia sesión para agendar una cita'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Crear objeto de cita
      final appointment = Appointment(
        fechaHora: DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        ),
        estado: 'SOLICITADA',
        usuarioId: authProvider.currentUser!.id!,
        servicioId: _selectedServiceId!,
        sucursalId: _selectedBranchId!,
        mensaje: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Guardar cita
      final appointmentsProvider = Provider.of<AppointmentsProvider>(context, listen: false);
      final success = await appointmentsProvider.createAppointment(appointment);

      if (success && mounted) {
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita agendada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        // Navegar a la pantalla de citas
        Navigator.pop(context);
      } else if (mounted) {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agendar la cita: ${appointmentsProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agendar la cita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}