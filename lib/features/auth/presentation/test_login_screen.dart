import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class TestLoginScreen extends StatefulWidget {
  const TestLoginScreen({super.key});

  @override
  State<TestLoginScreen> createState() => _TestLoginScreenState();
}

class _TestLoginScreenState extends State<TestLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Credenciales de prueba predefinidas basadas en bd_definitiva.sql
  final Map<String, String> testAccounts = {
    'Admin General': 'admin@barbermusicaspa.com|password',
    'Admin Strada': 'admin.strada@barbermusicaspa.com|password',
    'Admin San Luis': 'admin.slp@barbermusicaspa.com|password',
    'Cliente Alejandra': 'alejandra.vazquez@gmail.com|password',
    'Cliente Roberto': 'roberto.silva@gmail.com|password',
    'Cliente Carmen': 'carmen.jimenez@hotmail.com|password',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('🧪 Prueba de Login API'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de la API
              Card(
                color: const Color(0xFFDC3545).withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.api, color: Color(0xFFDC3545)),
                          const SizedBox(width: 8),
                          Text(
                            'Configuración API',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'URL Base: http://192.168.39.148:8000/api',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Endpoint: /Client_usuarios/auth/login',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Cuentas de prueba
              Text(
                'Cuentas de Prueba Sugeridas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              
              ...testAccounts.entries.map((entry) {
                final credentials = entry.value.split('|');
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, color: Color(0xFFDC3545)),
                    title: Text(entry.key),
                    subtitle: Text('${credentials[0]} / ${credentials[1]}'),
                    onTap: () {
                      _emailController.text = credentials[0];
                      _passwordController.text = credentials[1];
                    },
                    trailing: const Icon(Icons.touch_app),
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 24),
              
              // Formulario de login
              Text(
                'Credenciales de Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un email';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Estado de autenticación
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    children: [
                      // Indicador de estado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getStatusColor(authProvider.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _getStatusColor(authProvider.status),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _getStatusIcon(authProvider.status),
                                  color: _getStatusColor(authProvider.status),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Estado: ${_getStatusText(authProvider.status)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            if (authProvider.error != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Error: ${authProvider.error}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            if (authProvider.currentUser != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Usuario: ${authProvider.currentUser!.nombre}',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Email: ${authProvider.currentUser!.email}',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Rol: ${authProvider.currentUser!.role}',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Botones de acción
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: authProvider.isLoading ? null : _testLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDC3545),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              icon: authProvider.isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.login, color: Colors.white),
                              label: Text(
                                authProvider.isLoading ? 'Probando...' : 'Probar Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (authProvider.isAuthenticated)
                            ElevatedButton.icon(
                              onPressed: authProvider.isLoading ? null : _testLogout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              icon: const Icon(Icons.logout, color: Colors.white),
                              label: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      if (authProvider.isAuthenticated) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.home, color: Colors.white),
                            label: const Text(
                              'Ir a la App Principal',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/api-test'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Color(0xFF28A745)),
                            ),
                            icon: const Icon(Icons.api, color: Color(0xFF28A745)),
                            label: const Text(
                              '🔧 Probar APIs del Cliente',
                              style: TextStyle(
                                color: Color(0xFF28A745),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _testLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login exitoso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Login falló: ${authProvider.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚪 Logout exitoso'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Color _getStatusColor(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return Colors.green;
      case AuthStatus.unauthenticated:
        return Colors.orange;
      case AuthStatus.loading:
        return Colors.blue;
      case AuthStatus.error:
        return Colors.red;
      case AuthStatus.initial:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return Icons.check_circle;
      case AuthStatus.unauthenticated:
        return Icons.account_circle_outlined;
      case AuthStatus.loading:
        return Icons.hourglass_empty;
      case AuthStatus.error:
        return Icons.error;
      case AuthStatus.initial:
        return Icons.help_outline;
    }
  }

  String _getStatusText(AuthStatus status) {
    switch (status) {
      case AuthStatus.authenticated:
        return 'Autenticado ✅';
      case AuthStatus.unauthenticated:
        return 'No Autenticado ⚪';
      case AuthStatus.loading:
        return 'Cargando... ⏳';
      case AuthStatus.error:
        return 'Error ❌';
      case AuthStatus.initial:
        return 'Inicial ❓';
    }
  }
} 