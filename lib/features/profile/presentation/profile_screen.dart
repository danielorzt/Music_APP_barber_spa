import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil', style: TextStyle(color: colorScheme.primary)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoSection(context),
            const SizedBox(height: 24),
            _buildPlanSection(context),
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
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.primary.withOpacity(0.2),
          child: Icon(Icons.person, size: 40, color: colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, Sepide',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'thefutterway@gmail.com',
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanSection(BuildContext context) {
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
                  label: const Text('Premium'),
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Todas las funciones desbloqueadas',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              _buildListTile(context, icon: Icons.logout, title: 'Cerrar sesión', onTap: () {}, textColor: Colors.red),
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

  // Añadimos el método faltante _buildSwitchListTile
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