// lib/features/services/repositories/services_repository.dart
import 'package:dio/dio.dart';
import 'package:music_app/core/api/api_client.dart';
import 'package:music_app/core/config/api_config.dart';
import '../models/service_model.dart';

class ServicesRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ServiceModel>> getAllServices() async {
    print('🔍 Obteniendo servicios desde API...');
    
    try {
      final response = await _apiClient.dio.get(
        ApiConfig.serviciosEndpoint,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> serviciosData = data['data'];
          final servicios = serviciosData.map((json) => ServiceModel.fromJson(json)).toList();
          
          print('✅ Servicios obtenidos exitosamente: ${servicios.length} servicios');
          return servicios;
        } else {
          print('❌ Formato de respuesta inválido');
          return _getMockServices();
        }
      } else {
        print('❌ Error en la respuesta: ${response.statusCode}');
        return _getMockServices();
      }
    } on DioException catch (e) {
      print('❌ Error de conexión: ${e.message}');
      print('📋 Usando datos mock...');
      return _getMockServices();
    } catch (e) {
      print('❌ Error inesperado: $e');
      return _getMockServices();
    }
  }

  // Datos mock como fallback
  List<ServiceModel> _getMockServices() {
    return [
      ServiceModel(
        id: '1',
        name: 'Corte Clásico',
        description: 'Corte de cabello tradicional con acabado profesional',
        price: 25000.0,
        duration: 30,
        imagen: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
      ),
      ServiceModel(
        id: '2',
        name: 'Afeitado Tradicional',
        description: 'Afeitado con navaja y productos premium',
        price: 18000.0,
        duration: 20,
        imagen: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
      ),
      ServiceModel(
        id: '3',
        name: 'Masaje Relajante',
        description: 'Masaje terapéutico para aliviar tensiones',
        price: 45000.0,
        duration: 60,
        imagen: 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=400',
      ),
      ServiceModel(
        id: '4',
        name: 'Tratamiento de Barba',
        description: 'Limpieza, hidratación y modelado de barba',
        price: 22000.0,
        duration: 25,
        imagen: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=400',
      ),
      ServiceModel(
        id: '5',
        name: 'Corte + Afeitado',
        description: 'Combo completo de corte y afeitado tradicional',
        price: 35000.0,
        duration: 45,
        imagen: 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
      ),
    ];
  }
}