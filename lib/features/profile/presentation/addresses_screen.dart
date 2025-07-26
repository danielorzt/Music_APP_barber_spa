import 'package:flutter/material.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': 1,
      'name': 'Casa',
      'fullName': 'Juan Pérez',
      'phone': '+57 300 123 4567',
      'address': 'Calle 123 #45-67',
      'city': 'Bogotá',
      'state': 'Cundinamarca',
      'zipCode': '110111',
      'isDefault': true,
    },
    {
      'id': 2,
      'name': 'Oficina',
      'fullName': 'Juan Pérez',
      'phone': '+57 300 123 4567',
      'address': 'Carrera 15 #93-47',
      'city': 'Bogotá',
      'state': 'Cundinamarca',
      'zipCode': '110221',
      'isDefault': false,
    },
    {
      'id': 3,
      'name': 'Apartamento',
      'fullName': 'Juan Pérez',
      'phone': '+57 300 123 4567',
      'address': 'Avenida 68 #24-15',
      'city': 'Bogotá',
      'state': 'Cundinamarca',
      'zipCode': '110231',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Direcciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddAddressDialog();
            },
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                return _buildAddressCard(_addresses[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes direcciones guardadas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega una dirección para recibir tus pedidos',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showAddAddressDialog();
            },
            icon: const Icon(Icons.add),
            label: const Text('Agregar Dirección'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(Map<String, dynamic> address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address['isDefault'] 
              ? Theme.of(context).primaryColor 
              : Colors.grey.shade200,
          width: address['isDefault'] ? 2 : 1,
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: address['isDefault'] 
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    address['name'],
                    style: TextStyle(
                      color: address['isDefault'] 
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (address['isDefault']) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Predeterminada',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    _handleAddressAction(value, address);
                  },
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
                    if (!address['isDefault'])
                      const PopupMenuItem(
                        value: 'set_default',
                        child: Row(
                          children: [
                            Icon(Icons.star),
                            SizedBox(width: 8),
                            Text('Establecer como predeterminada'),
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
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address['fullName'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              address['phone'],
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              address['address'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${address['city']}, ${address['state']} ${address['zipCode']}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddressAction(String action, Map<String, dynamic> address) {
    switch (action) {
      case 'edit':
        _showEditAddressDialog(address);
        break;
      case 'set_default':
        _setDefaultAddress(address['id']);
        break;
      case 'delete':
        _showDeleteConfirmation(address);
        break;
    }
  }

  void _setDefaultAddress(int addressId) {
    setState(() {
      for (var address in _addresses) {
        address['isDefault'] = address['id'] == addressId;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dirección predeterminada actualizada')),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Dirección'),
        content: Text(
          '¿Estás seguro de que quieres eliminar la dirección "${address['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _addresses.removeWhere((a) => a['id'] == address['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dirección eliminada')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog() {
    _showAddressFormDialog();
  }

  void _showEditAddressDialog(Map<String, dynamic> address) {
    _showAddressFormDialog(address: address);
  }

  void _showAddressFormDialog({Map<String, dynamic>? address}) {
    final isEditing = address != null;
    final nameController = TextEditingController(text: address?['name'] ?? '');
    final fullNameController = TextEditingController(text: address?['fullName'] ?? '');
    final phoneController = TextEditingController(text: address?['phone'] ?? '');
    final addressController = TextEditingController(text: address?['address'] ?? '');
    final cityController = TextEditingController(text: address?['city'] ?? '');
    final stateController = TextEditingController(text: address?['state'] ?? '');
    final zipCodeController = TextEditingController(text: address?['zipCode'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Dirección' : 'Agregar Dirección'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la dirección',
                  hintText: 'Ej: Casa, Oficina',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: const InputDecoration(
                        labelText: 'Departamento',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: zipCodeController,
                decoration: const InputDecoration(
                  labelText: 'Código Postal',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Validar campos
              if (isEditing) {
                // Actualizar dirección existente
                final index = _addresses.indexWhere((a) => a['id'] == address['id']);
                if (index != -1) {
                  setState(() {
                    _addresses[index] = {
                      ..._addresses[index],
                      'name': nameController.text,
                      'fullName': fullNameController.text,
                      'phone': phoneController.text,
                      'address': addressController.text,
                      'city': cityController.text,
                      'state': stateController.text,
                      'zipCode': zipCodeController.text,
                    };
                  });
                }
              } else {
                // Agregar nueva dirección
                setState(() {
                  _addresses.add({
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'name': nameController.text,
                    'fullName': fullNameController.text,
                    'phone': phoneController.text,
                    'address': addressController.text,
                    'city': cityController.text,
                    'state': stateController.text,
                    'zipCode': zipCodeController.text,
                    'isDefault': _addresses.isEmpty,
                  });
                });
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isEditing ? 'Dirección actualizada' : 'Dirección agregada'),
                ),
              );
            },
            child: Text(isEditing ? 'Actualizar' : 'Agregar'),
          ),
        ],
      ),
    );
  }
} 