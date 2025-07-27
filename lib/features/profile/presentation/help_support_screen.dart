 
import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onBackground),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSupportOption(
            context,
            icon: Icons.quiz_outlined,
            title: 'Preguntas Frecuentes',
            onTap: () {
              // Navegar a la pantalla de FAQ
            },
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Contactar por Chat',
            onTap: () {
              // Iniciar un chat de soporte
            },
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            context,
            icon: Icons.email_outlined,
            title: 'Enviar un Correo',
            onTap: () {
              // Abrir cliente de correo
            },
          ),
          const SizedBox(height: 16),
          _buildSupportOption(
            context,
            icon: Icons.book_outlined,
            title: 'Guía de Usuario',
            onTap: () {
              // Mostrar la guía de usuario
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
} 