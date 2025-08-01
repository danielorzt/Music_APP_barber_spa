import 'package:flutter/material.dart';

class ImageMapper {
  static const Map<String, String> _productImages = {
    // Pomadas
    'pomada': 'assets/Productos/PomadaClasica4oz-BaseAgua+Mediafijación.png',
    'pomada clásica': 'assets/Productos/PomadaClasica4oz-BaseAgua+Mediafijación.png',
    'pomada mate': 'assets/Productos/PomadaMate4oz-AcabadoSatinado+ExtraFijación.png',
    'pomada original': 'assets/Productos/PomadaOriginal4oz-BaseAgua+ExtraFijación.png',
    'pomada base aceite': 'assets/Productos/PomadaBaseAceite4oz-FormulaNoGrasosa+ControlaFrizz.png',
    'pomada negra': 'assets/Productos/PomadaNegra4oz-118ml-OscureceCanas.png',
    
    // Bálsamos
    'bálsamo': 'assets/Productos/BálsamoClásicodeCrecimientodeBarbayBigote5%Minoxidil-2oz-60ml.png', 
    'bálsamo clásico': 'assets/Productos/BálsamoClásicodeCrecimientodeBarbayBigote5%Minoxidil-2oz-60ml.png',
    'bálsamo negro': 'assets/Productos/BálsamoNegroparaBarba2.7oz-Cubrecanas+PigmentoMineral100%Natural.png',
    
    // Ceras
    'cera': 'assets/Productos/CeraHíbridaparaCabelloyBarba4oz-AcabadoNatural+FijaciónMedia.png',
    'cera híbrida': 'assets/Productos/CeraHíbridaparaCabelloyBarba4oz-AcabadoNatural+FijaciónMedia.png',
    'cera de abeja': 'assets/Productos/CeradeAbejaRoyalBarber2oz-Ingredientes100%Naturales.png',
    
    // Geles
    'gel': 'assets/Productos/GelClásicoFortificante6oz-PrevieneCaídadeCabello.png',
    'gel clásico': 'assets/Productos/GelClásicoFortificante6oz-PrevieneCaídadeCabello.png',
    'gel bálsamo': 'assets/Productos/GelBálsamodeCrecimiento2oz-60mlMinoxidil5%+Biotina+Queratina.png',
    'gel pomada': 'assets/Productos/GelPomada4oz-CerasdePomadaenConsistenciaGel+BrilloSutil+FijacionNatural.png',
    
    // Aceites
    'aceite': 'assets/Productos/AceiteparaBarbaBlackJack50ml-Bergamota+Jojoba+Suaviza.png',
    'aceite barba': 'assets/Productos/AceiteparaBarbaBlackJack50ml-Bergamota+Jojoba+Suaviza.png',
    
    // Shampoos
    'shampoo': 'assets/Productos/ShampooEstimulante8oz-230ml-AntiCaída+AlgasMarinas.png',
    'shampoo estimulante': 'assets/Productos/ShampooEstimulante8oz-230ml-AntiCaída+AlgasMarinas.png',
    'shampoo barba': 'assets/Productos/ShampoodeBarba8oz-AceitesEsenciales+Reducepicazónyresequedad.png',
    
    // Jabones
    'jabón': 'assets/Productos/JabóndeCarbónActivado170gr-DetoxyLimpieza.png',
    'jabón carbón': 'assets/Productos/JabóndeCarbónActivado170gr-DetoxyLimpieza.png',
    'jabón afeitar': 'assets/Productos/JabónparaAfeitarconAroma3.53oz-Hidratante+AfeitadoSuave.png',
    
    // Cremas
    'crema': 'assets/Productos/CremadeAfeitar8oz-Protegelapieldelairritaciónyescozor.png',
    'crema afeitar': 'assets/Productos/CremadeAfeitar8oz-Protegelapieldelairritaciónyescozor.png',
    
    // Kits
    'kit': 'assets/Productos/KitCuidadodeBarba.png',
    'kit barba': 'assets/Productos/KitCuidadodeBarba.png',
    'kit afeitado': 'assets/Productos/KitdeAfeitado.png',
    
    // Mascarillas y Tratamientos
    'mascarilla': 'assets/Productos/MascarillaFacialWakeUpRevitalizante2.7oz.png',
    'mascarilla facial': 'assets/Productos/MascarillaFacialWakeUpRevitalizante2.7oz.png',
    'tratamiento': 'assets/Productos/TratamientoAntiEdad2oz-ÁcidoHialurónicoyExtractoPepino.png',
    'exfoliador': 'assets/Productos/ExfoliadorFacialdeCascaradeNuez4oz-LimpiezaNatural.png',
  };

