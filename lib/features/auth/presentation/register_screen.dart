// lib/features/auth/presentation/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';
import 'package:music_app/features/auth/presentation/login_screen.dart';
import 'package:music_app/features/auth/models/auth_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      final registerRequest = RegisterRequest(
        nombre: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        direccion: '', // Campo requerido pero no tenemos en el formulario
        telefono: _phoneController.text.isEmpty ? null : _phoneController.text.trim(),
      );
      
      final success = await authProvider.register(registerRequest);

      if (success && mounted) {
        Navigator.of(context).pop(); // Volver a la pantalla anterior después del registro
      }
    } catch (e) {
      // El error ya se maneja en el provider
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Crear Cuenta', style: TextStyle(color: colorScheme.primary)),
          backgroundColor: colorScheme.surface,
        ),
        body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    // Logo o ícono
                    Icon(
                    Icons.cut,
                    size: 60,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),

                  // Título
                  Text(
                    'Únete a BarberMusic & Spa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtítulo
                  Text(
                    'Crea una cuenta para disfrutar de todos nuestros servicios',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Mensaje de error
                  if (authProvider.errorMessage != null)
              Container(
              padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            authProvider.errorMessage!,
            style: TextStyle(color: colorScheme.onErrorContainer),
          ),
        ),

        if (authProvider.errorMessage != null)
    const SizedBox(height: 16),

    // Formulario
    Form(
    key: _formKey,
    child: Column(
    children: [
    // Campo de nombre
    TextFormField(
    controller: _nameController,
    decoration: InputDecoration(
    labelText: 'Nombre completo',
    hintText: 'Juan Pérez',
    prefixIcon: const Icon(Icons.person),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor ingresa tu nombre';
    }
    return null;
    },
    ),
    const SizedBox(height: 16),

    // Campo de correo
    TextFormField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
    labelText: 'Correo electrónico',
    hintText: 'ejemplo@correo.com',
    prefixIcon: const Icon(Icons.email),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor ingresa tu correo';
    }
    if (!value.contains('@') || !value.contains('.')) {
    return 'Ingresa un correo válido';
    }
    return null;
    },
    ),
    const SizedBox(height: 16),

    // Campo de teléfono (opcional)
    TextFormField(
    controller: _phoneController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
    labelText: 'Teléfono (opcional)',
    hintText: '55 1234 5678',
    prefixIcon: const Icon(Icons.phone),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    // Sin validador porque es opcional
    ),
    const SizedBox(height: 16),

    // Campo de contraseña
    TextFormField(
    controller: _passwordController,
    obscureText: _obscurePassword,
    decoration: InputDecoration(
    labelText: 'Contraseña',
    hintText: '••••••••',
    prefixIcon: const Icon(Icons.lock),
    suffixIcon: IconButton(
    icon: Icon(
    _obscurePassword ? Icons.visibility : Icons.visibility_off,
    ),
    onPressed: () {
    setState(() {
    _obscurePassword = !_obscurePassword;
    });
    },
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor ingresa una contraseña';
    }
    if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
    },
    ),
    const SizedBox(height: 16),

    // Campo de confirmar contraseña
    TextFormField(
    controller: _confirmPasswordController,
    obscureText: _obscureConfirmPassword,
    decoration: InputDecoration(
    labelText: 'Confirmar contraseña',
    hintText: '••••••••',
    prefixIcon: const Icon(Icons.lock_outline),
    suffixIcon: IconButton(
    icon: Icon(
    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
    ),
    onPressed: () {
    setState(() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    });
    },
    ),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    ),
    ),
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Por favor confirma tu contraseña';
    }
    if (value != _passwordController.text) {
    return 'Las contraseñas no coinciden';
    }
    return null;
    },
    ),
    const SizedBox(height: 16),

    // Checkbox de términos y condiciones
    CheckboxListTile(
    value: _acceptTerms,
    onChanged: (value) {
    setState(() {
    _acceptTerms = value ?? false;
    });
    },
    title: RichText(
    text: TextSpan(
    text: 'Acepto los ',
    style: TextStyle(color: colorScheme.onSurface),
    children: [
    TextSpan(
    text: 'Términos y Condiciones',
    style: TextStyle(
      color: colorScheme.primary,
      decoration: TextDecoration.underline,
    ),
      // GestureRecognizer se añadiría aquí para detectar toques
    ),
    ],
    ),
    ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: colorScheme.primary,
    ),
      const SizedBox(height: 24),

      // Botón de registro
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.primary.withOpacity(0.6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
            'CREAR CUENTA',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
    ),
    ),

                      const SizedBox(height: 32),

                      // Enlace de inicio de sesión
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¿Ya tienes una cuenta?',
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Inicia sesión',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
          ),
        ),
    );
  }
}