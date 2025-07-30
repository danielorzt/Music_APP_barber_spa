import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de apariencia
                _buildAppearanceSection(settingsProvider),
                const SizedBox(height: 24),
                
                // Sección de notificaciones
                _buildNotificationsSection(settingsProvider),
                const SizedBox(height: 24),
                
                // Sección de privacidad
                _buildPrivacySection(settingsProvider),
                const SizedBox(height: 24),
                
                // Sección de cuenta
                _buildAccountSection(),
                const SizedBox(height: 24),
                
                // Sección de datos
                _buildDataSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppearanceSection(SettingsProvider settingsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Apariencia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Tema'),
              subtitle: Text(_getThemeText(settingsProvider.flutterThemeMode)),
              trailing: DropdownButton<ThemeMode>(
                value: settingsProvider.flutterThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('Sistema'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Claro'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Oscuro'),
                  ),
                ],
                onChanged: (ThemeMode? newValue) {
                  if (newValue != null) {
                    settingsProvider.setFlutterThemeMode(newValue);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Idioma'),
              subtitle: Text(_getLanguageText(settingsProvider.locale)),
              trailing: DropdownButton<Locale>(
                value: settingsProvider.locale,
                items: const [
                  DropdownMenuItem(
                    value: Locale('es', 'ES'),
                    child: Text('Español'),
                  ),
                  DropdownMenuItem(
                    value: Locale('en', 'US'),
                    child: Text('English'),
                  ),
                ],
                onChanged: (Locale? newValue) {
                  if (newValue != null) {
                    settingsProvider.setLocale(newValue);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(SettingsProvider settingsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Notificaciones',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              secondary: const Icon(Icons.calendar_today),
              title: const Text('Recordatorios de citas'),
              subtitle: const Text('Recibe notificaciones antes de tus citas'),
              value: settingsProvider.appointmentReminders,
              onChanged: (bool value) {
                settingsProvider.setAppointmentReminders(value);
              },
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.local_offer),
              title: const Text('Ofertas y promociones'),
              subtitle: const Text('Recibe notificaciones de descuentos'),
              value: settingsProvider.promotionNotifications,
              onChanged: (bool value) {
                settingsProvider.setPromotionNotifications(value);
              },
            ),
            const Divider(),
            SwitchListTile(
              secondary: const Icon(Icons.shopping_bag),
              title: const Text('Actualizaciones de pedidos'),
              subtitle: const Text('Recibe notificaciones sobre tus compras'),
              value: settingsProvider.orderUpdates,
              onChanged: (bool value) {
                settingsProvider.setOrderUpdates(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(SettingsProvider settingsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Privacidad y Seguridad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Autenticación biométrica'),
              subtitle: const Text('Usar huella dactilar o Face ID'),
              trailing: Switch(
                value: settingsProvider.biometricAuth,
                onChanged: (bool value) {
                  settingsProvider.setBiometricAuth(value);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Ubicación'),
              subtitle: const Text('Compartir ubicación para servicios'),
              trailing: Switch(
                value: settingsProvider.locationSharing,
                onChanged: (bool value) {
                  settingsProvider.setLocationSharing(value);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Análisis de uso'),
              subtitle: const Text('Ayudar a mejorar la aplicación'),
              trailing: Switch(
                value: settingsProvider.analyticsEnabled,
                onChanged: (bool value) {
                  settingsProvider.setAnalyticsEnabled(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Cuenta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar perfil'),
              subtitle: const Text('Cambiar información personal'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navegar a editar perfil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar contraseña'),
              subtitle: const Text('Actualizar tu contraseña'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showChangePasswordDialog();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Verificar email'),
              subtitle: const Text('Confirmar tu dirección de email'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implementar verificación de email
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email de verificación enviado')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Datos y Almacenamiento',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Descargar mis datos'),
              subtitle: const Text('Obtener una copia de tu información'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Implementar descarga de datos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Descargando datos...')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Eliminar cuenta'),
              subtitle: const Text('Eliminar permanentemente tu cuenta'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showDeleteAccountDialog();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              subtitle: const Text('Salir de tu cuenta'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeText(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return 'Sistema';
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
    }
  }

  String _getLanguageText(Locale locale) {
    switch (locale.languageCode) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Español';
    }
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña actual',
                hintText: 'Ingresa tu contraseña actual',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                hintText: 'Ingresa tu nueva contraseña',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirmar nueva contraseña',
                hintText: 'Confirma tu nueva contraseña',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text == confirmPasswordController.text &&
                  newPasswordController.text.isNotEmpty) {
                // TODO: Implementar cambio de contraseña
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contraseña actualizada exitosamente')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Las contraseñas no coinciden')),
                );
              }
            },
            child: const Text('Cambiar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cuenta'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar eliminación de cuenta
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cuenta eliminada')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
} 