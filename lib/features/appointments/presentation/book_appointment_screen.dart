// lib/features/appointments/presentation/book_appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/services/sucursales_api_service.dart';
import '../../../core/services/appointments_api_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/models/agendamiento.dart'; // Added import for Agendamiento

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final SucursalesApiService _sucursalesService = SucursalesApiService();
  final AppointmentsApiService _appointmentsService = AppointmentsApiService();
  
  List<Map<String, dynamic>> _sucursales = [];
  List<Map<String, dynamic>> _servicios = [];
  List<Map<String, dynamic>> _personal = [];
  List<Map<String, dynamic>> _horarios = [];
  
  Map<String, dynamic>? _sucursalSeleccionada;
  Map<String, dynamic>? _servicioSeleccionado;
  Map<String, dynamic>? _personalSeleccionado;
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  
  bool _isLoadingSucursales = false;
  bool _isLoadingServicios = false;
  bool _isLoadingPersonal = false;
  bool _isLoadingHorarios = false;
  bool _isCreatingAppointment = false;
  
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadSucursales();
    _loadServicios();
  }

  /// Cargar sucursales desde la API
  Future<void> _loadSucursales() async {
    setState(() => _isLoadingSucursales = true);
    
    try {
      final sucursalesData = await _sucursalesService.getSucursales();
      if (sucursalesData.isNotEmpty) {
        setState(() {
          _sucursales = sucursalesData;
        });
        print('✅ BookAppointment: ${_sucursales.length} sucursales cargadas');
      }
    } catch (e) {
      print('❌ Error cargando sucursales: $e');
      setState(() {
        _errorMessage = 'Error cargando sucursales: $e';
      });
    } finally {
      setState(() => _isLoadingSucursales = false);
    }
  }
  
  /// Cargar servicios desde la API
  Future<void> _loadServicios() async {
    setState(() => _isLoadingServicios = true);
    
    try {
      // Usar datos mock por ahora
      setState(() {
        _servicios = [
          {
            'id': 1,
            'nombre': 'Corte Clásico',
            'duracion': 30,
            'precio': 25.0,
            'descripcion': 'Corte de cabello tradicional con acabado profesional',
          },
          {
            'id': 2,
            'nombre': 'Corte + Barba',
            'duracion': 45,
            'precio': 40.0,
            'descripcion': 'Paquete completo de corte y arreglo de barba',
          },
          {
            'id': 3,
            'nombre': 'Afeitado Tradicional',
            'duracion': 20,
            'precio': 18.0,
            'descripcion': 'Afeitado con navaja y productos premium',
          },
          {
            'id': 4,
            'nombre': 'Masaje Relajante',
            'duracion': 60,
            'precio': 45.0,
            'descripcion': 'Masaje terapéutico para aliviar tensiones',
          },
        ];
      });
      print('✅ BookAppointment: ${_servicios.length} servicios cargados');
    } catch (e) {
      print('❌ Error cargando servicios: $e');
      setState(() {
        _errorMessage = 'Error cargando servicios: $e';
      });
    } finally {
      setState(() => _isLoadingServicios = false);
    }
  }
  
  /// Cargar personal de la sucursal seleccionada
  Future<void> _loadPersonalSucursal(int sucursalId) async {
    setState(() => _isLoadingPersonal = true);
    
    try {
      final personalData = await _sucursalesService.getPersonalSucursal(sucursalId);
      setState(() {
        _personal = personalData;
      });
      print('✅ BookAppointment: ${_personal.length} empleados cargados');
    } catch (e) {
      print('❌ Error cargando personal: $e');
      setState(() {
        _errorMessage = 'Error cargando personal: $e';
      });
    } finally {
      setState(() => _isLoadingPersonal = false);
    }
  }
  
  /// Cargar horarios de la sucursal seleccionada
  Future<void> _loadHorariosSucursal(int sucursalId) async {
    setState(() => _isLoadingHorarios = true);
    
    try {
      final horariosData = await _sucursalesService.getHorariosSucursal(sucursalId);
      setState(() {
        _horarios = horariosData;
      });
      print('✅ BookAppointment: ${_horarios.length} horarios cargados');
    } catch (e) {
      print('❌ Error cargando horarios: $e');
      setState(() {
        _errorMessage = 'Error cargando horarios: $e';
      });
    } finally {
      setState(() => _isLoadingHorarios = false);
    }
  }
  
  /// Crear agendamiento
  Future<void> _createAppointment() async {
    if (_sucursalSeleccionada == null || 
        _servicioSeleccionado == null || 
        _fechaSeleccionada == null || 
        _horaSeleccionada == null) {
      setState(() {
        _errorMessage = 'Por favor completa todos los campos requeridos';
      });
      return;
    }
    
    setState(() => _isCreatingAppointment = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }
      
      final fechaHora = DateTime(
        _fechaSeleccionada!.year,
        _fechaSeleccionada!.month,
        _fechaSeleccionada!.day,
        _horaSeleccionada!.hour,
        _horaSeleccionada!.minute,
      );
      
      // Crear objeto Agendamiento en lugar de Map
      final agendamiento = Agendamiento(
        id: 0, // Se asignará desde el servidor
        fechaHora: fechaHora,
        usuarioId: user['id'],
        servicioId: _servicioSeleccionado!['id'],
        sucursalId: _sucursalSeleccionada!['id'],
        estado: 'PROGRAMADA',
        personalId: _personalSeleccionado?['id'],
        notas: 'Cita agendada desde la app móvil',
      );
      
      final agendamientoCreado = await _appointmentsService.crearAgendamiento(agendamiento);
      
      setState(() {
        _successMessage = 'Cita agendada exitosamente para ${_sucursalSeleccionada!['nombre']}';
      });
      
      // Limpiar selecciones
      _resetSelections();
      
      // Navegar de vuelta
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/appointments');
        }
      });
      
    } catch (e) {
      print('❌ Error creando agendamiento: $e');
      setState(() {
        _errorMessage = 'Error al agendar la cita: $e';
      });
    } finally {
      setState(() => _isCreatingAppointment = false);
    }
  }
  
  void _resetSelections() {
    setState(() {
      _sucursalSeleccionada = null;
      _servicioSeleccionado = null;
      _personalSeleccionado = null;
      _fechaSeleccionada = null;
      _horaSeleccionada = null;
      _personal = [];
      _horarios = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendar Cita'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/appointments'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mensajes de error/éxito
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _errorMessage = null),
                    ),
                  ],
                ),
              ),
            
            if (_successMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _successMessage!,
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _successMessage = null),
                    ),
                  ],
                ),
              ),
            
            // Selección de Sucursal
            _buildSectionTitle('Seleccionar Sucursal'),
            _buildSucursalSelection(),
            
            const SizedBox(height: 24),
            
            // Selección de Servicio
            _buildSectionTitle('Seleccionar Servicio'),
            _buildServiceSelection(),
            
            const SizedBox(height: 24),
            
            // Selección de Personal (opcional)
            if (_sucursalSeleccionada != null) ...[
              _buildSectionTitle('Seleccionar Personal (Opcional)'),
              _buildPersonalSelection(),
              const SizedBox(height: 24),
            ],
            
            // Selección de Fecha y Hora
            if (_servicioSeleccionado != null) ...[
              _buildSectionTitle('Seleccionar Fecha y Hora'),
              _buildDateTimeSelection(),
              const SizedBox(height: 24),
            ],
            
            // Botón de Confirmar
            if (_canConfirmAppointment())
              _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSucursalSelection() {
    if (_isLoadingSucursales) {
      return const Center(child: LoadingIndicator());
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _sucursales.map((sucursal) {
          final isSelected = _sucursalSeleccionada?['id'] == sucursal['id'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _sucursalSeleccionada = sucursal;
                _personalSeleccionado = null;
                _personal = [];
                _horarios = [];
              });
              _loadPersonalSucursal(sucursal['id']);
              _loadHorariosSucursal(sucursal['id']);
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDC3545).withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFFDC3545) : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sucursal['nombre'] ?? 'Sin nombre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFFDC3545) : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sucursal['direccion'] ?? 'Sin dirección',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sucursal['horario'] ?? 'Horario no disponible',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceSelection() {
    if (_isLoadingServicios) {
      return const Center(child: LoadingIndicator());
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _servicios.map((service) {
          final isSelected = _servicioSeleccionado?['id'] == service['id'];
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _servicioSeleccionado = service;
              });
            },
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFDC3545).withOpacity(0.1) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFFDC3545) : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['nombre'] ?? 'Sin nombre',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFFDC3545) : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${service['duracion'] ?? 0} min',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
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
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPersonalSelection() {
    if (_isLoadingPersonal) {
      return const Center(child: LoadingIndicator());
    }
    
    if (_personal.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'No hay personal disponible en esta sucursal',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Opción "Cualquiera"
          GestureDetector(
            onTap: () {
              setState(() {
                _personalSeleccionado = null;
              });
            },
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _personalSeleccionado == null 
                    ? const Color(0xFFDC3545).withOpacity(0.1) 
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _personalSeleccionado == null 
                      ? const Color(0xFFDC3545) 
                      : Colors.grey.shade300,
                  width: _personalSeleccionado == null ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFFDC3545),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cualquiera',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Personal disponible
          ..._personal.map((person) {
            final isSelected = _personalSeleccionado?['id'] == person['id'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _personalSeleccionado = person;
                });
              },
              child: Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFFDC3545).withOpacity(0.1) 
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? const Color(0xFFDC3545) 
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(person['imagen'] ?? ''),
                      child: person['imagen'] == null 
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      person['nombre'] ?? 'Sin nombre',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFFDC3545) : null,
                      ),
                    ),
                    Text(
                      person['especialidad'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return Column(
      children: [
        // Selección de fecha
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Fecha'),
          subtitle: Text(
            _fechaSeleccionada != null 
                ? '${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}'
                : 'Seleccionar fecha',
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _selectDate(),
        ),
        
        // Selección de hora
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Hora'),
          subtitle: Text(
            _horaSeleccionada != null 
                ? '${_horaSeleccionada!.hour.toString().padLeft(2, '0')}:${_horaSeleccionada!.minute.toString().padLeft(2, '0')}'
                : 'Seleccionar hora',
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => _selectTime(),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCreatingAppointment ? null : _createAppointment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC3545),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isCreatingAppointment
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Agendando...'),
                ],
              )
            : const Text(
                'Confirmar Cita',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  bool _canConfirmAppointment() {
    return _sucursalSeleccionada != null && 
           _servicioSeleccionado != null && 
           _fechaSeleccionada != null && 
           _horaSeleccionada != null;
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    
    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        _horaSeleccionada = picked;
      });
    }
  }
}