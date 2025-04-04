// lib/features/services/repositories/services_repository.dart

import 'package:music_app/core/services/api_service.dart';
import 'package:music_app/features/services/models/service_model.dart';

class ServicesRepository {
  final ApiService _apiService;

  ServicesRepository(this._apiService);

  Future<List<Service>> getServices() async {
    try {
      final response = await _apiService.get('services');
      final List<dynamic> servicesData = response['data'];
      return servicesData.map((data) => Service.fromJson(data)).toList();
    } catch (e) {
      // Si la API falla, devolvemos datos de demostración
      return [
        Service(id: 1, name: 'Corte de Cabello', price: 250, icon: 'cut',
            description: 'Corte profesional con acabado de primera'),
        Service(id: 2, name: 'Afeitado Clásico', price: 180, icon: 'face',
            description: 'Afeitado tradicional con navaja y toalla caliente'),
        Service(id: 3, name: 'Masaje Relajante', price: 400, icon: 'spa',
            description: 'Masaje completo de 60 minutos para aliviar tensiones'),
        Service(id: 4, name: 'Tratamiento Facial', price: 350, icon: 'face',
            description: 'Limpieza y tratamiento facial con productos premium'),
      ];
    }
  }

  Future<Service> getServiceById(int id) async {
    try {
      final response = await _apiService.get('services/$id');
      return Service.fromJson(response['data']);
    } catch (e) {
      // Buscamos en los datos demo si no hay API
      final services = await getServices();
      final service = services.firstWhere(
            (service) => service.id == id,
        orElse: () => throw Exception('Servicio no encontrado'),
      );
      return service;
    }
  }
}