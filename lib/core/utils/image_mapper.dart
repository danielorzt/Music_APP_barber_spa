import 'package:flutter/material.dart';

class ImageMapper {
  static const Map<String, String> _productImages = {
    'shampoo': 'assets/services/shampoo.png',
    'conditioner': 'assets/services/conditioner.png',
    'gel': 'assets/services/gel.png',
    'pomada': 'assets/services/pomada.png',
    'cera': 'assets/services/cera.png',
    'aceite': 'assets/services/aceite.png',
    'mascarilla': 'assets/services/mascarilla.png',
    'spray': 'assets/services/spray.png',
    'navaja': 'assets/services/navaja.png',
    'tijeras': 'assets/services/tijeras.png',
    'peine': 'assets/services/peine.png',
    'secador': 'assets/services/secador.png',
    'plancha': 'assets/services/plancha.png',
    'maquina': 'assets/services/maquina.png',
    'toalla': 'assets/services/toalla.png',
    'bata': 'assets/services/bata.png',
    'guantes': 'assets/services/guantes.png',
    'capa': 'assets/services/capa.png',
    'silla': 'assets/services/silla.png',
    'espejo': 'assets/services/espejo.png',
  };

  static const Map<String, String> _serviceImages = {
    'corte': 'assets/services/corte.png',
    'barba': 'assets/services/barba.png',
    'afeitado': 'assets/services/afeitado.png',
    'masaje': 'assets/services/masaje.png',
    'facial': 'assets/services/facial.png',
    'manicure': 'assets/services/manicure.png',
    'pedicure': 'assets/services/pedicure.png',
    'tinte': 'assets/services/tinte.png',
    'peinado': 'assets/services/peinado.png',
    'tratamiento': 'assets/services/tratamiento.png',
    'limpieza': 'assets/services/limpieza.png',
    'hidratacion': 'assets/services/hidratacion.png',
    'exfoliacion': 'assets/services/exfoliacion.png',
    'mascarilla': 'assets/services/mascarilla.png',
    'depilacion': 'assets/services/depilacion.png',
    'cejas': 'assets/services/cejas.png',
    'pestanas': 'assets/services/pestanas.png',
    'maquillaje': 'assets/services/maquillaje.png',
    'spa': 'assets/services/spa.png',
    'relajacion': 'assets/services/relajacion.png',
  };

  /// Mapea el nombre de un producto a una imagen local
  static String? getProductImage(String productName) {
    final normalizedName = _normalizeName(productName);
    
    // Buscar coincidencias exactas
    if (_productImages.containsKey(normalizedName)) {
      return _productImages[normalizedName];
    }
    
    // Buscar coincidencias parciales
    for (final entry in _productImages.entries) {
      if (normalizedName.contains(entry.key) || entry.key.contains(normalizedName)) {
        return entry.value;
      }
    }
    
    // Si no hay coincidencia, usar imagen por defecto
    return 'assets/services/default_product.png';
  }

  /// Mapea el nombre de un servicio a una imagen local
  static String? getServiceImage(String serviceName) {
    final normalizedName = _normalizeName(serviceName);
    
    // Buscar coincidencias exactas
    if (_serviceImages.containsKey(normalizedName)) {
      return _serviceImages[normalizedName];
    }
    
    // Buscar coincidencias parciales
    for (final entry in _serviceImages.entries) {
      if (normalizedName.contains(entry.key) || entry.key.contains(normalizedName)) {
        return entry.value;
      }
    }
    
    // Si no hay coincidencia, usar imagen por defecto
    return 'assets/services/default_service.png';
  }

  /// Normaliza el nombre para búsquedas más flexibles
  static String _normalizeName(String name) {
    return name
        .toLowerCase()
        .replaceAll(RegExp(r'[áäâà]'), 'a')
        .replaceAll(RegExp(r'[éëêè]'), 'e')
        .replaceAll(RegExp(r'[íïîì]'), 'i')
        .replaceAll(RegExp(r'[óöôò]'), 'o')
        .replaceAll(RegExp(r'[úüûù]'), 'u')
        .replaceAll(RegExp(r'[ñ]'), 'n')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim();
  }

  /// Obtiene una imagen de red con fallback a imagen local
  static String getImageWithFallback(String? networkImage, String name, bool isService) {
    if (networkImage != null && networkImage.isNotEmpty) {
      return networkImage;
    }
    
    return isService 
        ? getServiceImage(name) ?? 'assets/services/default_service.png'
        : getProductImage(name) ?? 'assets/services/default_product.png';
  }

  /// Crea un widget de imagen con fallback
  static Widget buildImageWidget(String? networkImage, String name, bool isService, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final imagePath = getImageWithFallback(networkImage, name, isService);
    
    Widget imageWidget;
    
    if (imagePath.startsWith('http')) {
      // Imagen de red
      imageWidget = Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // Fallback a imagen local si la de red falla
          final fallbackPath = isService 
              ? getServiceImage(name) ?? 'assets/services/default_service.png'
              : getProductImage(name) ?? 'assets/services/default_product.png';
          
          return Image.asset(
            fallbackPath,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder(width, height);
            },
          );
        },
      );
    } else {
      // Imagen local
      imageWidget = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(width, height);
        },
      );
    }
    
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }

  /// Crea un placeholder cuando no hay imagen disponible
  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.image,
        color: Colors.grey[600],
        size: (width ?? 100) * 0.3,
      ),
    );
  }
} 