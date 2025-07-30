import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/user_management_api_service.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final UserManagementApiService _userService = UserManagementApiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _addresses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _userService.getUserAddresses();
      if (response['success'] == true) {
        setState(() {
          _addresses = List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      } else {
        setState(() {
          _error = response['error'] ?? 'Error al cargar direcciones';
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

  Future<void> _addAddress() async {
    final result = await _showAddressDialog();
    if (result != null) {
      try {
        final response = await _userService.addUserAddress(result);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dirección agregada exitosamente')),
          );
          _loadAddresses();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Error al agregar dirección')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editAddress(Map<String, dynamic> address) async {
    final result = await _showAddressDialog(address: address);
    if (result != null) {
      try {
        final response = await _userService.updateUserAddress(address['id'].toString(), result);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dirección actualizada exitosamente')),
          );
          _loadAddresses();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Error al actualizar dirección')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar dirección'),
        content: const Text('¿Estás seguro de que quieres eliminar esta dirección?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final response = await _userService.deleteUserAddress(addressId);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dirección eliminada exitosamente')),
          );
          _loadAddresses();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Error al eliminar dirección')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<Map<String, String>?> _showAddressDialog({Map<String, dynamic>? address}) async {
    final nameController = TextEditingController(text: address?['nombre'] ?? '');
    final streetController = TextEditingController(text: address?['calle'] ?? '');
    final cityController = TextEditingController(text: address?['ciudad'] ?? '');
    final stateController = TextEditingController(text: address?['estado'] ?? '');
    final zipController = TextEditingController(text: address?['codigo_postal'] ?? '');
    final phoneController = TextEditingController(text: address?['telefono'] ?? '');

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(address == null ? 'Agregar dirección' : 'Editar dirección'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la dirección',
                  hintText: 'Ej: Casa, Trabajo',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Calle y número',
                  hintText: 'Ej: Av. Principal 123',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  hintText: 'Ej: Ciudad de México',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  hintText: 'Ej: CDMX',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: zipController,
                decoration: const InputDecoration(
                  labelText: 'Código Postal',
                  hintText: 'Ej: 12345',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Ej: 555-123-4567',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && streetController.text.isNotEmpty) {
                Navigator.of(context).pop({
                  'nombre': nameController.text,
                  'calle': streetController.text,
                  'ciudad': cityController.text,
                  'estado': stateController.text,
                  'codigo_postal': zipController.text,
                  'telefono': phoneController.text,
                });
              }
            },
            child: Text(address == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Direcciones'),
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
                        'Error al cargar direcciones',
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
                        onPressed: _loadAddresses,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _addresses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes direcciones guardadas',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agrega una dirección para facilitar tus pedidos',
                            style: TextStyle(color: Colors.grey[500]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _addAddress,
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar dirección'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _addresses.length,
                      itemBuilder: (context, index) {
                        final address = _addresses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(Icons.location_on, color: Color(0xFFDC3545)),
                            title: Text(
                              address['nombre'] ?? 'Dirección',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(address['calle'] ?? ''),
                                if (address['ciudad'] != null) Text('${address['ciudad']}, ${address['estado'] ?? ''}'),
                                if (address['codigo_postal'] != null) Text('CP: ${address['codigo_postal']}'),
                                if (address['telefono'] != null) Text('Tel: ${address['telefono']}'),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 8),
                                      Text('Editar'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Eliminar', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editAddress(address);
                                } else if (value == 'delete') {
                                  _deleteAddress(address['id'].toString());
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: _addresses.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addAddress,
              backgroundColor: const Color(0xFFDC3545),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
} 