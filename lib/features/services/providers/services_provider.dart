import 'package:flutter/foundation.dart';
import 'package:music_app/features/services/models/service_model.dart';
import 'package:music_app/features/services/repositories/services_repository.dart';

class ServicesProvider with ChangeNotifier {
  final ServicesRepository _repository = ServicesRepository();
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

    try {
      _services = await _repository.getAllServices();
      print('✅ ServicesProvider: ${_services.length} servicios cargados');
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