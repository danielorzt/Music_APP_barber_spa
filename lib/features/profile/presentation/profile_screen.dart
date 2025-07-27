import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButtonInterceptor(
      fallbackRoute: '/home',
      child: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (!authProvider.isAuthenticated) {
              return _buildLoginPrompt(context);
            }

            final user = authProvider.currentUser!;
            
            return CustomScrollView(
              slivers: [
                // App Bar con perfil del usuario
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  backgroundColor: Theme.of(context).primaryColor,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: user.avatarUrl != null 
                                  ? NetworkImage(user.avatarUrl!) 
                                  : null,
                              child: user.avatarUrl == null 
                                  ? Text(
                                      user.nombre[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.nombre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user.email,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Contenido del perfil
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estadísticas rápidas
                        _buildQuickStats(),
                        
                        const SizedBox(height: 24),
                        
                        // Sección Mi Cuenta
                        _buildSectionTitle('Mi Cuenta'),
                        _buildMenuItem(
                          icon: Icons.edit_outlined,
                          title: 'Editar Perfil',
                          subtitle: 'Actualiza tu información personal',
                          onTap: () {
                            // TODO: Implementar edición de perfil
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Función próximamente')),
                            );
                          },
                        ),
                        _buildMenuItem(
                          icon: Icons.history_outlined,
                          title: 'Historial',
                          subtitle: 'Ver tu historial de citas y compras',
                          onTap: () => context.push('/perfil/historial'),
                        ),
                        _buildMenuItem(
                          icon: Icons.favorite_outline,
                          title: 'Favoritos',
                          subtitle: 'Servicios y productos favoritos',
                          onTap: () => context.push('/perfil/favoritos'),
                        ),
                        _buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Direcciones',
                          subtitle: 'Gestiona tus direcciones de entrega',
                          onTap: () => context.push('/perfil/direcciones'),
                        ),
                        _buildMenuItem(
                          icon: Icons.payment_outlined,
                          title: 'Métodos de Pago',
                          subtitle: 'Tarjetas y métodos de pago',
                          onTap: () => context.push('/perfil/metodos-pago'),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sección Configuración
                        _buildSectionTitle('Configuración'),
                        _buildMenuItem(
                          icon: Icons.settings_outlined,
                          title: 'Configuración',
                          subtitle: 'Tema, idioma y preferencias',
                          onTap: () => context.push('/perfil/configuracion'),
                        ),
                        _buildMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notificaciones',
                          subtitle: 'Configura tus notificaciones',
                          onTap: () {
                            // TODO: Implementar configuración de notificaciones
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Función próximamente')),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Sección Soporte
                        _buildSectionTitle('Soporte'),
                        _buildMenuItem(
                          icon: Icons.help_outline,
                          title: 'Ayuda y Soporte',
                          subtitle: 'Preguntas frecuentes y contacto',
                          onTap: () => context.push('/perfil/ayuda'),
                        ),
                        _buildMenuItem(
                          icon: Icons.info_outline,
                          title: 'Acerca de',
                          subtitle: 'Información de la aplicación',
                          onTap: () {
                            showAboutDialog(
                              context: context,
                              applicationName: 'BarberMusic & Spa',
                              applicationVersion: '1.0.0',
                              applicationIcon: Icon(
                                Icons.spa,
                                size: 48,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Botón de cerrar sesión
                        _buildLogoutButton(context, authProvider),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 100,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              Text(
                'Inicia sesión para acceder a tu perfil',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Gestiona tus citas, favoritos, historial y mucho más',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Iniciar Sesión'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crear Cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Citas', '12', Icons.calendar_today),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Compras', '5', Icons.shopping_bag),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Puntos', '245', Icons.star),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: const Color(0xFFDC3545)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDC3545),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDC3545).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFDC3545)),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cerrar Sesión'),
              content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Cerrar Sesión'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            await authProvider.logout();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada exitosamente'),
                ),
              );
            }
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('Cerrar Sesión'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}