import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/profile/models/user_model.dart';
import 'package:music_app/features/profile/repositories/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final userRepository = Provider.of<UserRepository>(context, listen: false);
    _userFuture = userRepository.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil', style: TextStyle(color: colorScheme.primary)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si no hay usuario, mostrar pantalla de login/registro
          if (snapshot.data == null) {
            return _buildLoginPrompt(context);
          }

          // Si hay usuario, mostrar perfil
          final user = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserInfoSection(context, user),
                const SizedBox(height: 24),
                _buildPlanSection(context, user),
                const SizedBox(height: 24),
                _buildAccountSection(context),
                const SizedBox(height: 24),
                _buildPersonalizationSection(context),
                const SizedBox(height: 24),
                _buildSettingsSection(context),
                const SizedBox(height: 24),
                _buildHelpSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // lib/features/profile/presentation/profile_screen.dart
// Actualizar la función _buildLoginPrompt

  Widget _buildLoginPrompt(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 100,
            color: colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          const Text(
            'Inicia sesión para ver tu perfil',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Iniciar Sesión'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            child: Text(
              'Crear una cuenta',
              style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, User user) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.primary.withOpacity(0.2),
          backgroundImage: user.imageUrl.isNotEmpty ? NetworkImage(user.imageUrl) : null,
          child: user.imageUrl.isEmpty
              ? Icon(Icons.person, size: 40, color: colorScheme.primary)
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${user.name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanSection(BuildContext context, User user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Plan BarberMusic',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Chip(
                  label: Text(user.isPremium ? 'Premium' : 'Básico'),
                  backgroundColor: user.isPremium
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceVariant,
                  labelStyle: TextStyle(
                      color: user.isPremium
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              user.isPremium
                  ? 'Todas las funciones desbloqueadas'
                  : 'Mejora a Premium para más beneficios',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            if (!user.isPremium) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Lógica para actualizar a premium
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Actualizar a Premium'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // El resto de los métodos son iguales a los de la versión anterior
  // _buildAccountSection, _buildPersonalizationSection, etc.

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MI CUENTA',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildListTile(context, icon: Icons.shopping_bag, title: 'Mis Reservas', onTap: () {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.assignment_return, title: 'Historial', onTap: () {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.favorite, title: 'Favoritos', onTap: () {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.location_on, title: 'Direcciones', onTap: () {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.payment, title: 'Métodos de pago', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalizationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PERSONALIZACIÓN',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildSwitchListTile(context, icon: Icons.notifications, title: 'Notificaciones', value: true, onChanged: (value) {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.settings, title: 'Preferencias', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONFIGURACIÓN',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildListTile(context, icon: Icons.language, title: 'Idioma', onTap: () {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.location_on, title: 'Ubicación', onTap: () {}),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpSection(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AYUDA Y SOPORTE',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildListTile(context, icon: Icons.help, title: 'Obtener ayuda', onTap: () {}),
              _buildDivider(),
              _buildListTile(context, icon: Icons.question_answer, title: 'Preguntas frecuentes', onTap: () {}),
              _buildDivider(),
              // Reemplazar el _buildListTile para cerrar sesión
              _buildListTile(
                  context,
                  icon: Icons.logout,
                  title: 'Cerrar sesión',
                  onTap: () async {
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.logout();
                    setState(() {
                      _loadUser();
                    });
                  },
                  textColor: Colors.red
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: textColor ?? Theme.of(context).colorScheme.onSurface)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
      onTap: onTap,
    );
  }

  Widget _buildSwitchListTile(BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey.withOpacity(0.1));
  }
}