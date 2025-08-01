import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:music_app/core/models/servicio.dart';
import 'package:music_app/core/services/unified_catalog_service.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/core/utils/image_mapper.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UnifiedCatalogService _catalogService = UnifiedCatalogService();
  
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  bool _isLoading = true;
  List<Servicio> _servicios = [];
  String? _error;
  
  // Categorías disponibles
  final List<String> _categories = [
    'Todos',
    'Cortes',
    'Barba',
    'Tratamientos',
    'Spa',
    'Masajes',
    'Facial',
    'Depilación',
  ];

  @override
  void initState() {
    super.initState();
    _loadServicios();
  }

  Future<void> _loadServicios() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final servicios = await _catalogService.getServicios();
      setState(() {
        _servicios = servicios;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Servicio> get _filteredServices {
    return _servicios.where((service) {
      final matchesSearch = service.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           service.descripcion.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Filtrar por categoría si no es "Todos"
      if (_selectedCategory != 'Todos') {
        final categoryMatches = _getServiceCategory(service).toLowerCase() == _selectedCategory.toLowerCase();
        return matchesSearch && categoryMatches;
      }
      
      return matchesSearch;
    }).toList();
  }

  String _getServiceCategory(Servicio servicio) {
    final nombre = servicio.nombre.toLowerCase();
    final descripcion = servicio.descripcion.toLowerCase();
    
    if (nombre.contains('corte') || nombre.contains('cabello') || descripcion.contains('corte')) {
      return 'Cortes';
    } else if (nombre.contains('barba') || descripcion.contains('barba')) {
      return 'Barba';
    } else if (nombre.contains('tratamiento') || descripcion.contains('tratamiento')) {
      return 'Tratamientos';
    } else if (nombre.contains('spa') || descripcion.contains('spa')) {
      return 'Spa';
    } else if (nombre.contains('masaje') || descripcion.contains('masaje')) {
      return 'Masajes';
    } else if (nombre.contains('facial') || descripcion.contains('facial')) {
      return 'Facial';
    } else if (nombre.contains('depilación') || nombre.contains('depilacion') || descripcion.contains('depilación')) {
      return 'Depilación';
    }
    
    return 'Otros';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              context.push('/agendar');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
            )
          : _error != null
              ? _buildErrorView()
              : _buildServicesView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar servicios',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadServicios,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4AA),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesView() {
    return Column(
      children: [
        // Barra de búsqueda
        Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar servicios...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // Filtros de categoría
        Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: const Color(0xFF00D4AA),
                  checkmarkColor: Colors.white,
                  elevation: isSelected ? 4 : 1,
                  pressElevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            },
          ),
        ),

        // Contador de servicios
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                '${_filteredServices.length} servicios encontrados',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Lista de servicios
        Expanded(
          child: _filteredServices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.content_cut_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No se encontraron servicios',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Intenta con otros filtros o términos de búsqueda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadServicios,
                  color: const Color(0xFF00D4AA),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredServices.length,
                    itemBuilder: (context, index) {
                      final servicio = _filteredServices[index];
                      return _buildServiceCard(servicio);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Servicio servicio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            context.push('/servicios/${servicio.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Imagen del servicio
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00D4AA).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ImageMapper.buildImageWidget(
                      null, // No network image for now
                      servicio.nombre,
                      true, // isService = true
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Información del servicio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        servicio.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        servicio.descripcion,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00D4AA), Color(0xFF00B894)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '\$${servicio.precio.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              '${servicio.duracionEnMinutos} min',
                              style: const TextStyle(
                                color: Color(0xFF616161),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Botón de agendar cita
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/agendar?servicio_id=${servicio.id}&servicio_nombre=${Uri.encodeComponent(servicio.nombre)}&servicio_precio=${servicio.precio}');
                    },
                    icon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Agendar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC3545),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}