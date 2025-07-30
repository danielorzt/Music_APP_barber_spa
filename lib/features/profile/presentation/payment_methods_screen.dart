import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/services/user_management_api_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final UserManagementApiService _userService = UserManagementApiService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _paymentMethods = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _userService.getUserPaymentMethods();
      if (response['success'] == true) {
        setState(() {
          _paymentMethods = List<Map<String, dynamic>>.from(response['data'] ?? []);
        });
      } else {
        setState(() {
          _error = response['error'] ?? 'Error al cargar métodos de pago';
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

  Future<void> _addPaymentMethod() async {
    final result = await _showPaymentMethodDialog();
    if (result != null) {
      try {
        final response = await _userService.addUserPaymentMethod(result);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Método de pago agregado exitosamente')),
          );
          _loadPaymentMethods();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Error al agregar método de pago')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editPaymentMethod(Map<String, dynamic> paymentMethod) async {
    final result = await _showPaymentMethodDialog(paymentMethod: paymentMethod);
    if (result != null) {
      try {
        final response = await _userService.updateUserPaymentMethod(
          paymentMethod['id'].toString(), 
          result
        );
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Método de pago actualizado exitosamente')),
          );
          _loadPaymentMethods();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Error al actualizar método de pago')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deletePaymentMethod(String paymentMethodId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar método de pago'),
        content: const Text('¿Estás seguro de que quieres eliminar este método de pago?'),
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
        final response = await _userService.deleteUserPaymentMethod(paymentMethodId);
        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Método de pago eliminado exitosamente')),
          );
          _loadPaymentMethods();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'] ?? 'Error al eliminar método de pago')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<Map<String, String>?> _showPaymentMethodDialog({Map<String, dynamic>? paymentMethod}) async {
    final typeController = TextEditingController(text: paymentMethod?['tipo'] ?? '');
    final numberController = TextEditingController(text: paymentMethod?['numero'] ?? '');
    final holderController = TextEditingController(text: paymentMethod?['titular'] ?? '');
    final expiryController = TextEditingController(text: paymentMethod?['vencimiento'] ?? '');

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(paymentMethod == null ? 'Agregar método de pago' : 'Editar método de pago'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: typeController.text.isNotEmpty ? typeController.text : null,
                decoration: const InputDecoration(
                  labelText: 'Tipo de tarjeta',
                  hintText: 'Selecciona el tipo',
                ),
                items: const [
                  DropdownMenuItem(value: 'visa', child: Text('Visa')),
                  DropdownMenuItem(value: 'mastercard', child: Text('Mastercard')),
                  DropdownMenuItem(value: 'amex', child: Text('American Express')),
                  DropdownMenuItem(value: 'discover', child: Text('Discover')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    typeController.text = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: holderController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del titular',
                  hintText: 'Juan Pérez',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: expiryController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de vencimiento',
                  hintText: 'MM/YY',
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
              if (typeController.text.isNotEmpty && 
                  numberController.text.isNotEmpty && 
                  holderController.text.isNotEmpty) {
                Navigator.of(context).pop({
                  'tipo': typeController.text,
                  'numero': numberController.text,
                  'titular': holderController.text,
                  'vencimiento': expiryController.text,
                });
              }
            },
            child: Text(paymentMethod == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  IconData _getCardIcon(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      case 'discover':
        return Icons.credit_card;
      default:
        return Icons.credit_card;
    }
  }

  Color _getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return Colors.blue;
      case 'mastercard':
        return Colors.orange;
      case 'amex':
        return Colors.green;
      case 'discover':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _maskCardNumber(String number) {
    if (number.length <= 4) return number;
    return '**** **** **** ${number.substring(number.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Métodos de Pago'),
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
                        'Error al cargar métodos de pago',
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
                        onPressed: _loadPaymentMethods,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _paymentMethods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No tienes métodos de pago guardados',
                            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Agrega un método de pago para facilitar tus compras',
                            style: TextStyle(color: Colors.grey[500]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _addPaymentMethod,
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar método de pago'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _paymentMethods.length,
                      itemBuilder: (context, index) {
                        final paymentMethod = _paymentMethods[index];
                        final cardType = paymentMethod['tipo']?.toString() ?? '';
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getCardColor(cardType).withOpacity(0.1),
                              child: Icon(
                                _getCardIcon(cardType),
                                color: _getCardColor(cardType),
                              ),
                            ),
                            title: Text(
                              paymentMethod['titular'] ?? 'Sin nombre',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _maskCardNumber(paymentMethod['numero'] ?? ''),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (paymentMethod['vencimiento'] != null)
                                  Text(
                                    'Vence: ${paymentMethod['vencimiento']}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
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
                                  _editPaymentMethod(paymentMethod);
                                } else if (value == 'delete') {
                                  _deletePaymentMethod(paymentMethod['id'].toString());
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: _paymentMethods.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addPaymentMethod,
              backgroundColor: const Color(0xFFDC3545),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
} 