import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              // ignore: use_build_context_synchronously
              context.go('/login');
            },
          ),
        ],
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Inicia sesión para ver tu perfil.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Iniciar Sesión'),
                  )
                ],
              ),
            )
          : _buildProfileView(context, user),
    );
  }

  Widget _buildProfileView(BuildContext context, user) {
    return ListView(
      children: [
        _buildProfileHeader(context, user),
        const SizedBox(height: 20),
        _buildMenuList(context),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            // backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const SizedBox(height: 10),
          Text(
            user.nombre,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildMenuCard(
            context,
            icon: Icons.history,
            title: 'Historial de Citas',
            onTap: () => context.go('/perfil/historial'),
          ),
          const SizedBox(height: 10),
          _buildMenuCard(
            context,
            icon: Icons.favorite_border,
            title: 'Favoritos',
            onTap: () => context.go('/perfil/favoritos'),
          ),
          const SizedBox(height: 10),
          _buildMenuCard(
            context,
            icon: Icons.location_on_outlined,
            title: 'Mis Direcciones',
            onTap: () => context.go('/perfil/direcciones'),
          ),
          const SizedBox(height: 10),
          _buildMenuCard(
            context,
            icon: Icons.payment,
            title: 'Métodos de Pago',
            onTap: () => context.go('/perfil/metodos-pago'),
          ),
          const SizedBox(height: 10),
          _buildMenuCard(
            context,
            icon: Icons.help_outline,
            title: 'Ayuda y Soporte',
            onTap: () => context.go('/perfil/ayuda'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}