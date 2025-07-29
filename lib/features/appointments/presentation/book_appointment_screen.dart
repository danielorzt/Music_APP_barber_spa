// lib/features/appointments/presentation/book_appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';
import 'package:music_app/core/services/catalog_api_service.dart';
import 'package:music_app/core/services/appointments_api_service.dart';
import 'package:music_app/core/widgets/loading_indicator.dart';
import 'package:music_app/features/services/models/service_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  final ServiceModel? selectedService;
  
  const BookAppointmentScreen({super.key, this.selectedService});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _currentStep = 0;
  
  // Servicios API
  final CatalogApiService _catalogService = CatalogApiService();
  final AppointmentsApiService _appointmentsService = AppointmentsApiService();
  
  // Estados de carga
  bool _isLoadingServices = false;
  bool _isLoadingSucursales = false;
  bool _isLoadingPersonal = false;
  bool _isLoadingAvailability = false;
  bool _isSubmitting = false;
  
  // Datos seleccionados
  Map<String, dynamic>? _selectedService;
  Map<String, dynamic>? _selectedSucursal;
  Map<String, dynamic>? _selectedPersonal;
  DateTime? _selectedDate;
  String? _selectedTime;
  
  // Datos de la API
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _sucursales = [];
  List<Map<String, dynamic>> _personal = [];
  List<String> _availableTimes = [];
  
  // Fechas disponibles (próximos 30 días)
  List<DateTime> _availableDates = [];
  
  @override
  void initState() {
    super.initState();
    _generateAvailableDates();
    _loadInitialData();
  }
  
  /// Cargar datos iniciales
  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadServices(),
      _loadSucursales(),
    ]);
    
    // Si se pasó un serviceId, pre-seleccionar el servicio
    if (widget.selectedService != null) {
      _selectedService = widget.selectedService!.toMap();
    }
  }
  
  /// Cargar servicios desde la API
  Future<void> _loadServices() async {
    setState(() => _isLoadingServices = true);
    
    try {
      final response = await _catalogService.getServicios();
      if (response['success'] == true) {
        final servicesData = response['data'] ?? [];
        setState(() {
          _services = List<Map<String, dynamic>>.from(servicesData);
        });
      }
    } catch (e) {
      print('Error cargando servicios: $e');
      // Mantener datos mock como fallback
      _services = [
        {
          'id': '1',
          'nombre': 'Corte Clásico',
          'duracion': 30,
          'precio': 25.0,
          'descripcion': 'Corte tradicional con estilo y precisión',
        },
        {
          'id': '2',
          'nombre': 'Corte + Barba',
          'duracion': 45,
          'precio': 40.0,
          'descripcion': 'Paquete completo de corte y arreglo de barba',
        },
      ];
    } finally {
      setState(() => _isLoadingServices = false);
    }
  }
  
  /// Cargar sucursales desde la API
  Future<void> _loadSucursales() async {
    setState(() => _isLoadingSucursales = true);
    
    try {
      final response = await _catalogService.getSucursales();
      if (response['success'] == true) {
        final sucursalesData = response['data'] ?? [];
        setState(() {
          _sucursales = List<Map<String, dynamic>>.from(sucursalesData);
        });
      }
    } catch (e) {
      print('Error cargando sucursales: $e');
      // Mantener datos mock como fallback
      _sucursales = [
        {
          'id': '1',
          'nombre': 'Sucursal Centro',
          'direccion': 'Av. Principal 123, Centro',
          'telefono': '555-0101',
          'horario': 'Lun-Sáb 9:00-20:00',
        },
        {
          'id': '2',
          'nombre': 'Sucursal Norte',
          'direccion': 'Blvd. Norte 456, Zona Norte',
          'telefono': '555-0202',
          'horario': 'Lun-Sáb 8:00-19:00',
        },
      ];
    } finally {
      setState(() => _isLoadingSucursales = false);
    }
  }
  
  /// Cargar personal de una sucursal
  Future<void> _loadPersonal(String sucursalId) async {
    setState(() => _isLoadingPersonal = true);
    
    try {
      final response = await _catalogService.getPersonalSucursal(sucursalId);
      if (response['success'] == true) {
        final personalData = response['data'] ?? [];
        setState(() {
          _personal = List<Map<String, dynamic>>.from(personalData);
        });
      }
    } catch (e) {
      print('Error cargando personal: $e');
      // Mantener datos mock como fallback
      _personal = [
        {
          'id': '1',
          'nombre': 'Carlos Rodríguez',
          'especialidad': 'Cortes Clásicos',
          'calificacion': 4.8,
          'imagen': 'https://picsum.photos/200/200?random=50',
        },
        {
          'id': '2',
          'nombre': 'Ana García',
          'especialidad': 'Tratamientos Spa',
          'calificacion': 4.9,
          'imagen': 'https://picsum.photos/200/200?random=51',
        },
      ];
    } finally {
      setState(() => _isLoadingPersonal = false);
    }
  }
  
  /// Cargar disponibilidad para una fecha
  Future<void> _loadAvailability() async {
    if (_selectedService == null || _selectedSucursal == null || _selectedDate == null) {
      return;
    }
    
    setState(() => _isLoadingAvailability = true);
    
    try {
      final response = await _appointmentsService.checkAvailability(
        servicioId: _selectedService!['id'].toString(),
        sucursalId: _selectedSucursal!['id'].toString(),
        fecha: _selectedDate!.toIso8601String().split('T')[0],
      );
      
      if (response['success'] == true) {
        final timesData = response['data']?['horarios_disponibles'] ?? [];
        setState(() {
          _availableTimes = List<String>.from(timesData);
        });
      }
    } catch (e) {
      print('Error cargando disponibilidad: $e');
      // Horarios mock como fallback
      _availableTimes = [
        '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
        '12:00', '12:30', '14:00', '14:30', '15:00', '15:30',
        '16:00', '16:30', '17:00', '17:30', '18:00', '18:30',
      ];
    } finally {
      setState(() => _isLoadingAvailability = false);
    }
  }
  
  /// Generar fechas disponibles (próximos 30 días)
  void _generateAvailableDates() {
    final now = DateTime.now();
    _availableDates = List.generate(30, (index) {
      return DateTime(now.year, now.month, now.day + index + 1);
    });
  }
  
  /// Confirmar cita
  Future<void> _confirmAppointment() async {
    if (_selectedService == null || _selectedSucursal == null || 
        _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }
    
    setState(() => _isSubmitting = true);
    
    try {
      final response = await _appointmentsService.createAppointment(
        servicioId: _selectedService!['id'].toString(),
        sucursalId: _selectedSucursal!['id'].toString(),
        personalId: _selectedPersonal?['id']?.toString(),
        fechaHoraInicio: '${_selectedDate!.toIso8601String().split('T')[0]}T$_selectedTime:00',
        notasCliente: 'Cita agendada desde la app móvil',
      );
      
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Cita agendada exitosamente!')),
        );
        context.go('/appointments');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'] ?? 'Error al agendar cita')),
        );
      }
    } catch (e) {
      print('Error confirmando cita: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agendar cita. Intenta nuevamente.')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BackButtonInterceptor(
      fallbackRoute: '/citas',
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Agendar Cita',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () => context.go('/citas'),
          ),
        ),
        body: Column(
          children: [
            // Indicador de progreso
            _buildProgressIndicator(),
            
            // Contenido del paso actual
            Expanded(
              child: _buildStepContent(),
            ),
            
            // Botones de navegación
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surface,
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;
          
          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFDC3545) : theme.colorScheme.onSurface.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isActive ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                if (index < 4)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted ? const Color(0xFFDC3545) : theme.colorScheme.onSurface.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildServiceSelection();
      case 1:
        return _buildSucursalSelection();
      case 2:
        return _buildBarberSelection();
      case 3:
        return _buildDateTimeSelection();
      case 4:
        return _buildConfirmation();
      default:
        return Container();
    }
  }

  Widget _buildServiceSelection() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona un servicio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige el servicio que deseas agendar',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ...(_services.map((service) => _buildServiceCard(service)).toList()),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    final theme = Theme.of(context);
    final isSelected = _selectedService?['id'] == service['id'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.cardTheme.color,
      child: InkWell(
        onTap: () => setState(() => _selectedService = service),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFFDC3545), width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC3545).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.content_cut,
                  color: Color(0xFFDC3545),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['nombre'] ?? 'Servicio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service['descripcion'] ?? 'Sin descripción',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${service['duracion'] ?? 0} min',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${service['precio'] ?? 0}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFDC3545),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFDC3545),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSucursalSelection() {
    final theme = Theme.of(context);
    
    if (_isLoadingSucursales) {
      return const Center(child: LoadingIndicator());
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona una sucursal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige la sucursal donde quieres agendar tu cita',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ...(_sucursales.map((sucursal) => _buildSucursalCard(sucursal)).toList()),
        ],
      ),
    );
  }

  Widget _buildSucursalCard(Map<String, dynamic> sucursal) {
    final theme = Theme.of(context);
    final isSelected = _selectedSucursal?['id'] == sucursal['id'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.cardTheme.color,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSucursal = sucursal;
            _selectedPersonal = null; // Reset personal selection
          });
          // Cargar personal de la sucursal seleccionada
          if (sucursal['id'] != null) {
            _loadPersonal(sucursal['id'].toString());
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFFDC3545), width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC3545).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Color(0xFFDC3545),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sucursal['nombre'] ?? 'Sucursal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sucursal['direccion'] ?? 'Sin dirección',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sucursal['telefono'] ?? 'Sin teléfono',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sucursal['horario'] ?? 'Horario no disponible',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFDC3545),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarberSelection() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona un profesional',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige quién realizará tu servicio',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ...(_personal.map((barber) => _buildBarberCard(barber)).toList()),
        ],
      ),
    );
  }

  Widget _buildBarberCard(Map<String, dynamic> barber) {
    final theme = Theme.of(context);
    final isSelected = _selectedPersonal?['id'] == barber['id'];
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.cardTheme.color,
      child: InkWell(
        onTap: () => setState(() => _selectedPersonal = barber),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFFDC3545), width: 2)
                : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(barber['imagen']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barber['nombre'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      barber['especialidad'],
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${barber['calificacion']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFDC3545),
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona fecha y hora',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Elige cuándo quieres tu cita',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          
          // Selector de fecha
          Card(
            color: theme.cardTheme.color,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fecha',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CalendarDatePicker(
                    initialDate: _availableDates.isNotEmpty ? _availableDates.first : DateTime.now(),
                    firstDate: _availableDates.isNotEmpty ? _availableDates.first : DateTime.now(),
                    lastDate: _availableDates.isNotEmpty ? _availableDates.last : DateTime.now().add(const Duration(days: 30)),
                    onDateChanged: (date) {
                      setState(() => _selectedDate = date);
                      _selectedTime = null; // Reset time selection
                      _loadAvailability(); // Load available times for selected date
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Selector de hora
          if (_selectedDate != null)
            Card(
              color: theme.cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora disponible',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingAvailability)
                      const Center(child: LoadingIndicator())
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableTimes.map((time) {
                          final isSelected = _selectedTime == time;
                          return InkWell(
                            onTap: () => setState(() => _selectedTime = time),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFDC3545) : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFFDC3545) : theme.colorScheme.onSurface.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                time,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmar cita',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Revisa los detalles antes de confirmar',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          
          Card(
            color: theme.cardTheme.color,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSummaryRow(
                    Icons.content_cut,
                    'Servicio',
                    _selectedService?['nombre'] ?? '',
                    '\$${_selectedService?['precio'] ?? 0}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    Icons.location_on,
                    'Sucursal',
                    _selectedSucursal?['nombre'] ?? '',
                    _selectedSucursal?['direccion'] ?? '',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    Icons.person,
                    'Profesional',
                    _selectedPersonal?['nombre'] ?? '',
                    '⭐ ${_selectedPersonal?['calificacion'] ?? 0}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    Icons.calendar_today,
                    'Fecha',
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : '',
                    _selectedTime ?? '',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    Icons.schedule,
                    'Duración',
                    '${_selectedService?['duracion'] ?? 0} min',
                    '',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, String extra) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFDC3545),
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        if (extra.isNotEmpty)
          Text(
            extra,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFDC3545)),
                ),
                child: const Text(
                  'Anterior',
                  style: TextStyle(color: Color(0xFFDC3545)),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() && !_isSubmitting ? _handleNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep == 4 ? 'Confirmar Cita' : 'Siguiente',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedService != null;
      case 1:
        return _selectedSucursal != null;
      case 2:
        return _selectedPersonal != null;
      case 3:
        return _selectedDate != null && _selectedTime != null;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_currentStep == 4) {
      _submitAppointment();
    } else {
      setState(() => _currentStep++);
    }
  }

  void _submitAppointment() {
    // Usar la función real de confirmación
    _confirmAppointment();
  }
}