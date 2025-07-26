// lib/features/services/repositories/services_repository.dart
// import '../../../core/services/api_service.dart';
import '../models/service_model.dart';

class ServicesRepository {
  // final ApiService _apiService = ApiService();

  Future<List<Service>> getAllServices() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Datos mock para servicios
    return [
      Service(
        id: 1,
        nombre: 'Corte Clásico',
        descripcion: 'Corte de cabello tradicional con acabado profesional',
        precio: 25000.0,
        duracion: 30,
        imagen: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
        usuarioId: 1,
      ),
      Service(
        id: 2,
        nombre: 'Afeitado Tradicional',
        descripcion: 'Afeitado con navaja y productos premium',
        precio: 18000.0,
        duracion: 20,
        imagen: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
        usuarioId: 1,
      ),
      Service(
        id: 3,
        nombre: 'Masaje Relajante',
        descripcion: 'Masaje terapéutico para aliviar tensiones',
        precio: 45000.0,
        duracion: 60,
        imagen: 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=400',
        usuarioId: 1,
      ),
      Service(
        id: 4,
        nombre: 'Tratamiento de Barba',
        descripcion: 'Limpieza, hidratación y modelado de barba',
        precio: 22000.0,
        duracion: 25,
        imagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
        usuarioId: 1,
      ),
      Service(
        id: 5,
        nombre: 'Corte + Afeitado',
        descripcion: 'Combo completo de corte y afeitado tradicional',
        precio: 35000.0,
        duracion: 45,
        imagen: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
        usuarioId: 1,
      ),
      Service(
        id: 6,
        nombre: 'Masaje Descontracturante',
        descripcion: 'Masaje especializado para aliviar contracturas',
        precio: 55000.0,
        duracion: 90,
        imagen: 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=400',
        usuarioId: 1,
      ),
    ];
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.get('/services');
    //   return (response as List).map((json) => Service.fromJson(json)).toList();
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<Service> getServiceById(int id) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Buscar en los datos mock
    final services = await getAllServices();
    final service = services.firstWhere(
      (s) => s.id == id,
      orElse: () => throw Exception('Servicio no encontrado'),
    );
    
    return service;
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.get('/services/$id');
    //   return Service.fromJson(response);
    // } catch (e) {
    //   rethrow;
    // }
  }
}