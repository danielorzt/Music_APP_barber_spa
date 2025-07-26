// lib/features/services/repositories/services_repository.dart
import '../../../core/services/api_service.dart';
import '../models/service_model.dart';

class ServicesRepository {
  final ApiService _apiService = ApiService();

  Future<List<Service>> getAllServices() async {
    try {
      final response = await _apiService.get('/services');
      return (response as List).map((json) => Service.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Service> getServiceById(int id) async {
    try {
      final response = await _apiService.get('/services/$id');
      return Service.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}