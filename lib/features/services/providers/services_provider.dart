import 'package:flutter/foundation.dart';
import 'package:music_app/features/services/models/service_model.dart';

class ServicesProvider with ChangeNotifier {
  List<ServiceModel> _services = [];
  bool _isLoading = false;
  String? _error;

  List<ServiceModel> get services => _services;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ServicesProvider() {
    fetchServices();
  }

  Future<void> fetchServices() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulación de llamada a la API
    await Future.delayed(const Duration(seconds: 1));

    _services = [
      ServiceModel(id: '1', name: 'Corte de Cabello', description: 'Corte moderno para hombre.', price: 25.00, duration: 30),
      ServiceModel(id: '2', name: 'Afeitado Clásico', description: 'Afeitado con navaja y toallas calientes.', price: 20.00, duration: 45),
      ServiceModel(id: '3', name: 'Masaje Relajante', description: 'Masaje de 60 minutos para aliviar el estrés.', price: 50.00, duration: 60),
    ];

    _isLoading = false;
    notifyListeners();
  }
} 