import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/config/dev_config.dart';
import '../../../core/config/api_config.dart';
import '../../../core/services/auth_api_service.dart';
import 'package:dio/dio.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  bool _isLoading = false;
  bool _serverAvailable = false;
  String _serverStatus = 'Verificando...';
  String _testResult = '';
  String _selectedUrl = ApiConfig.baseUrl;
  List<Map<String, dynamic>> _urlTestResults = [];
  
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkServerStatus();
    _loadTestCredentials();
  }

  void _loadTestCredentials() {
    final testUser = DevConfig.testUsers['cliente1'];
    _emailController.text = testUser?['email'] ?? '';
    _passwordController.text = testUser?['password'] ?? '';
  }

  Future<void> _checkServerStatus() async {
    setState(() {
      _isLoading = true;
      _serverStatus = 'Verificando conectividad...';
      _urlTestResults.clear();
    });

    try {
      // Probar todas las URLs disponibles
      for (String url in ApiConfig.alternativeUrls) {
        final result = await _testUrl(url);
        _urlTestResults.add({
          'url': url,
          'available': result,
          'status': result ? '✅ Conectado' : '❌ No disponible',
        });
      }

      // Determinar si al menos una URL está disponible
      final isAvailable = _urlTestResults.any((result) => result['available'] == true);
      
      setState(() {
        _serverAvailable = isAvailable;
        _serverStatus = isAvailable 
            ? 'Servidor conectado' 
            : 'Servidor no disponible - Usando datos de prueba';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _serverAvailable = false;
        _serverStatus = 'Error verificando servidor: $e';
        _isLoading = false;
      });
    }
  }

  Future<bool> _testUrl(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '$url/health',
        options: Options(
          sendTimeout: DevConfig.shortTimeout,
          receiveTimeout: DevConfig.shortTimeout,
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Probando login...';
    });

    try {
      final authService = AuthApiService();
      final result = await authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _testResult = result['success'] 
            ? '✅ Login exitoso\nUsuario: ${result['user']?['nombre'] ?? 'N/A'}'
            : '❌ Login fallido\nError: ${result['error']}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Error en prueba: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testRegister() async {
    setState(() {
      _isLoading = true;
      _testResult = 'Probando registro...';
    });

    try {
      final authService = AuthApiService();
      final result = await authService.register(
        nombre: 'Usuario Test',
        email: 'test${DateTime.now().millisecondsSinceEpoch}@example.com',
        password: 'password123',
        telefono: '1234567890',
      );

      setState(() {
        _testResult = result['success'] 
            ? '✅ Registro exitoso\nUsuario: ${result['user']?['nombre'] ?? 'N/A'}'
            : '❌ Registro fallido\nError: ${result['error']}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _testResult = '❌ Error en prueba: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Configuración API'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Estado del servidor
            Card(
              color: isDarkMode ? Colors.white10 : Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _serverAvailable ? Icons.check_circle : Icons.error,
                          color: _serverAvailable ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estado del Servidor',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_serverStatus),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _checkServerStatus,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Verificar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDC3545),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showDebugInfo();
                            },
                            icon: const Icon(Icons.info),
                            label: const Text('Info'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Resultados de prueba de URLs
            if (_urlTestResults.isNotEmpty)
              Card(
                color: isDarkMode ? Colors.white10 : Colors.grey[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pruebas de Conectividad',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._urlTestResults.map((result) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              result['available'] ? Icons.check_circle : Icons.cancel,
                              color: result['available'] ? Colors.green : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                result['url'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                ),
                              ),
                            ),
                            Text(
                              result['status'],
                              style: TextStyle(
                                fontSize: 12,
                                color: result['available'] ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Configuración de prueba
            Card(
              color: isDarkMode ? Colors.white10 : Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pruebas de Autenticación',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Campos de prueba
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email de prueba',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña de prueba',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Botones de prueba
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _testLogin,
                            icon: const Icon(Icons.login),
                            label: const Text('Probar Login'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _testRegister,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Probar Registro'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Resultados de prueba
            if (_testResult.isNotEmpty)
              Card(
                color: isDarkMode ? Colors.white10 : Colors.grey[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resultado de Prueba',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _testResult,
                        style: TextStyle(
                          color: _testResult.contains('✅') 
                              ? Colors.green 
                              : _testResult.contains('❌') 
                                  ? Colors.red 
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Información de configuración
            Card(
              color: isDarkMode ? Colors.white10 : Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información de Configuración',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('URL Base: ${ApiConfig.baseUrl}'),
                    Text('Modo Desarrollo: ${ApiConfig.isDevelopment ? 'Sí' : 'No'}'),
                    Text('Modo Desarrollo: ${ApiConfig.isDevelopment ? 'Habilitado' : 'Deshabilitado'}'),
                    Text('Timeout: ${DevConfig.shortTimeout.inSeconds}s'),
                    const SizedBox(height: 8),
                    Text(
                      'URLs Alternativas:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...ApiConfig.alternativeUrls.map((url) => Text(
                      '  • $url',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: isDarkMode ? Colors.white70 : Colors.grey[700],
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón para volver
            ElevatedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC3545),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDebugInfo() {
    final debugInfo = ApiConfig.getDebugInfo();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información de Debug'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('URL Base: ${debugInfo['baseUrl']}'),
              Text('Modo Desarrollo: ${debugInfo['isDevelopment']}'),
              const SizedBox(height: 8),
              Text('URLs Alternativas:'),
              ...debugInfo['alternativeUrls'].map((url) => Text('  • $url')),
              const SizedBox(height: 8),
              Text('Endpoints de Auth:'),
              ...debugInfo['auth_endpoints'].entries.map(
                (e) => Text('  • ${e.key}: ${e.value}'),
              ),
              const SizedBox(height: 8),
              Text('Cuentas de Prueba: ${debugInfo['testAccountsCount']}'),
            ],
          ),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 