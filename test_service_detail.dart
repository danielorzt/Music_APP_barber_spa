import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/services/presentation/service_detail_screen.dart';
import 'package:music_app/features/services/models/service_model.dart';
import 'package:music_app/features/auth/providers/auth_provider.dart';

void main() {
  runApp(const TestServiceDetailApp());
}

class TestServiceDetailApp extends StatelessWidget {
  const TestServiceDetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Service Detail',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const TestServiceDetailScreen(),
    );
  }
}

class TestServiceDetailScreen extends StatelessWidget {
  const TestServiceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Crear un servicio mock para pruebas
    final testService = ServiceModel(
      id: '1',
      name: 'Corte de Cabello Profesional',
      description: 'Un excelente servicio de corte de cabello profesional con atención personalizada. Incluye lavado, corte y peinado con productos de la más alta calidad.',
      price: 25.0,
      duration: 45,
      imagen: null,
    );

    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: ServiceDetailScreen(service: testService),
    );
  }
} 