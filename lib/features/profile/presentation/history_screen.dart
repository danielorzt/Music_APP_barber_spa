import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Citas'),
            Tab(text: 'Compras'),
            Tab(text: 'Servicios'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsHistory(),
          _buildPurchasesHistory(),
          _buildServicesHistory(),
        ],
      ),
    );
  }

  Widget _buildAppointmentsHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        final appointments = [
          {
            'service': 'Corte Clásico',
            'date': '15 Dic 2024',
            'time': '14:30',
            'status': 'completado',
            'price': 25.0,
            'barber': 'Carlos Rodríguez',
          },
          {
            'service': 'Afeitado Tradicional',
            'date': '10 Dic 2024',
            'time': '16:00',
            'status': 'completado',
            'price': 18.0,
            'barber': 'Miguel Ángel',
          },
          {
            'service': 'Masaje Relajante',
            'date': '5 Dic 2024',
            'time': '11:00',
            'status': 'completado',
            'price': 45.0,
            'barber': 'Ana María',
          },
          {
            'service': 'Tratamiento de Barba',
            'date': '1 Dic 2024',
            'time': '13:15',
            'status': 'cancelado',
            'price': 22.0,
            'barber': 'Carlos Rodríguez',
          },
          {
            'service': 'Corte + Afeitado',
            'date': '25 Nov 2024',
            'time': '15:45',
            'status': 'completado',
            'price': 35.0,
            'barber': 'Miguel Ángel',
          },
        ];

        final appointment = appointments[index];
        final isCompleted = appointment['status'] == 'completado';
        final isCancelled = appointment['status'] == 'cancelado';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCancelled ? Colors.red.shade200 : Colors.grey.shade200,
            ),
            color: Colors.white,
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? Colors.green.shade100 
                    : isCancelled 
                        ? Colors.red.shade100 
                        : Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCompleted 
                    ? Icons.check_circle 
                    : isCancelled 
                        ? Icons.cancel 
                        : Icons.schedule,
                color: isCompleted 
                    ? Colors.green 
                    : isCancelled 
                        ? Colors.red 
                        : Colors.blue,
                size: 30,
              ),
            ),
            title: Text(
              appointment['service'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${appointment['date']} - ${appointment['time']}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      appointment['barber'] as String,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted 
                            ? Colors.green.shade100 
                            : isCancelled 
                                ? Colors.red.shade100 
                                : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appointment['status'] as String,
                        style: TextStyle(
                          color: isCompleted 
                              ? Colors.green 
                              : isCancelled 
                                  ? Colors.red 
                                  : Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${appointment['price']}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: isCompleted ? IconButton(
              icon: const Icon(Icons.rate_review),
              onPressed: () {
                // TODO: Abrir pantalla de reseña
              },
            ) : null,
          ),
        );
      },
    );
  }

  Widget _buildPurchasesHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        final purchases = [
          {
            'orderId': 'ORD-001',
            'date': '20 Dic 2024',
            'items': 3,
            'total': 89.50,
            'status': 'entregado',
            'products': ['Aceite para Barba', 'Navaja Profesional', 'Crema de Afeitar'],
          },
          {
            'orderId': 'ORD-002',
            'date': '15 Dic 2024',
            'items': 2,
            'total': 45.00,
            'status': 'en_camino',
            'products': ['Cepillo para Barba', 'Aceite Esencial'],
          },
          {
            'orderId': 'ORD-003',
            'date': '10 Dic 2024',
            'items': 1,
            'total': 25.00,
            'status': 'entregado',
            'products': ['Kit de Afeitado Premium'],
          },
        ];

        final purchase = purchases[index];
        final isDelivered = purchase['status'] == 'entregado';
        final isInTransit = purchase['status'] == 'en_camino';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      purchase['orderId'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDelivered 
                            ? Colors.green.shade100 
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isDelivered ? 'Entregado' : 'En camino',
                        style: TextStyle(
                          color: isDelivered ? Colors.green : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  purchase['date'] as String,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Text(
                  '${purchase['items']} productos',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...(purchase['products'] as List<String>).map((product) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 6, color: Colors.grey.shade400),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            product,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${purchase['total']}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Ver detalles del pedido
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Ver Detalles'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesHistory() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        final services = [
          {
            'service': 'Corte Clásico',
            'date': '15 Dic 2024',
            'duration': '30 min',
            'price': 25.0,
            'rating': 5,
            'review': 'Excelente servicio, muy profesional.',
          },
          {
            'service': 'Afeitado Tradicional',
            'date': '10 Dic 2024',
            'duration': '20 min',
            'price': 18.0,
            'rating': 4,
            'review': 'Buen trabajo, muy satisfecho.',
          },
          {
            'service': 'Masaje Relajante',
            'date': '5 Dic 2024',
            'duration': '60 min',
            'price': 45.0,
            'rating': 5,
            'review': 'Increíble experiencia, muy relajante.',
          },
          {
            'service': 'Tratamiento de Barba',
            'date': '1 Dic 2024',
            'duration': '25 min',
            'price': 22.0,
            'rating': 4,
            'review': 'Buen tratamiento, barba muy suave.',
          },
        ];

        final service = services[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        service['service'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      '\$${service['price']}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      service['date'] as String,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      service['duration'] as String,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (starIndex) => 
                    Icon(
                      starIndex < (service['rating'] as int) 
                          ? Icons.star 
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['review'] as String,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 