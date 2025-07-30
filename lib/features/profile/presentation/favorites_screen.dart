import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/user_management_api_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final UserManagementApiService _userService = UserManagementApiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _favorites = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _userService.getUserFavorites();
      if (response['success'] == true) {
        setState(() {
          _favorites = List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      } else {
        setState(() {
          _error = response['error'] ?? 'Error al cargar favoritos';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error de conexión: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(String favoriteId) async {
    try {
      final response = await _userService.removeUserFavorite(favoriteId);
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Eliminado de favoritos')),
        );
        _loadFavorites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'] ?? 'Error al eliminar de favoritos')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _navigateToItem(Map<String, dynamic> favorite) {
    final tipo = favorite['tipo']?.toString().toLowerCase();
    final id = favorite['item_id']?.toString();
    
    if (tipo == 'servicio' && id != null) {
      context.push('/servicios/$id');
    } else if (tipo == 'producto' && id != null) {
      context.push('/productos/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar favoritos',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: TextStyle(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFavorites,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _favorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes favoritos',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agrega servicios y productos a tus favoritos',
                            style: TextStyle(color: Colors.grey[500]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/services'),
                            icon: const Icon(Icons.spa),
                            label: const Text('Explorar servicios'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/products'),
                            icon: const Icon(Icons.shopping_bag),
                            label: const Text('Explorar productos'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = _favorites[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFDC3545).withOpacity(0.1),
                              child: Icon(
                                favorite['tipo'] == 'servicio' ? Icons.spa : Icons.shopping_bag,
                                color: const Color(0xFFDC3545),
                              ),
                            ),
                            title: Text(
                              favorite['nombre'] ?? 'Sin nombre',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  favorite['tipo'] == 'servicio' ? 'Servicio' : 'Producto',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                if (favorite['precio'] != null)
                                  Text(
                                    '\$${favorite['precio']}',
                                    style: const TextStyle(
                                      color: Color(0xFFDC3545),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'view',
                                  child: Row(
                                    children: [
                                      Icon(Icons.visibility),
                                      SizedBox(width: 8),
                                      Text('Ver detalles'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'remove',
                                  child: Row(
                                    children: [
                                      Icon(Icons.favorite_border, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Quitar de favoritos', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'view') {
                                  _navigateToItem(favorite);
                                } else if (value == 'remove') {
                                  _removeFavorite(favorite['id'].toString());
                                }
                              },
                            ),
                            onTap: () => _navigateToItem(favorite),
                          ),
                        );
                      },
                    ),
    );
  }
} 