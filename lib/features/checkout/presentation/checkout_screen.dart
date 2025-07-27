import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Compra'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Información de entrega
              _buildSection(
                title: '📍 Información de Entrega',
                child: _buildDeliveryForm(),
              ),
              
              const SizedBox(height: 24),
              
              // Método de pago
              _buildSection(
                title: '💳 Método de Pago',
                child: _buildPaymentMethodSection(),
              ),
              
              const SizedBox(height: 24),
              
              // Resumen del pedido
              _buildSection(
                title: '📋 Resumen del Pedido',
                child: _buildOrderSummary(),
              ),
              
              const SizedBox(height: 32),
              
              // Botón de finalizar compra
              _buildFinishButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _direccionController,
          decoration: const InputDecoration(
            labelText: 'Dirección',
            border: OutlineInputBorder(),
          ),
          validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _ciudadController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _codigoPostalController,
                decoration: const InputDecoration(
                  labelText: 'C.P.',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Campo requerido';
                  if (!value!.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      children: [
        // Selección de método de pago
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    const Text('Tarjeta'),
                  ],
                ),
                value: 'tarjeta',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Colors.green[600]),
                    const SizedBox(width: 8),
                    const Text('PayPal'),
                  ],
                ),
                value: 'paypal',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Formulario de tarjeta (solo si tarjeta está seleccionada)
        if (_selectedPaymentMethod == 'tarjeta') ...[
          TextFormField(
            controller: _numeroTarjetaController,
            decoration: const InputDecoration(
              labelText: 'Número de Tarjeta',
              border: OutlineInputBorder(),
              hintText: '1234 5678 9012 3456',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty == true) return 'Campo requerido';
              if (value!.length < 16) return 'Número de tarjeta inválido';
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _nombreTarjetaController,
            decoration: const InputDecoration(
              labelText: 'Nombre en la Tarjeta',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fechaVencimientoController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha Vencimiento',
                    border: OutlineInputBorder(),
                    hintText: 'MM/YY',
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Campo requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty == true) return 'Campo requerido';
                    if (value!.length < 3) return 'CVV inválido';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
        
        // Información de PayPal (solo si PayPal está seleccionado)
        if (_selectedPaymentMethod == 'paypal')
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600]),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Serás redirigido a PayPal para completar tu pago de forma segura.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        _buildSummaryRow('Subtotal:', '\$${_subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow('IVA (16%):', '\$${_tax.toStringAsFixed(2)}'),
        _buildSummaryRow('Envío:', _shipping == 0 ? 'Gratis' : '\$${_shipping.toStringAsFixed(2)}'),
        const Divider(height: 20),
        _buildSummaryRow(
          'Total:',
          '\$${_total.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
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
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: FontWeight.bold,
              color: isTotal ? Theme.of(context).primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _processOrder,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const CircularProgressIndicator(color: Colors.white)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock),
                  const SizedBox(width: 8),
                  Text(
                    'Pagar \$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _processOrder() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Simular procesamiento del pago
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        // Mostrar diálogo de éxito
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 64,
            ),
            title: const Text('¡Pago Exitoso!'),
            content: const Text(
              'Tu orden ha sido procesada correctamente. Recibirás un email con los detalles de tu compra.',
            ),
            actions: [
              ElevatedButton(
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