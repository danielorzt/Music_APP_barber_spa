import 'package:flutter/material.dart';
import '../../../core/services/connection_test_service.dart';
import '../../../core/services/unified_catalog_service.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/models/producto.dart';
import '../../../core/models/servicio.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final ConnectionTestService _connectionService = ConnectionTestService();
  final UnifiedCatalogService _catalogService = UnifiedCatalogService();
  final AuthApiService _authService = AuthApiService();
  
  bool _isLoading = false;
  Map<String, dynamic>? _testResults;
  List<Producto> _productos = [];
  List<Servicio> _servicios = [];
  String? _error;
  
  // Credenciales de prueba
  final TextEditingController _emailController = TextEditingController(text: 'test2@example.com');
  final TextEditingController _passwordController = TextEditingController(text: 'password123');
  String? _authToken;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Probar conectividad básica
      final connectionResults = await _connectionService.testAllEndpoints();
      
      // Probar autenticación
      await _testAuthentication();
      
      // Probar catálogo con autenticación
      if (_isAuthenticated) {
        final productos = await _catalogService.getProductos();
        final servicios = await _catalogService.getServicios();
        
        setState(() {
          _productos = productos;
          _servicios = servicios;
        });
      }
      
      setState(() {
        _testResults = connectionResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _testAuthentication() async {
    try {
      print('🔐 Probando autenticación...');
      
      final loginResult = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
      
      if (loginResult['success'] == true) {
        setState(() {
          _isAuthenticated = true;
          _authToken = loginResult['token'];
        });
        print('✅ Autenticación exitosa');
      } else {
        setState(() {
          _isAuthenticated = false;
          _authToken = null;
        });
        print('❌ Autenticación fallida: ${loginResult['message']}');
      }
    } catch (e) {
      setState(() {
        _isAuthenticated = false;
        _authToken = null;
      });
      print('❌ Error en autenticación: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Prueba de Conexión'),
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runTests,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF121212),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF00D4AA)),
                  SizedBox(height: 16),
                  Text(
                    'Probando conexión...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : _error != null
              ? _buildErrorView()
              : _buildResultsView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Error de Conexión',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _runTests,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4AA),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConnectionStatus(),
          const SizedBox(height: 24),
          _buildAuthenticationStatus(),
          const SizedBox(height: 24),
          _buildCatalogResults(),
          const SizedBox(height: 24),
          if (_isAuthenticated) ...[
            _buildProductosList(),
            const SizedBox(height: 24),
            _buildServiciosList(),
          ],
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    if (_testResults == null) return const SizedBox.shrink();

    final results = _testResults!['results'] as Map<String, dynamic>;
    final successfulTests = _testResults!['successfulTests'] as int;
    final totalTests = _testResults!['totalTests'] as int;

    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  successfulTests == totalTests ? Icons.check_circle : Icons.warning,
                  color: successfulTests == totalTests ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estado de Conexión',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${successfulTests} de $totalTests pruebas exitosas',
              style: TextStyle(
                color: successfulTests == totalTests ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...results.entries.map((entry) => _buildTestResult(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticationStatus() {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isAuthenticated ? Icons.check_circle : Icons.error,
                  color: _isAuthenticated ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estado de Autenticación',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isAuthenticated ? 'Autenticado' : 'No autenticado',
              style: TextStyle(
                color: _isAuthenticated ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Email: ${_emailController.text}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            if (_authToken != null)
              Text(
                'Token: ${_authToken!.substring(0, 20)}...',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResult(String testName, Map<String, dynamic> result) {
    final isSuccess = result['success'] == true;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            color: isSuccess ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              testName.toUpperCase(),
              style: TextStyle(
                color: isSuccess ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (result['count'] != null)
            Text(
              '${result['count']} items',
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _buildCatalogResults() {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.inventory, color: Color(0xFF00D4AA)),
                const SizedBox(width: 8),
                Text(
                  'Catálogo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Productos', _productos.length, Icons.shopping_bag),
                const SizedBox(width: 16),
                _buildStatCard('Servicios', _servicios.length, Icons.content_cut),
              ],
            ),
            const SizedBox(height: 16),
            if (!_isAuthenticated)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Los catálogos requieren autenticación',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF00D4AA)),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosList() {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_bag, color: Color(0xFF00D4AA)),
                const SizedBox(width: 8),
                Text(
                  'Productos (${_productos.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_productos.isEmpty)
              const Text(
                'No se encontraron productos',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._productos.take(5).map((producto) => _buildProductoItem(producto)),
            if (_productos.length > 5)
              Text(
                '... y ${_productos.length - 5} más',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductoItem(Producto producto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${producto.precio}',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiciosList() {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.content_cut, color: Color(0xFF00D4AA)),
                const SizedBox(width: 8),
                Text(
                  'Servicios (${_servicios.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_servicios.isEmpty)
              const Text(
                'No se encontraron servicios',
                style: TextStyle(color: Colors.grey),
              )
            else
              ..._servicios.take(5).map((servicio) => _buildServicioItem(servicio)),
            if (_servicios.length > 5)
              Text(
                '... y ${_servicios.length - 5} más',
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicioItem(Servicio servicio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4AA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.content_cut, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  servicio.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '\$${servicio.precio} - ${servicio.duracionEnMinutos} min',
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 