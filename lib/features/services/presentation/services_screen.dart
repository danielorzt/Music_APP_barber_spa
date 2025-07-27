import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'Todos';
  final List<String> _categories = ['Todos', 'Cortes', 'Barba', 'Spa', 'Tratamientos'];

  final List<Map<String, dynamic>> _services = [
    {
      'id': '1',
      'name': 'Corte Clásico',
      'description': 'Corte tradicional con estilo y precisión',
      'price': 25.0,
      'duration': '30 min',
      'category': 'Cortes',
      'image': 'https://picsum.photos/400/300?random=10',
      'popular': true,
    },
    {
      'id': '2',
      'name': 'Afeitado Tradicional',
      'description': 'Afeitado con navaja y toallas calientes',
      'price': 20.0,
      'duration': '20 min',
      'category': 'Barba',
      'image': 'https://picsum.photos/400/300?random=11',
      'popular': false,
    },
    {
      'id': '3',
      'name': 'Masaje Relajante',
      'description': 'Masaje de 60 minutos para aliviar el estrés',
      'price': 50.0,
      'duration': '60 min',
      'category': 'Spa',
      'image': 'https://picsum.photos/400/300?random=12',
      'popular': true,
    },
    {
      'id': '4',
      'name': 'Corte + Barba',
      'description': 'Paquete completo de corte y arreglo de barba',
      'price': 40.0,
      'duration': '45 min',
      'category': 'Cortes',
      'image': 'https://picsum.photos/400/300?random=13',
      'popular': true,
    },
    {
      'id': '5',
      'name': 'Tratamiento Facial',
      'description': 'Limpieza facial profunda con hidratación',
      'price': 60.0,
      'duration': '90 min',
      'category': 'Tratamientos',
      'image': 'https://picsum.photos/400/300?random=14',
      'popular': false,
    },
    {
      'id': '6',
      'name': 'Corte Moderno',
      'description': 'Corte con estilo actual y acabado profesional',
      'price': 35.0,
      'duration': '40 min',
      'category': 'Cortes',
      'image': 'https://picsum.photos/400/300?random=15',
      'popular': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredServices {
    if (_selectedCategory == 'Todos') {
      return _services;
    }
    return _services.where((service) => service['category'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonInterceptor(
      fallbackRoute: '/home',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nuestros Servicios'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Usar push para mantener la pila de navegación
              context.go('/home');
            },
          ),
        ),
        body: Column(
          children: [
            // Filtros de categoría
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Lista de servicios
            Expanded(
              child: _filteredServices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.spa_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay servicios en esta categoría',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredServices.length,
                      itemBuilder: (context, index) {
                        final service = _filteredServices[index];
                        return _buildServiceCard(service);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Usar push para mantener la pila de navegación
          context.push('/servicios/${service['id']}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del servicio
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    service['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.spa,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      );
                    },
                  ),
                ),
                
                // Badge de popular
                if (service['popular'] == true)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Popular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Información del servicio
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service['category'],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    service['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        service['duration'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$${service['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/citas/agendar');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Agendar Cita',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}