  static const Map<String, String> _serviceImages = {
    // Servicios de Barbería
    'corte': 'assets/Servicios/CorteCabello.jpg',
    'corte cabello': 'assets/Servicios/CorteCabello.jpg',
    'corte de cabello': 'assets/Servicios/CorteCabello.jpg',
    'corte clásico': 'assets/Servicios/CorteCabello.jpg',
    
    // Servicios de Barba
    'barba': 'assets/Servicios/Arreglo&DiseñoBarba.jpg',
    'arreglo barba': 'assets/Servicios/Arreglo&DiseñoBarba.jpg',
    'diseño barba': 'assets/Servicios/Arreglo&DiseñoBarba.jpg',
    'afeitado': 'assets/Servicios/Arreglo&DiseñoBarba.jpg',
    
    // Servicios de Coloración
    'coloración': 'assets/Servicios/Coloracion.jpg',
    'tinte': 'assets/Servicios/Coloracion.jpg',
    'color': 'assets/Servicios/Coloracion.jpg',
    
    // Servicios de Tratamiento Capilar
    'tratamiento': 'assets/Servicios/TratamientoCapilar.jpg',
    'tratamiento capilar': 'assets/Servicios/TratamientoCapilar.jpg',
    
    // Servicios Faciales
    'facial': 'assets/Servicios/LimpiezaFacial.jpg',
    'limpieza facial': 'assets/Servicios/LimpiezaFacial.jpg',
    'rostro hombre': 'assets/Servicios/Rostro Hombre.jpg',
    'rostro mujer': 'assets/Servicios/Rostro Mujer.jpg',
    'microdermoabrasión': 'assets/Servicios/Microdermoabrasion.jpg',
    'hidrodermoabrasión': 'assets/Servicios/Hidradermoabrasion.jpg',
    'hollywood peel': 'assets/Servicios/HollywoodPeel.jpg',
    'radiofrecuencia': 'assets/Servicios/Radiofrecuencia Facial.jpg',
    
    // Servicios de Depilación
    'depilación': 'assets/Servicios/DepilacionDefinitiva.jpg',
    'depilación definitiva': 'assets/Servicios/DepilacionDefinitiva.jpg',
    
    // Servicios de Cejas
    'cejas': 'assets/Servicios/PerfiladoCejas.jpg',
    'perfilado cejas': 'assets/Servicios/PerfiladoCejas.jpg',
    'diseño cejas': 'assets/Servicios/Diseño&Delineado.png',
    
    // Masajes
    'masaje': 'assets/Servicios/MasajeRelajante.jpg',
    'masaje relajante': 'assets/Servicios/MasajeRelajante.jpg',
    'maderoterapia': 'assets/Servicios/Maderoterapia.jpg',
    
    // Tratamientos Corporales
    'criolipólisis': 'assets/Servicios/Criolipolisis.jpg',
    'celulitis': 'assets/Servicios/EliminacionCelulitis.jpg',
    'eliminación celulitis': 'assets/Servicios/EliminacionCelulitis.jpg',
    'tatuajes': 'assets/Servicios/EliminacionTatuajes.jpg',
    'eliminación tatuajes': 'assets/Servicios/EliminacionTatuajes.jpg',
    'glúteos': 'assets/Servicios/LevantamientoGluteos.jpg',
    'levantamiento glúteos': 'assets/Servicios/LevantamientoGluteos.jpg',
    'lipo': 'assets/Servicios/LipoSinCirugia.jpg',
    'liposucción': 'assets/Servicios/LipoSinCirugia.jpg',
    'sculpsure': 'assets/Servicios/Sculpsure.jpg',
    'hifu': 'assets/Servicios/Hifu.jpg',
    'despigmentación': 'assets/Servicios/Despigmentacion.jpg',
    
    // Otros
    'spa': 'assets/Servicios/MasajeRelajante.jpg',
    'relajación': 'assets/Servicios/MasajeRelajante.jpg',
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
    
    // Si no hay coincidencia, usar imagen por defecto de Unsplash
    return null;
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
    
    // Si no hay coincidencia, usar imagen por defecto de Unsplash
    return null;
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

  /// Lista de imágenes de Unsplash relacionadas con barbería para productos
  static const List<String> _barberProductImages = [
    'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=300&fit=crop&auto=format&q=80', // Productos de barbería
    'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=300&h=300&fit=crop&auto=format&q=80', // Shampoo y jabones
    'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=300&h=300&fit=crop&auto=format&q=80', // Aceites y bálsamos
    'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=300&h=300&fit=crop&auto=format&q=80', // Cremas y tratamientos
    'https://images.unsplash.com/photo-1612817159949-195b6eb9e31a?w=300&h=300&fit=crop&auto=format&q=80', // Productos de cuidado
    'https://images.unsplash.com/photo-1580618672591-eb180b1a973f?w=300&h=300&fit=crop&auto=format&q=80', // Barbería vintage
    'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=300&fit=crop&auto=format&q=80', // Herramientas de barbería
    'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=300&h=300&fit=crop&auto=format&q=80', // Barba y afeitado
    'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=300&h=300&fit=crop&auto=format&q=80', // Barbería moderna
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop&auto=format&q=80', // Productos de estilo
    'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&h=300&fit=crop&auto=format&q=80', // Cuidado facial
    'https://images.unsplash.com/photo-1559599238-1c0d892d8e0b?w=300&h=300&fit=crop&auto=format&q=80', // Tratamientos
    'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=300&h=300&fit=crop&auto=format&q=80', // Cuidado de la piel
    'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=300&h=300&fit=crop&auto=format&q=80', // Spa y relajación
    'https://images.unsplash.com/photo-1580618864189-5c0b0c0c0c0c?w=300&h=300&fit=crop&auto=format&q=80', // Barbería clásica
  ];

  /// Obtiene URL de imagen de Unsplash basada en el nombre y el índice del producto
  static String getUnsplashImage(String name, {bool isService = false, int? productIndex}) {
    final cleanName = name.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z\s]'), '').trim();
    
    if (isService) {
      // URLs específicas para servicios
      if (cleanName.contains('corte') || cleanName.contains('cabello')) {
        return 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('barba') || cleanName.contains('afeitado')) {
        return 'https://images.unsplash.com/photo-1621605815971-fbc98d665033?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('facial') || cleanName.contains('rostro')) {
        return 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('masaje')) {
        return 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('cejas')) {
        return 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('depilación')) {
        return 'https://images.unsplash.com/photo-1559599238-1c0d892d8e0b?w=300&h=300&fit=crop&auto=format&q=80';
      } else {
        return 'https://images.unsplash.com/photo-1562322140-8baeececf3df?w=300&h=300&fit=crop&auto=format&q=80';
      }
    } else {
      // Para productos, usar índice dinámico si está disponible
      if (productIndex != null && productIndex < _barberProductImages.length) {
        return _barberProductImages[productIndex];
      }
      
      // Fallback a lógica específica por nombre
      if (cleanName.contains('pomada') || cleanName.contains('cera')) {
        return 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('shampoo') || cleanName.contains('jabón')) {
        return 'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('aceite') || cleanName.contains('bálsamo')) {
        return 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=300&h=300&fit=crop&auto=format&q=80';
      } else if (cleanName.contains('crema') || cleanName.contains('tratamiento')) {
        return 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273?w=300&h=300&fit=crop&auto=format&q=80';
      } else {
        // Usar índice basado en el hash del nombre para distribución uniforme
        final hash = name.hashCode.abs();
        final index = hash % _barberProductImages.length;
        return _barberProductImages[index];
      }
    }
  }

