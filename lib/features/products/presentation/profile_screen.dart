// lib/features/profile/presentation/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../repositories/user_repository.dart';
import '../../appointments/providers/appointments_provider.dart';
import '../../cart/providers/cart_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  File? _imageFile;
  bool _isEditMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user != null) {
      _nameController.text = user.nombre;
      _emailController.text = user.email;
      _phoneController.text = user.telefono ?? '';
      _addressController.text = user.direccion ?? '';
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userRepository = UserRepository();

      await userRepository.updateUserProfile(
        userId: authProvider.currentUser!.id!,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        imageFile: _imageFile,
      );

      // Recargar los datos del usuario
      await authProvider.refreshUserData();

      if (mounted) {
        setState(() {
          _isEditMode = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar el perfil: $_errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appointmentsProvider = Provider.of<AppointmentsProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Perfil'),
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
                'Inicia sesión para ver tu perfil',
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

    final user = authProvider.currentUser!;
    final hasAppointments = appointmentsProvider.appointments.isNotEmpty;
    final hasCartItems = cartProvider.items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditMode = !_isEditMode;
                if (!_isEditMode) {
                  _loadUserData();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de información de perfil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isEditMode
                    ? _buildEditForm()
                    : _buildProfileInfo(user),
              ),
            ),

            const SizedBox(height: 24),

            // Sección de actividad reciente
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actividad Reciente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Citas programadas
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                      ),
                      title: const Text('Citas Programadas'),
                      subtitle: Text(
                        hasAppointments
                            ? 'Tienes ${appointmentsProvider.appointments.length} citas programadas'
                            : 'No tienes citas programadas',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/appointments');
                      },
                    ),

                    const Divider(),

                    // Carrito de compras
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                      title: const Text('Carrito de Compras'),
                      subtitle: Text(
                        hasCartItems
                            ? 'Tienes ${cartProvider.items.length} productos en tu carrito'
                            : 'Tu carrito está vacío',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Sección de opciones de cuenta
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Opciones de Cuenta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cambiar contraseña
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('Cambiar Contraseña'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/change-password');
                      },
                    ),

                    const Divider(),

                    // Historial de compras
                    ListTile(
                      leading: const Icon(Icons.receipt),
                      title: const Text('Historial de Compras'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.pushNamed(context, '/purchase-history');
                      },
                    ),

                    const Divider(),

                    // Cerrar sesión
                    ListTile(
                      leading: const Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onTap: () async {
                        // Mostrar diálogo de confirmación
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cerrar Sesión'),
                            content: const Text(
                              '¿Estás seguro de que quieres cerrar sesión?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Cerrar Sesión'),
                              ),
                            ],
                          ),
                        );

                        if (result == true && context.mounted) {
                          await authProvider.logout();
                          // Limpiar el carrito al cerrar sesión
                          cartProvider.clearCart();
                          // Redireccionar al inicio
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                                (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(user) {
    return Column(
      children: [
        // Foto de perfil
        CircleAvatar(
          radius: 50,
          backgroundImage: user.imagen != null
              ? NetworkImage('http://192.168.1.X:63106/images/${user.imagen}')
              : null,
          child: user.imagen == null
              ? const Icon(
            Icons.person,
            size: 50,
            color: Colors.white,
          )
              : null,
        ),
        const SizedBox(height: 16),

        // Nombre
        Text(
          user.nombre,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Correo electrónico
        Text(
          user.email,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),

        // Información adicional
        const Divider(),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Teléfono'),
          subtitle: Text(user.telefono ?? 'No especificado'),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Dirección'),
          subtitle: Text(user.direccion ?? 'No especificada'),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Foto de perfil
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : Provider.of<AuthProvider>(context).currentUser?.imagen != null
                    ? NetworkImage(
                  'http://192.168.1.X:63106/images/${Provider.of<AuthProvider>(context).currentUser!.imagen}',
                )
                    : null,
                child: _imageFile == null &&
                    Provider.of<AuthProvider>(context).currentUser?.imagen == null
                    ? const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                )
                    : null,
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                  onPressed: _pickImage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Campo de nombre
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campo de correo electrónico
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu correo electrónico';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Por favor ingresa un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campo de teléfono
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          const SizedBox(height: 16),

          // Campo de dirección
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Dirección',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 24),

          // Botón de guardar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
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
                'Guardar Cambios',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}