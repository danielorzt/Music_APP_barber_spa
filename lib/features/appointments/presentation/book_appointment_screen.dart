// lib/features/appointments/presentation/book_appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/services/sucursales_api_service.dart';
import '../../../core/services/appointments_api_service.dart';
import '../../../core/services/services_api_service.dart';
import '../../../core/services/bmspa_api_service.dart';
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
  DateTime? _fechaSeleccionada;
  TimeOfDay? _horaSeleccionada;
  
  // Parámetros del servicio seleccionado desde la URL
  int? _preselectedServiceId;
  String? _preselectedServiceName;
  double? _preselectedServicePrice;
  
  bool _isLoadingSucursales = false;
  bool _isLoadingServicios = false;
  bool _isLoadingPersonal = false;
  bool _isLoadingHorarios = false;
  bool _isCreatingAppointment = false;
  bool _isInit = true; // Flag para controlar la inicialización
  
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    // Remover todas las llamadas que dependen del context
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _parseUrlParameters();
      _checkAuthentication();
      _loadSucursales();
      _loadServicios();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  /// Parsear parámetros de la URL
  void _parseUrlParameters() {
    final uri = GoRouterState.of(context).uri;
    final params = uri.queryParameters;
    
    if (params.containsKey('servicio_id')) {
      _preselectedServiceId = int.tryParse(params['servicio_id']!);
    }
    if (params.containsKey('servicio_nombre')) {
      _preselectedServiceName = Uri.decodeComponent(params['servicio_nombre']!);
    }
    if (params.containsKey('servicio_precio')) {
      _preselectedServicePrice = double.tryParse(params['servicio_precio']!);
    }
    
    print('🔍 Parámetros URL parseados:');
    print('  - ID: $_preselectedServiceId');
    print('  - Nombre: $_preselectedServiceName');
    print('  - Precio: $_preselectedServicePrice');
  }

  /// Verificar autenticación del usuario
  void _checkAuthentication() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      // Mostrar diálogo de login requerido
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLoginRequiredDialog();
      });
    }
  }

  /// Mostrar diálogo de login requerido
  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: const Color(0xFFDC3545),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Inicio de Sesión Requerido',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Para agendar una cita, necesitas iniciar sesión en tu cuenta.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/appointments');
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
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
      final servicesApiService = ServicesApiService();
      final serviciosData = await servicesApiService.getServicios();
      
      if (serviciosData.isNotEmpty) {
        setState(() {
          _servicios = serviciosData;
          // Auto-seleccionar servicio si viene desde URL
          if (_preselectedServiceId != null) {
            _servicioSeleccionado = _servicios.firstWhere(
              (s) => s['id'] == _preselectedServiceId,
              orElse: () => <String, dynamic>{},
            );
            if (_servicioSeleccionado!.isEmpty) {
              // Si no se encuentra el servicio, crear uno temporal
              _servicioSeleccionado = {
                'id': _preselectedServiceId,
                'nombre': _preselectedServiceName ?? 'Servicio',
                'precio': _preselectedServicePrice ?? 0.0,
                'duracion': 30,
              };
            }
            print('✅ Servicio preseleccionado: ${_servicioSeleccionado!['nombre']}');
          }
        });
        print('✅ BookAppointment: ${_servicios.length} servicios cargados desde API');
      } else {
        // Fallback a datos mock si la API no devuelve datos
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
        print('⚠️ BookAppointment: Usando datos mock - API no devolvió datos');
      }
    } catch (e) {
      print('❌ Error cargando servicios: $e');
      // Usar datos mock como fallback
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
      setState(() {
        _errorMessage = 'Error cargando servicios: $e';
      });
    } finally {
      setState(() => _isLoadingServicios = false);
    }
  }
  
  
  /// Cargar horarios de la sucursal seleccionada
  Future<void> _loadHorariosSucursal(int sucursalId) async {
    setState(() => _isLoadingHorarios = true);
    
    try {
      final apiService = BMSPAApiService();
      final horariosData = await apiService.getHorariosPorSucursal(sucursalId);
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
    print('🔍 DEBUG: Iniciando creación de agendamiento...');
    print('🔍 DEBUG: Sucursal seleccionada: ${_sucursalSeleccionada != null ? "✅" : "❌"}');
    print('🔍 DEBUG: Servicio seleccionado: ${_servicioSeleccionado != null ? "✅" : "❌"}');
    print('🔍 DEBUG: Fecha seleccionada: ${_fechaSeleccionada != null ? "✅" : "❌"}');
    print('🔍 DEBUG: Hora seleccionada: ${_horaSeleccionada != null ? "✅" : "❌"}');
    
    if (_sucursalSeleccionada == null || 
        _servicioSeleccionado == null || 
        _fechaSeleccionada == null || 
        _horaSeleccionada == null) {
      print('❌ DEBUG: Validación fallida - campos requeridos incompletos');
      setState(() {
        _errorMessage = 'Por favor completa todos los campos requeridos';
      });
      return;
    }
    
    print('✅ DEBUG: Validación exitosa - todos los campos están completos');
    
    setState(() => _isCreatingAppointment = true);
    
    try {
      print('🔍 DEBUG: Verificando autenticación del usuario...');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      
      print('🔍 DEBUG: Usuario actual: ${user != null ? "✅ Autenticado" : "❌ No autenticado"}');
      if (user != null) {
        print('🔍 DEBUG: ID del usuario: ${user['id']}');
        print('🔍 DEBUG: Nombre del usuario: ${user['nombre']}');
      }
      
      if (user == null) {
        print('❌ DEBUG: Usuario no autenticado - lanzando excepción');
        throw Exception('Usuario no autenticado');
      }
      
      print('🔍 DEBUG: Creando fecha y hora combinadas...');
      final fechaHora = DateTime(
        _fechaSeleccionada!.year,
        _fechaSeleccionada!.month,
        _fechaSeleccionada!.day,
        _horaSeleccionada!.hour,
        _horaSeleccionada!.minute,
      );
      print('🔍 DEBUG: Fecha y hora combinadas: $fechaHora');
      
      print('🔍 DEBUG: Creando objeto Agendamiento...');
      // Crear el agendamiento usando la API correcta de Laravel
      final agendamientoData = {
        'cliente_usuario_id': user['id'],
        'servicio_id': _servicioSeleccionado!['id'],
        'sucursal_id': _sucursalSeleccionada!['id'],
        'fecha_hora_inicio': fechaHora.toIso8601String(),
        'fecha_hora_fin': fechaHora.add(Duration(minutes: _servicioSeleccionado!['duracion'] ?? 30)).toIso8601String(),
        'precio_final': _servicioSeleccionado!['precio'],
        'estado': 'PROGRAMADA',
        'notas_cliente': 'Cita agendada desde la app móvil',
        // Sin personal_id - será asignado automáticamente
      };
      print('🔍 DEBUG: Datos del agendamiento creados: $agendamientoData');
      
      print('🔍 DEBUG: Llamando al servicio de agendamientos...');
      final apiService = BMSPAApiService();
      final response = await apiService.createAppointment(
        sucursalId: _sucursalSeleccionada!['id'],
        servicioId: _servicioSeleccionado!['id'],
        fecha: '${fechaHora.year}-${fechaHora.month.toString().padLeft(2, '0')}-${fechaHora.day.toString().padLeft(2, '0')}',
        hora: '${fechaHora.hour.toString().padLeft(2, '0')}:${fechaHora.minute.toString().padLeft(2, '0')}:00',
        notas: 'Cita agendada desde la app móvil',
      );
      if (response['success'] == true) {
        print('✅ DEBUG: Agendamiento creado exitosamente');
        
        setState(() {
          _successMessage = 'Cita agendada exitosamente para ${_sucursalSeleccionada!['nombre']}';
        });
      } else {
        throw Exception(response['error'] ?? 'Error desconocido al crear la cita');
      }
      print('✅ DEBUG: Mensaje de éxito establecido');
      
      // Limpiar selecciones
      _resetSelections();
      print('✅ DEBUG: Selecciones limpiadas');
      
      // Navegar de vuelta
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          print('✅ DEBUG: Navegando de vuelta a appointments');
          context.go('/appointments');
        }
      });
      
    } catch (e) {
      print('❌ DEBUG: Error creando agendamiento: $e');
      setState(() {
        _errorMessage = 'Error al agendar la cita: $e';
      });
      print('❌ DEBUG: Mensaje de error establecido: $_errorMessage');
    } finally {
      setState(() => _isCreatingAppointment = false);
      print('✅ DEBUG: Estado de creación de agendamiento reseteado');
    }
  }
  
  void _resetSelections() {
    setState(() {
      _sucursalSeleccionada = null;
      _servicioSeleccionado = null;
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
                _horarios = [];
              });
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
    final canConfirm = _sucursalSeleccionada != null && 
           _servicioSeleccionado != null && 
           _fechaSeleccionada != null && 
           _horaSeleccionada != null;
    
    return canConfirm;
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(now.year + 1, now.month, now.day);
    
    print('📅 Seleccionando fecha...');
    print('📅 Fecha actual: $now');
    print('📅 Fecha inicial: $firstDate');
    print('📅 Fecha final: $lastDate');
    
    final picked = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (picked != null) {
      print('✅ Fecha seleccionada: $picked');
      setState(() {
        _fechaSeleccionada = picked;
      });
      print('✅ _fechaSeleccionada actualizada: $_fechaSeleccionada');
    } else {
      print('❌ No se seleccionó fecha');
    }
  }

  Future<void> _selectTime() async {
    print('🕐 Seleccionando hora...');
    
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      print('✅ Hora seleccionada: ${picked.hour}:${picked.minute}');
      setState(() {
        _horaSeleccionada = picked;
      });
      print('✅ _horaSeleccionada actualizada: $_horaSeleccionada');
    } else {
      print('❌ No se seleccionó hora');
    }
  }
}