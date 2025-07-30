import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? Colors.black 
          : Colors.white,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? Colors.black 
            : Colors.white,
        foregroundColor: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white 
            : Colors.black,
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (!authProvider.isAuthenticated) {
            return _buildLoginPrompt(context);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(context, authProvider),
                const SizedBox(height: 20),
                _buildQuickStats(context),
                const SizedBox(height: 20),
                _buildMenuItems(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 100,
              color: isDarkMode ? Colors.white70 : Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Inicia sesión para acceder a tu perfil',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Gestiona tus citas, favoritos, historial y mucho más',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC3545),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/register'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC3545),
                  side: const BorderSide(color: Color(0xFFDC3545)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Crear Cuenta'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AuthProvider authProvider) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    if (authProvider.currentUser == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFDC3545),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No autenticado',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inicia sesión para ver tu perfil',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    final user = authProvider.currentUser!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFDC3545),
            backgroundImage: user['avatar_url'] != null
                ? NetworkImage(user['avatar_url'])
                : null,
            child: user['avatar_url'] == null
                ? Text(
                    user['nombre']?[0]?.toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user['nombre'] ?? 'Usuario',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user['email'] ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.calendar_today,
              title: 'Citas',
              value: '12',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.shopping_bag,
              title: 'Compras',
              value: '8',
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context,
              icon: Icons.favorite,
              title: 'Favoritos',
              value: '5',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final menuItems = [
      {'icon': Icons.location_on, 'title': 'Mis Direcciones', 'route': '/profile/addresses'},
      {'icon': Icons.favorite, 'title': 'Mis Favoritos', 'route': '/profile/favorites'},
      {'icon': Icons.history, 'title': 'Historial', 'route': '/profile/history'},
      {'icon': Icons.payment, 'title': 'Métodos de Pago', 'route': '/profile/payment-methods'},
      {'icon': Icons.help, 'title': 'Ayuda y Soporte', 'route': '/profile/help-support'},
      {'icon': Icons.settings, 'title': 'Configuración', 'route': '/profile/settings'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: menuItems.map((item) => _buildMenuItem(
          context,
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          onTap: () {
            context.push(item['route'] as String);
          },
        )).toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white10 : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.grey[300]!,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFDC3545),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: isDarkMode ? Colors.white70 : Colors.grey[600],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}