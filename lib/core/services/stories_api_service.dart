import 'dart:convert';
import 'package:http/http.dart' as http;

class StoriesApiService {
  // Para videos, usaremos datos mock ya que las APIs de video son complejas
  // En producción, esto se conectaría a tu backend o a una API de videos
  
  Future<Map<String, dynamic>> getStories() async {
    // Simulamos una llamada API con delay
    await Future.delayed(const Duration(seconds: 1));
    
    return {
      'success': true,
      'data': [
        {
          'id': '1',
          'title': 'Transformación Completa',
          'thumbnail': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_1mb.mp4',
          'duration': '0:30',
          'likes': 1250,
          'views': 15600,
          'author': 'Barber Pro Studio',
          'description': 'Increíble transformación de corte clásico a moderno',
        },
        {
          'id': '2',
          'title': 'Corte Degradado Perfecto',
          'thumbnail': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_2mb.mp4',
          'duration': '0:45',
          'likes': 2100,
          'views': 28900,
          'author': 'Style Masters',
          'description': 'Técnica profesional de degradado paso a paso',
        },
        {
          'id': '3',
          'title': 'Tratamiento Facial Relajante',
          'thumbnail': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_1mb.mp4',
          'duration': '1:20',
          'likes': 890,
          'views': 12400,
          'author': 'Spa Wellness',
          'description': 'Tratamiento completo de hidratación facial',
        },
        {
          'id': '4',
          'title': 'Arreglo de Barba Premium',
          'thumbnail': 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_2mb.mp4',
          'duration': '0:55',
          'likes': 1670,
          'views': 19800,
          'author': 'Gentleman Barber',
          'description': 'Diseño y arreglo profesional de barba',
        },
        {
          'id': '5',
          'title': 'Masaje Terapéutico',
          'thumbnail': 'https://images.unsplash.com/photo-1544161512-4ab64f436453?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_1mb.mp4',
          'duration': '2:10',
          'likes': 3200,
          'views': 45600,
          'author': 'Relax Spa Center',
          'description': 'Técnicas de masaje para relajación profunda',
        },
        {
          'id': '6',
          'title': 'Coloración Profesional',
          'thumbnail': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_2mb.mp4',
          'duration': '1:30',
          'likes': 2890,
          'views': 34200,
          'author': 'Color Studio',
          'description': 'Proceso completo de coloración capilar',
        },
      ]
    };
  }

  Future<Map<String, dynamic>> getTrendingStories() async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return {
      'success': true,
      'data': [
        {
          'id': '7',
          'title': 'Corte Viral del Momento',
          'thumbnail': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_1mb.mp4',
          'duration': '0:25',
          'likes': 5600,
          'views': 89400,
          'author': 'Viral Cuts',
          'description': 'El corte que está rompiendo redes sociales',
          'trending': true,
        },
        {
          'id': '8',
          'title': 'Spa Day Experience',
          'thumbnail': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=300&h=400&fit=crop',
          'video_url': 'https://sample-videos.com/zip/10/mp4/SampleVideo_720x480_2mb.mp4',
          'duration': '3:00',
          'likes': 4200,
          'views': 67800,
          'author': 'Luxury Spa',
          'description': 'Experiencia completa de día de spa',
          'trending': true,
        },
      ]
    };
  }

  Future<Map<String, dynamic>> getStoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allStories = await getStories();
    final trendingStories = await getTrendingStories();
    
    final allStoriesList = [
      ...allStories['data'] as List,
      ...trendingStories['data'] as List,
    ];
    
    final story = allStoriesList.firstWhere(
      (story) => story['id'] == id,
      orElse: () => null,
    );
    
    return {
      'success': story != null,
      'data': story,
    };
  }
}