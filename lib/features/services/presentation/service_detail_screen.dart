import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/services/models/service_model.dart';
import 'package:music_app/features/services/providers/services_provider.dart';
import '../../../core/widgets/auth_guard.dart';
import '../../../features/auth/providers/auth_provider.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailScreen({
    super.key,
    required this.service,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Debug: Imprimir información del servicio
    print('🔍 ServiceDetailScreen - Servicio recibido:');
    print('  ID: ${widget.service.id}');
    print('  Nombre: ${widget.service.name}');
    print('  Descripción: ${widget.service.description}');
    print('  Precio: ${widget.service.price}');
    print('  Duración: ${widget.service.duration}');
    print('  Imagen: ${widget.service.imagen}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Iniciar Sesión Requerido'),
        content: const Text('Para agendar una cita necesitas iniciar sesión en tu cuenta.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
            ),
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('🔍 ServiceDetailScreen - Construyendo widget');
    
    // Verificar si el servicio tiene datos válidos
    if (widget.service.name.isEmpty) {
      print('❌ ServiceDetailScreen - Nombre del servicio está vacío');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error al cargar el servicio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('No se pudieron cargar los datos del servicio'),
            ],
          ),
        ),
      );
    }

    print('✅ ServiceDetailScreen - Construyendo pantalla normal');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name),
        backgroundColor: const Color(0xFFDC3545),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del servicio
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: _buildServiceImage(),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información básica
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.service.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.service.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC3545),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Duración y rating
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.service.duration} min',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const Icon(Icons.star_half, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '4.5 (89 reseñas)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFFDC3545),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFFDC3545),
                    tabs: const [
                      Tab(text: 'Descripción'),
                      Tab(text: 'Incluye'),
                      Tab(text: 'Reseñas'),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contenido de tabs
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDescriptionTab(),
                        _buildIncludesTab(),
                        _buildReviewsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildServiceImage() {
    // Si hay imagen del servicio, usarla
    if (widget.service.imagen != null && widget.service.imagen!.isNotEmpty) {
      return Image.network(
        widget.service.imagen!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultServiceImage();
        },
      );
    }
    
    // Si no hay imagen, usar imagen por defecto basada en el nombre del servicio
    return _buildDefaultServiceImage();
  }

  Widget _buildDefaultServiceImage() {
    // Mapear el nombre del servicio a una imagen por defecto
    String defaultImageUrl = 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop';
    
    final serviceName = widget.service.name.toLowerCase();
    if (serviceName.contains('corte') || serviceName.contains('cabello')) {
      defaultImageUrl = 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop';
    } else if (serviceName.contains('barba')) {
      defaultImageUrl = 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop';
    } else if (serviceName.contains('spa') || serviceName.contains('masaje')) {
      defaultImageUrl = 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop';
    } else if (serviceName.contains('facial')) {
      defaultImageUrl = 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop';
    }
    
    return Image.network(
      defaultImageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(
            Icons.spa,
            size: 80,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildDescriptionTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Descripción',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.service.description.isNotEmpty 
                ? widget.service.description 
                : 'Descripción del servicio no disponible.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          
          // Beneficios
          const Text(
            'Beneficios',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildBenefitItem('✅ Profesional certificado'),
          _buildBenefitItem('✅ Productos premium'),
          _buildBenefitItem('✅ Ambiente relajante'),
          _buildBenefitItem('✅ Resultados garantizados'),
          _buildBenefitItem('✅ Atención personalizada'),
          _buildBenefitItem('✅ Técnicas modernas'),
        ],
      ),
    );
  }

  Widget _buildIncludesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'El servicio incluye',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildIncludeItem('Consultación inicial', Icons.chat),
          _buildIncludeItem('Limpieza y preparación', Icons.cleaning_services),
          _buildIncludeItem('Servicio profesional', Icons.person),
          _buildIncludeItem('Productos de calidad', Icons.spa),
          _buildIncludeItem('Consejos de cuidado', Icons.tips_and_updates),
          _buildIncludeItem('Seguimiento post-servicio', Icons.phone),
          _buildIncludeItem('Ambiente relajante', Icons.music_note),
          _buildIncludeItem('Técnicas especializadas', Icons.psychology),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reseñas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implementar escribir reseña
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Función de reseñas próximamente')),
                  );
                },
                child: const Text('Escribir reseña'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Reseñas mock
          _buildReviewItem(
            'Carlos M.',
            5,
            'Excelente servicio, muy profesional y el resultado fue increíble.',
            '2025-01-15',
          ),
          _buildReviewItem(
            'Miguel R.',
            4,
            'Buen servicio, el personal es muy amable.',
            '2025-01-10',
          ),
          _buildReviewItem(
            'Luis A.',
            5,
            'Muy recomendado, volveré sin duda.',
            '2025-01-05',
          ),
          _buildReviewItem(
            'Ana S.',
            5,
            'Servicio de primera calidad, muy satisfecha.',
            '2025-01-03',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildIncludeItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFDC3545),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, int rating, String comment, String date) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Información del precio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precio',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${widget.service.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC3545),
                  ),
                ),
              ],
            ),
          ),
          
          // Botón agendar
          Expanded(
            flex: 2,
            child: Builder(
              builder: (context) {
                try {
                  return Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return ElevatedButton(
                        onPressed: () {
                          if (!authProvider.isAuthenticated) {
                            _showLoginRequiredDialog();
                            return;
                          }
                          context.push('/agendar?servicio_id=${widget.service.id}&servicio_nombre=${Uri.encodeComponent(widget.service.name)}&servicio_precio=${widget.service.price}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC3545),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Agendar Cita',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  );
                } catch (e) {
                  // Fallback cuando no hay AuthProvider disponible
                  return ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Función de agendamiento no disponible en modo de prueba'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC3545),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Agendar Cita',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
} 