  /// Widget builder que maneja tanto imágenes locales como de red
  static Widget buildImageWidget(
    String? networkUrl,
    String itemName, 
    bool isService, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    int? productIndex,
  }) {
    // Primero intentar imagen local
    final localImage = isService ? getServiceImage(itemName) : getProductImage(itemName);
    
    Widget imageWidget;
    
    if (localImage != null) {
      imageWidget = Image.asset(
        localImage,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
                  // Si la imagen local falla, usar Unsplash
        return Image.network(
          getUnsplashImage(itemName, isService: isService, productIndex: productIndex),
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(width, height, isService);
          },
        );
        },
      );
    } else if (networkUrl != null && networkUrl.isNotEmpty) {
      // Si no hay imagen local, intentar imagen de red
      imageWidget = Image.network(
        networkUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // Si la imagen de red falla, usar Unsplash
          return Image.network(
            getUnsplashImage(itemName, isService: isService, productIndex: productIndex),
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder(width, height, isService);
            },
          );
        },
      );
    } else {
      // Como último recurso, usar imagen de Unsplash
      imageWidget = Image.network(
        getUnsplashImage(itemName, isService: isService, productIndex: productIndex),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(width, height, isService);
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
  static Widget _buildPlaceholder(double? width, double? height, bool isService) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isService ? Icons.spa : Icons.shopping_bag,
        color: Colors.grey[600],
        size: (width ?? 100) * 0.3,
      ),
    );
  }
} 