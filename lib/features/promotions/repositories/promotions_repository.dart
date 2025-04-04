// lib/features/promotions/repositories/promotions_repository.dart

import 'package:music_app/core/services/api_service.dart';
import 'package:music_app/features/promotions/models/promotion_model.dart';

class PromotionsRepository {
  final ApiService _apiService;

  PromotionsRepository(this._apiService);

  Future<List<Promotion>> getPromotions() async {
    try {
      final response = await _apiService.get('promotions');
      final List<dynamic> promoData = response['data'];
      return promoData.map((data) => Promotion.fromJson(data)).toList();
    } catch (e) {
      // Si la API falla, devolvemos datos de demostración
      final now = DateTime.now();
      return [
        Promotion(
          id: 1,
          title: '2x1 en Cortes',
          description: 'Trae a un amigo y el segundo corte es gratis',
          discount: 50,
          isPercentage: true,
          startDate: now.subtract(const Duration(days: 7)),
          endDate: now.add(const Duration(days: 30)),
          applicableServiceIds: [1],
          code: 'AMIGO2X1',
        ),
        Promotion(
          id: 2,
          title: 'Descuento en Masajes',
          description: 'Obtén un 20% de descuento en cualquier masaje',
          discount: 20,
          isPercentage: true,
          startDate: now.subtract(const Duration(days: 15)),
          endDate: now.add(const Duration(days: 15)),
          applicableServiceIds: [3],
          code: 'RELAX20',
        ),
        Promotion(
          id: 3,
          title: 'Paquete Completo',
          description: 'Corte + Afeitado + Masaje por solo $600',
          discount: 330,
          isPercentage: false,
          startDate: now.subtract(const Duration(days: 5)),
          endDate: now.add(const Duration(days: 25)),
          applicableServiceIds: [1, 2, 3],
          code: 'COMPLETO600',
        ),
      ];
    }
  }

  Future<Promotion?> getPromotionByCode(String code) async {
    try {
      final response = await _apiService.get('promotions/code/$code');
      return Promotion.fromJson(response['data']);
    } catch (e) {
      // Buscamos en los datos demo si no hay API
      final promotions = await getPromotions();
      return promotions.firstWhere(
            (promo) => promo.code.toLowerCase() == code.toLowerCase(),
        orElse: () => throw Exception('Código promocional no válido'),
      );
    }
  }
}