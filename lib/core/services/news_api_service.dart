import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '156d06374aec42d7b3a6331b76d17a03'; // Tu API key real
  
  // Método getNews - alias para getBarberSpaNews
  Future<Map<String, dynamic>> getNews() async {
    return await getBarberSpaNews();
  }
  
  // Método getFeaturedNews - alias para getTopNews
  Future<Map<String, dynamic>> getFeaturedNews() async {
    return await getTopNews();
  }
  
  Future<Map<String, dynamic>> getBarberSpaNews() async {
    try {
      // Búsqueda específica para spa, barbería y salones de belleza
      final query = 'spa OR barber OR "beauty salon" OR "hair salon" OR barbershop OR "beauty industry" OR grooming OR "hair care" OR "skin care" OR wellness OR massage OR "beauty treatment"';
      
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&sortBy=publishedAt&language=en&pageSize=20&apiKey=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Filtrar artículos que realmente sean relevantes
        if (data['articles'] != null) {
          final filteredArticles = (data['articles'] as List).where((article) {
            final title = article['title']?.toString().toLowerCase() ?? '';
            final description = article['description']?.toString().toLowerCase() ?? '';
            final content = article['content']?.toString().toLowerCase() ?? '';
            
            // Palabras clave relevantes para spa y barbería
            final keywords = [
              'spa', 'barber', 'barbershop', 'salon', 'beauty', 'hair', 'massage',
              'wellness', 'grooming', 'skincare', 'facial', 'manicure', 'pedicure',
              'haircut', 'hairstyle', 'treatment', 'cosmetic', 'aesthetics'
            ];
            
            return keywords.any((keyword) => 
              title.contains(keyword) || 
              description.contains(keyword) || 
              content.contains(keyword)
            );
          }).toList();
          
          data['articles'] = filteredArticles;
          data['totalResults'] = filteredArticles.length;
        }
        
        return data;
      } else {
        print('NewsAPI Error: ${response.statusCode} - ${response.body}');
        return _getFallbackNews();
      }
    } catch (e) {
      print('Error fetching news: $e');
      return _getFallbackNews();
    }
  }
  
  // Datos de respaldo si la API falla
  Map<String, dynamic> _getFallbackNews() {
    return {
      'status': 'ok',
      'totalResults': 6,
      'articles': [
        {
          'title': 'Las 10 Tendencias de Barbería Más Populares de 2025',
          'description': 'Descubre los cortes y estilos que están dominando el mundo de la barbería este año. Desde degradados modernos hasta estilos clásicos reinventados.',
          'url': 'https://example.com/barber-trends-2025',
          'urlToImage': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-28T08:00:00Z',
          'source': {'name': 'Barber Magazine'},
          'author': 'Carlos Pérez',
        },
        {
          'title': 'Spa y Bienestar: Los Tratamientos Más Solicitados del Año',
          'description': 'Los centros de spa reportan un aumento en la demanda de tratamientos de relajación y cuidado personal. Conoce cuáles son los más populares.',
          'url': 'https://example.com/spa-treatments-2025',
          'urlToImage': 'https://images.unsplash.com/photo-1544161512-4ab64f436453?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-27T14:30:00Z',
          'source': {'name': 'Wellness Today'},
          'author': 'María González',
        },
        {
          'title': 'La Revolución Digital en los Salones de Belleza',
          'description': 'Cómo la tecnología está transformando la experiencia en salones de belleza y spa. Apps de reserva, consultas virtuales y más.',
          'url': 'https://example.com/digital-beauty-salons',
          'urlToImage': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-26T11:15:00Z',
          'source': {'name': 'Beauty Tech News'},
          'author': 'Ana López',
        },
        {
          'title': 'Productos Orgánicos: La Nueva Tendencia en Cuidado Capilar',
          'description': 'Los consumidores prefieren cada vez más productos naturales y orgánicos para el cuidado del cabello. Conoce las marcas líderes.',
          'url': 'https://example.com/organic-hair-products',
          'urlToImage': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-25T16:45:00Z',
          'source': {'name': 'Organic Beauty'},
          'author': 'Roberto Silva',
        },
        {
          'title': 'Masajes Terapéuticos: Beneficios Comprobados por la Ciencia',
          'description': 'Nuevos estudios confirman los beneficios de los masajes terapéuticos para la salud física y mental. Descubre qué técnicas son más efectivas.',
          'url': 'https://example.com/therapeutic-massage-benefits',
          'urlToImage': 'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-24T09:20:00Z',
          'source': {'name': 'Health & Wellness Journal'},
          'author': 'Dr. Patricia Ruiz',
        },
        {
          'title': 'El Auge del Grooming Masculino en América Latina',
          'description': 'El mercado de cuidado personal masculino crece exponencialmente. Análisis de tendencias y oportunidades de negocio.',
          'url': 'https://example.com/male-grooming-latin-america',
          'urlToImage': 'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-23T13:10:00Z',
          'source': {'name': 'Business Beauty'},
          'author': 'Fernando Mendoza',
        },
      ]
    };
  }

  Future<Map<String, dynamic>> getTopNews() async {
    try {
      // Búsqueda de noticias destacadas/populares sobre spa y barbería
      final query = 'spa OR barber OR "beauty salon" OR "hair salon" OR barbershop OR wellness OR massage';
      
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&sortBy=popularity&language=en&pageSize=10&apiKey=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Filtrar y marcar como destacadas
        if (data['articles'] != null) {
          final filteredArticles = (data['articles'] as List).where((article) {
            final title = article['title']?.toString().toLowerCase() ?? '';
            final description = article['description']?.toString().toLowerCase() ?? '';
            
            final keywords = [
              'spa', 'barber', 'barbershop', 'salon', 'beauty', 'hair', 'massage',
              'wellness', 'grooming', 'skincare', 'facial', 'treatment'
            ];
            
            return keywords.any((keyword) => 
              title.contains(keyword) || description.contains(keyword)
            );
          }).take(3).map((article) {
            // Marcar como destacado
            article['featured'] = true;
            return article;
          }).toList();
          
          data['articles'] = filteredArticles;
          data['totalResults'] = filteredArticles.length;
        }
        
        return data;
      } else {
        print('NewsAPI Error for top news: ${response.statusCode} - ${response.body}');
        return _getFallbackTopNews();
      }
    } catch (e) {
      print('Error fetching top news: $e');
      return _getFallbackTopNews();
    }
  }
  
  Map<String, dynamic> _getFallbackTopNews() {
    return {
      'status': 'ok',
      'totalResults': 3,
      'articles': [
        {
          'title': 'Nueva Técnica de Coloración Revoluciona la Industria',
          'description': 'Una innovadora técnica de coloración capilar promete resultados más duraderos y menos daño al cabello.',
          'url': 'https://example.com/new-coloring-technique',
          'urlToImage': 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-28T12:00:00Z',
          'source': {'name': 'Innovation Beauty'},
          'author': 'Dra. Carmen Jiménez',
          'featured': true,
        },
        {
          'title': 'Spa de Lujo Abre sus Puertas en el Centro de la Ciudad',
          'description': 'El nuevo centro de bienestar promete una experiencia única con tratamientos exclusivos y tecnología de vanguardia.',
          'url': 'https://example.com/luxury-spa-opening',
          'urlToImage': 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-28T10:30:00Z',
          'source': {'name': 'City Life'},
          'author': 'Javier Morales',
          'featured': true,
        },
        {
          'title': 'Competencia Nacional de Barbería Anuncia Fechas 2025',
          'description': 'Los mejores barberos del país se preparan para demostrar sus habilidades en la competencia más importante del año.',
          'url': 'https://example.com/barber-competition-2025',
          'urlToImage': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400&h=250&fit=crop',
          'publishedAt': '2025-01-27T18:00:00Z',
          'source': {'name': 'Barber News'},
          'author': 'Luis Herrera',
          'featured': true,
        },
      ]
    };
  }

  Future<Map<String, dynamic>> searchNews(String query) async {
    try {
      // Combinar la búsqueda del usuario con palabras clave de spa/barbería
      final combinedQuery = '$query AND (spa OR barber OR "beauty salon" OR wellness OR massage OR grooming)';
      
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$combinedQuery&sortBy=relevancy&language=en&pageSize=15&apiKey=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Filtrar resultados relevantes
        if (data['articles'] != null) {
          final filteredArticles = (data['articles'] as List).where((article) {
            final title = article['title']?.toString().toLowerCase() ?? '';
            final description = article['description']?.toString().toLowerCase() ?? '';
            final searchQuery = query.toLowerCase();
            
            final keywords = [
              'spa', 'barber', 'barbershop', 'salon', 'beauty', 'hair', 'massage',
              'wellness', 'grooming', 'skincare', 'facial', 'treatment'
            ];
            
            // Debe contener la búsqueda del usuario Y al menos una palabra clave relevante
            final containsSearch = title.contains(searchQuery) || description.contains(searchQuery);
            final containsKeyword = keywords.any((keyword) => 
              title.contains(keyword) || description.contains(keyword)
            );
            
            return containsSearch && containsKeyword;
          }).toList();
          
          data['articles'] = filteredArticles;
          data['totalResults'] = filteredArticles.length;
        }
        
        return data;
      } else {
        print('NewsAPI Search Error: ${response.statusCode} - ${response.body}');
        return _getFallbackSearchNews(query);
      }
    } catch (e) {
      print('Error searching news: $e');
      return _getFallbackSearchNews(query);
    }
  }
  
  Map<String, dynamic> _getFallbackSearchNews(String query) {
    // Fallback: filtrar datos mock localmente
    final mockArticles = _getFallbackNews()['articles'] as List;
    
    final filteredArticles = mockArticles.where((article) {
      final title = article['title'].toString().toLowerCase();
      final description = article['description'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      
      return title.contains(searchQuery) || description.contains(searchQuery);
    }).toList();
    
    return {
      'status': 'ok',
      'totalResults': filteredArticles.length,
      'articles': filteredArticles,
    };
  }
}