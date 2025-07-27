import 'package:flutter/material.dart';
import 'package:music_app/core/widgets/simple_carousel.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  // Datos de ejemplo
  final Map<String, dynamic> service = {
    'name': 'Tratamiento Hifu',
    'price': 3500.00,
    'duration': '60 min',
    'description':
        'Lifting facial no invasivo que utiliza ultrasonido focalizado de alta intensidad para tensar y rejuvenecer la piel desde las capas más profundas. Resultados visibles desde la primera sesión.',
    'images': [
      'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?q=80&w=1974&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1599387823531-b44c6a6f8737?q=80&w=1974&auto=format&fit=crop',
      'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2120&auto=format&fit=crop'
    ],
    'reviews': [
      {'user': 'Mariana L.', 'rating': 5, 'comment': '¡Increíble! Mi piel se ve mucho más joven. Lo recomiendo totalmente.'},
      {'user': 'Javier R.', 'rating': 5, 'comment': 'El personal fue muy profesional y los resultados superaron mis expectativas.'},
    ]
  };

  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service['name']),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageSlider(),
            _buildServiceInfo(),
            _buildReviewsSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookAppointmentBar(),
    );
  }

  Widget _buildImageSlider() {
    final List<String> images = service['images'];
    return Column(
      children: [
        SimpleCarousel(
          height: 300,
          autoPlay: false,
          viewportFraction: 1.0,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          items: images.map((url) => Image.network(url, fit: BoxFit.cover)).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => setState(() => _currentImageIndex = entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                      .withOpacity(_currentImageIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service['name'],
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '\$${service['price'].toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.timer_outlined, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                service['duration'],
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Descripción',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            service['description'],
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final List<Map<String, dynamic>> reviews = service['reviews'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opiniones de Clientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...reviews.map((review) => _buildReviewItem(review)).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(review['user'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                ...List.generate(5, (index) => Icon(
                  index < review['rating'] ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                )),
              ],
            ),
            const SizedBox(height: 8),
            Text(review['comment']),
          ],
        ),
      ),
    );
  }

  Widget _buildBookAppointmentBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.go('/citas/agendar');
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('Agendar Cita'),
      ),
    );
  }
} 