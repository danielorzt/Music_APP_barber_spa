import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/features/services/models/service_model.dart';
import '../../../core/services/bmspa_api_service.dart';

class ServicesProvider with ChangeNotifier {
  final BMSPAApiService _apiService = BMSPAApiService();
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _error;

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ServicesProvider() {
    // Usar addPostFrameCallback para evitar setState durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchServices();
    });
  }

  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Obtener servicios desde la API real
      final servicesData = await _apiService.getServicios();
      
      // Convertir a ServiceModel
      _services = servicesData.map((serviceData) {
        return ServiceModel(
          id: serviceData['id']?.toString() ?? '0',
          name: serviceData['nombre'] ?? serviceData['name'] ?? 'Servicio',
          description: serviceData['descripcion'] ?? serviceData['description'] ?? '',
          price: double.tryParse(serviceData['precio']?.toString() ?? '0') ?? 0.0,
          duration: int.tryParse(serviceData['duracion']?.toString() ?? '30') ?? 30,
          imagen: serviceData['imagen'] ?? serviceData['image'] ?? 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=400&fit=crop',
        );
      }).toList();
      
      print('✅ ServicesProvider: ${_services.length} servicios cargados desde API');
    } catch (e) {
      _error = e.toString();
      print('❌ ServicesProvider: Error cargando servicios: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 