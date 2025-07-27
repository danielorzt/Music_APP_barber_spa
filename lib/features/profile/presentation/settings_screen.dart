import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/providers/settings_provider.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButtonInterceptor(
      fallbackRoute: '/perfil',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configuración'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/perfil');
            },
          ),
        ),
        body: Consumer<SettingsProvider>(
          builder: (context, settings, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Sección Apariencia
                _buildSectionHeader('Apariencia'),
                const SizedBox(height: 8),
                
                _buildSettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Tema',
                  subtitle: settings.themeModeString,
                  onTap: () => _showThemeDialog(context, settings),
                ),
                
                const SizedBox(height: 24),
                
                // Sección Idioma
                _buildSectionHeader('Idioma'),
                const SizedBox(height: 8),
                
                _buildSettingsTile(
                  icon: Icons.language_outlined,
                  title: 'Idioma de la aplicación',
                  subtitle: settings.languageString,
                  onTap: () => _showLanguageDialog(context, settings),
                ),
                
                const SizedBox(height: 24),
                
                // Sección Información
                _buildSectionHeader('Información'),
                const SizedBox(height: 8),
                
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'Acerca de',
                  subtitle: 'BarberMusic & Spa v1.0.0',
                  onTap: () => _showAboutDialog(context),
                ),
                
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Política de Privacidad',
                  subtitle: 'Términos y condiciones',
                  onTap: () {
                    // TODO: Implementar navegación a política de privacidad
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función próximamente')),
                    );
                  },
                ),
                
                _buildSettingsTile(
                  icon: Icons.help_outline,
                  title: 'Ayuda y Soporte',
                  subtitle: 'Obtén ayuda con la aplicación',
                  onTap: () {
                    // TODO: Implementar navegación a ayuda
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Función próximamente')),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showThemeDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppThemeMode>(
              title: const Text('Claro'),
              value: AppThemeMode.light,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settings.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Oscuro'),
              value: AppThemeMode.dark,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settings.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: const Text('Sistema'),
              value: AppThemeMode.system,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settings.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppLanguage>(
              title: const Text('Español'),
              value: AppLanguage.spanish,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settings.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: const Text('English'),
              value: AppLanguage.english,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settings.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: const Text('Português'),
              value: AppLanguage.portuguese,
              groupValue: settings.language,
              onChanged: (value) {
                if (value != null) {
                  settings.setLanguage(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'BarberMusic & Spa',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.spa,
        size: 48,
        color: Color(0xFFDC3545),
      ),
      children: [
        const Text(
          'Una aplicación moderna para barbería y spa que combina estilo con relajación.',
        ),
        const SizedBox(height: 16),
        const Text(
          'Desarrollado con Flutter para ofrecer la mejor experiencia de usuario.',
        ),
      ],
    );
  }
} 