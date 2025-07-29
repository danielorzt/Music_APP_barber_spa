import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/catalog_api_service.dart';
import '../../../core/services/appointments_api_service.dart';
import '../../../core/services/orders_api_service.dart';
import '../providers/auth_provider.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _catalogService = CatalogApiService();
  final _appointmentsService = AppointmentsApiService();
  final _ordersService = OrdersApiService();
  
  String _results = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateResults(String newResults) {
    setState(() {
      _results = newResults;
      _isLoading = false;
    });
  }

  void _setLoading() {
    setState(() {
      _isLoading = true;
      _results = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('🔧 Pruebas de APIs'),
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFDC3545),
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.7),
          indicatorColor: const Color(0xFFDC3545),
          tabs: const [
            Tab(icon: Icon(Icons.store), text: 'Catálogo'),
            Tab(icon: Icon(Icons.calendar_today), text: 'Citas'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Órdenes'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Estado del usuario
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👤 Usuario Actual',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (authProvider.isAuthenticated) ...[
                  Text(
                    '✅ ${authProvider.currentUser?.nombre ?? 'Usuario'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF28A745),
                    ),
                  ),
                  Text(
                    '📧 ${authProvider.currentUser?.email ?? ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    '🎭 Rol: ${authProvider.currentUser?.role ?? 'Sin rol'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ] else ...[
                  Text(
                    '❌ No autenticado',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFDC3545),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/test-login'),
                    child: const Text('Ir a Login'),
                  ),
                ],
              ],
            ),
          ),
          
          // Tabs de pruebas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCatalogTests(),
                _buildAppointmentTests(),
                _buildOrderTests(),
              ],
            ),
          ),
          
          // Resultados
          if (_results.isNotEmpty || _isLoading)
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📋 Resultados',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            child: Text(
                              _results,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCatalogTests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTestCard(
            '🎯 Servicios',
            [
              _buildTestButton('Obtener Servicios', () async {
                _setLoading();
                final result = await _catalogService.getServicios();
                _updateResults('SERVICIOS:\n${result.toString()}');
              }),
              _buildTestButton('Servicios Destacados', () async {
                _setLoading();
                final result = await _catalogService.getServiciosDestacados();
                _updateResults('SERVICIOS DESTACADOS:\n${result.toString()}');
              }),
              _buildTestButton('Buscar Servicios', () async {
                _setLoading();
                final result = await _catalogService.buscarServicios('corte');
                _updateResults('BÚSQUEDA SERVICIOS:\n${result.toString()}');
              }),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestCard(
            '🛍️ Productos',
            [
              _buildTestButton('Obtener Productos', () async {
                _setLoading();
                final result = await _catalogService.getProductos();
                _updateResults('PRODUCTOS:\n${result.toString()}');
              }),
              _buildTestButton('Productos Destacados', () async {
                _setLoading();
                final result = await _catalogService.getProductosDestacados();
                _updateResults('PRODUCTOS DESTACADOS:\n${result.toString()}');
              }),
              _buildTestButton('Ofertas', () async {
                _setLoading();
                final result = await _catalogService.getOfertas();
                _updateResults('OFERTAS:\n${result.toString()}');
              }),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestCard(
            '📂 Categorías',
            [
              _buildTestButton('Obtener Categorías', () async {
                _setLoading();
                final result = await _catalogService.getCategorias();
                _updateResults('CATEGORÍAS:\n${result.toString()}');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTestCard(
            '📅 Mis Citas',
            [
              _buildTestButton('Obtener Mis Citas', () async {
                _setLoading();
                final result = await _appointmentsService.getUserAppointments();
                _updateResults('MIS CITAS:\n${result.toString()}');
              }),
              _buildTestButton('Citas Próximas', () async {
                _setLoading();
                final result = await _appointmentsService.getUpcomingAppointments();
                _updateResults('CITAS PRÓXIMAS:\n${result.toString()}');
              }),
              _buildTestButton('Historial de Citas', () async {
                _setLoading();
                final result = await _appointmentsService.getAppointmentHistory();
                _updateResults('HISTORIAL:\n${result.toString()}');
              }),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestCard(
            '✨ Crear Cita',
            [
              _buildTestButton('Verificar Disponibilidad', () async {
                _setLoading();
                final result = await _appointmentsService.checkAvailability(
                  servicioId: '1',
                  sucursalId: '1',
                  fecha: DateTime.now().add(const Duration(days: 7)).toIso8601String(),
                );
                _updateResults('DISPONIBILIDAD:\n${result.toString()}');
              }),
              _buildTestButton('Personal Disponible', () async {
                _setLoading();
                final result = await _appointmentsService.getAvailableStaff(
                  servicioId: '1',
                  sucursalId: '1',
                  fechaHora: DateTime.now().add(const Duration(days: 7)).toIso8601String(),
                );
                _updateResults('PERSONAL:\n${result.toString()}');
              }),
              _buildTestButton('Crear Cita de Prueba', () async {
                _setLoading();
                final futureDate = DateTime.now().add(const Duration(days: 7));
                final result = await _appointmentsService.createAppointment(
                  servicioId: '1',
                  sucursalId: '1',
                  fechaHoraInicio: futureDate.toIso8601String(),
                  notasCliente: 'Cita de prueba desde la app',
                );
                _updateResults('CREAR CITA:\n${result.toString()}');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTests() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTestCard(
            '🛒 Mis Órdenes',
            [
              _buildTestButton('Obtener Mis Órdenes', () async {
                _setLoading();
                final result = await _ordersService.getUserOrders();
                _updateResults('MIS ÓRDENES:\n${result.toString()}');
              }),
              _buildTestButton('Historial de Compras', () async {
                _setLoading();
                final result = await _ordersService.getPurchaseHistory();
                _updateResults('HISTORIAL COMPRAS:\n${result.toString()}');
              }),
              _buildTestButton('Órdenes Pendientes', () async {
                _setLoading();
                final result = await _ordersService.getPendingOrders();
                _updateResults('PENDIENTES:\n${result.toString()}');
              }),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestCard(
            '🛍️ Crear Orden',
            [
              _buildTestButton('Calcular Total Carrito', () async {
                _setLoading();
                final productos = [
                  {'producto_id': '1', 'cantidad': 2, 'precio_unitario': 25.99},
                  {'producto_id': '2', 'cantidad': 1, 'precio_unitario': 15.50},
                ];
                final result = await _ordersService.calculateCartTotal(productos: productos);
                _updateResults('CÁLCULO TOTAL:\n${result.toString()}');
              }),
              _buildTestButton('Crear Orden de Prueba', () async {
                _setLoading();
                final productos = [
                  {'producto_id': '1', 'cantidad': 1, 'precio_unitario': 25.99},
                ];
                final result = await _ordersService.createOrder(
                  productos: productos,
                  direccionEnvioId: '1',
                  metodoPago: 'TARJETA',
                  notasEspeciales: 'Orden de prueba desde la app',
                );
                _updateResults('CREAR ORDEN:\n${result.toString()}');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestCard(String title, List<Widget> buttons) {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardTheme.color,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDC3545),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
} 