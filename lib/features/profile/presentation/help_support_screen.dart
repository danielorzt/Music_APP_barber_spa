import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final List<Map<String, dynamic>> _faqs = [
    {
      'question': '¿Cómo agendo una cita?',
      'answer': 'Para agendar una cita, ve a la sección "Servicios", selecciona el servicio que deseas, elige la sucursal, el profesional y la fecha/hora disponible.',
    },
    {
      'question': '¿Puedo cancelar mi cita?',
      'answer': 'Sí, puedes cancelar tu cita hasta 24 horas antes de la fecha programada. Ve a "Mis Citas" y selecciona la cita que deseas cancelar.',
    },
    {
      'question': '¿Cómo compro productos?',
      'answer': 'Navega a la sección "Productos", selecciona los productos que deseas, agrégalos al carrito y completa el proceso de compra.',
    },
    {
      'question': '¿Cuáles son los métodos de pago aceptados?',
      'answer': 'Aceptamos tarjetas de crédito/débito, PayPal y pagos en efectivo en nuestras sucursales.',
    },
    {
      'question': '¿Puedo cambiar mi información personal?',
      'answer': 'Sí, ve a tu perfil y selecciona "Configuración" para actualizar tu información personal.',
    },
    {
      'question': '¿Cómo contacto al soporte técnico?',
      'answer': 'Puedes contactarnos por teléfono al 555-123-4567, por email a soporte@barbermusicspa.com o a través del chat en vivo.',
    },
  ];

  final List<Map<String, dynamic>> _contactMethods = [
    {
      'title': 'Teléfono',
      'subtitle': '555-123-4567',
      'icon': Icons.phone,
      'action': 'Llamar',
    },
    {
      'title': 'Email',
      'subtitle': 'soporte@barbermusicspa.com',
      'icon': Icons.email,
      'action': 'Enviar email',
    },
    {
      'title': 'Chat en vivo',
      'subtitle': 'Disponible 24/7',
      'icon': Icons.chat,
      'action': 'Iniciar chat',
    },
    {
      'title': 'WhatsApp',
      'subtitle': '+57 300 123 4567',
      'icon': Icons.message,
      'action': 'Abrir WhatsApp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda y Soporte'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de contacto
            _buildContactSection(),
            const SizedBox(height: 24),
            
            // Sección de preguntas frecuentes
            _buildFaqSection(),
            const SizedBox(height: 24),
            
            // Sección de recursos
            _buildResourcesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_support, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Contacto',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_contactMethods.map((method) => _buildContactMethod(method)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod(Map<String, dynamic> method) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFDC3545).withOpacity(0.1),
        child: Icon(
          method['icon'] as IconData,
          color: const Color(0xFFDC3545),
        ),
      ),
      title: Text(
        method['title'] as String,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(method['subtitle'] as String),
      trailing: TextButton(
        onPressed: () => _handleContactAction(method),
        child: Text(
          method['action'] as String,
          style: const TextStyle(color: Color(0xFFDC3545)),
        ),
      ),
    );
  }

  void _handleContactAction(Map<String, dynamic> method) {
    final action = method['action'] as String;
    final subtitle = method['subtitle'] as String;
    
    switch (action) {
      case 'Llamar':
        // TODO: Implementar llamada telefónica
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Llamando a $subtitle')),
        );
        break;
      case 'Enviar email':
        // TODO: Implementar envío de email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Abriendo email a $subtitle')),
        );
        break;
      case 'Iniciar chat':
        // TODO: Implementar chat en vivo
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Iniciando chat en vivo...')),
        );
        break;
      case 'Abrir WhatsApp':
        // TODO: Implementar WhatsApp
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Abriendo WhatsApp: $subtitle')),
        );
        break;
    }
  }

  Widget _buildFaqSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.question_answer, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Preguntas Frecuentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_faqs.map((faq) => _buildFaqItem(faq)).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq) {
    return ExpansionTile(
      title: Text(
        faq['question'] as String,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            faq['answer'] as String,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildResourcesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.library_books, color: const Color(0xFFDC3545)),
                const SizedBox(width: 8),
                const Text(
                  'Recursos Útiles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildResourceItem(
              'Política de Privacidad',
              'Conoce cómo protegemos tu información',
              Icons.privacy_tip,
              () {
                // TODO: Navegar a política de privacidad
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abriendo política de privacidad...')),
                );
              },
            ),
            const Divider(),
            _buildResourceItem(
              'Términos y Condiciones',
              'Lee nuestros términos de servicio',
              Icons.description,
              () {
                // TODO: Navegar a términos y condiciones
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abriendo términos y condiciones...')),
                );
              },
            ),
            const Divider(),
            _buildResourceItem(
              'Guía de Usuario',
              'Aprende a usar la aplicación',
              Icons.help_outline,
              () {
                // TODO: Navegar a guía de usuario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Abriendo guía de usuario...')),
                );
              },
            ),
            const Divider(),
            _buildResourceItem(
              'Reportar un Problema',
              'Ayúdanos a mejorar la aplicación',
              Icons.bug_report,
              () {
                _showReportProblemDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFDC3545)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showReportProblemDialog() {
    final problemController = TextEditingController();
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reportar Problema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: problemController,
              decoration: const InputDecoration(
                labelText: 'Describe el problema',
                hintText: 'Explica detalladamente el problema que encontraste...',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Tu email (opcional)',
                hintText: 'Para recibir actualizaciones',
              ),
              keyboardType: TextInputType.emailAddress,
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
              if (problemController.text.isNotEmpty) {
                // TODO: Enviar reporte al servidor
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reporte enviado. Gracias por tu feedback.')),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
} 