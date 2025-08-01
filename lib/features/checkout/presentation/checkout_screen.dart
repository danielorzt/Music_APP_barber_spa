import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:music_app/core/widgets/back_button_interceptor.dart';
import 'package:music_app/core/services/notification_service.dart';
import 'package:music_app/core/services/local_history_service.dart';
import 'package:music_app/features/cart/providers/cart_provider.dart';
import 'package:music_app/core/utils/image_mapper.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores de formulario
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Método de pago seleccionado
  String _selectedPaymentMethod = 'tarjeta';
  
  // Datos de tarjeta
  final _numeroTarjetaController = TextEditingController();
  final _nombreTarjetaController = TextEditingController();
  final _fechaVencimientoController = TextEditingController();
  final _cvvController = TextEditingController();
  
  // Datos mock del carrito
  final double _subtotal = 1210.0;
  final double _tax = 193.6;
  final double _shipping = 0.0;
  final double _total = 1403.6;
  
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BackButtonInterceptor(
      fallbackRoute: '/products',
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Finalizar Compra',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => context.go('/products'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeliveryForm(),
                const SizedBox(height: 24),
                _buildPaymentMethodSection(),
                const SizedBox(height: 24),
                _buildCartItemsSection(),
                const SizedBox(height: 24),
                _buildOrderSummary(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildFinishButton(),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          color: theme.cardTheme.color,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryForm() {
    final theme = Theme.of(context);
    
    return _buildSection(
      'Información de Entrega',
      Column(
        children: [
          TextFormField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: 'Nombre completo',
              labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              prefixIcon: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu nombre';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _direccionController,
            decoration: InputDecoration(
              labelText: 'Dirección',
              labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              prefixIcon: Icon(Icons.location_on, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu dirección';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ciudadController,
                  decoration: InputDecoration(
                    labelText: 'Ciudad',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.location_city, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requerido';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _codigoPostalController,
                  decoration: InputDecoration(
                    labelText: 'Código Postal',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requerido';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _telefonoController,
            decoration: InputDecoration(
              labelText: 'Teléfono',
              labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              prefixIcon: Icon(Icons.phone, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu teléfono';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              prefixIcon: Icon(Icons.email, color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu email';
              }
              if (!value.contains('@')) {
                return 'Email inválido';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    final theme = Theme.of(context);
    
    return _buildSection(
      'Método de Pago',
      Column(
        children: [
          RadioListTile<String>(
            title: Row(
              children: [
                const Icon(Icons.credit_card, color: Color(0xFFDC3545)),
                const SizedBox(width: 8),
                Text(
                  'Tarjeta de Crédito/Débito',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
            value: 'tarjeta',
            groupValue: _selectedPaymentMethod,
            activeColor: const Color(0xFFDC3545),
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
            },
          ),

          
          if (_selectedPaymentMethod == 'tarjeta') ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _numeroTarjetaController,
              decoration: InputDecoration(
                labelText: 'Número de tarjeta',
                labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                hintText: '1234 5678 9012 3456',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                prefixIcon: Icon(Icons.credit_card, color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Número de tarjeta requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreTarjetaController,
              decoration: InputDecoration(
                labelText: 'Nombre en la tarjeta',
                labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                prefixIcon: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nombre requerido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _fechaVencimientoController,
                    decoration: InputDecoration(
                      labelText: 'MM/AA',
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      hintText: '12/25',
                      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.calendar_today, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fecha requerida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      hintText: '123',
                      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.lock, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CVV requerido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCartItemsSection() {
    final theme = Theme.of(context);
    
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return _buildSection(
          'Artículos en el Carrito',
          Column(
            children: [
              if (cartProvider.items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Tu carrito está vacío. Por favor, agrega productos para continuar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Imagen del producto usando ImageMapper
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: ImageMapper.buildImageWidget(
                                item.image,
                                item.name,
                                false, // isService = false for products
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                productIndex: index, // Usar el índice para imágenes dinámicas
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Cantidad: ${item.quantity}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    final theme = Theme.of(context);
    
    return _buildSection(
      'Resumen del Pedido',
      Column(
        children: [
          _buildSummaryRow('Subtotal', _subtotal),
          _buildSummaryRow('Impuestos', _tax),
          _buildSummaryRow('Envío', _shipping, showFree: true),
          const Divider(),
          _buildSummaryRow('Total', _total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false, bool showFree = false}) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Row(
            children: [
              if (showFree && amount == 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Gratis',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                '\$${amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: isTotal ? 18 : 16,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isTotal ? const Color(0xFFDC3545) : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFDC3545),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Finalizar Compra - \$${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _processOrder() async {
    // MOCK: No validar formulario, siempre procesar como exitoso
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simular procesamiento del pago
      await Future.delayed(const Duration(seconds: 2));

      // Crear objeto de orden para guardar localmente
      final orderData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'numero_orden': 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        'estado': 'COMPLETADA',
        'subtotal': _subtotal,
        'tax': _tax,
        'shipping': _shipping,
        'total': _total,
        'metodo_pago': _selectedPaymentMethod,
        'direccion_entrega': {
          'nombre': _nombreController.text.isNotEmpty ? _nombreController.text : 'Cliente',
          'direccion': _direccionController.text.isNotEmpty ? _direccionController.text : 'Dirección de entrega',
          'ciudad': _ciudadController.text.isNotEmpty ? _ciudadController.text : 'Ciudad',
          'codigo_postal': _codigoPostalController.text.isNotEmpty ? _codigoPostalController.text : '00000',
          'telefono': _telefonoController.text.isNotEmpty ? _telefonoController.text : 'N/A',
          'email': _emailController.text.isNotEmpty ? _emailController.text : 'cliente@email.com',
        },
        'items': [
          {
            'id': '1',
            'nombre': 'Producto de Barbería',
            'precio': 29.99,
            'cantidad': 2,
            'tipo': 'producto',
          },
          {
            'id': '2',
            'nombre': 'Servicio de Corte',
            'precio': 25.0,
            'cantidad': 1,
            'tipo': 'servicio',
          },
        ],
        'created_at': DateTime.now().toIso8601String(),
      };

      // Guardar orden localmente
      await LocalHistoryService.saveOrder(orderData);

      if (mounted) {
        // Mostrar notificación
        final notificationService = NotificationService();
        await notificationService.showPurchaseNotification();
        
        // Mostrar diálogo de éxito
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  '¡Compra Exitosa!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu pedido ha sido procesado correctamente y aparecerá en tu historial de compras.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                child: const Text('Continuar'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar el pago: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _codigoPostalController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _numeroTarjetaController.dispose();
    _nombreTarjetaController.dispose();
    _fechaVencimientoController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
} 