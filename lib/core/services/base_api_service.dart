import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Servicio base para todas las APIs
abstract class BaseApiService {
  
  /// Obtener headers para peticiones
  Future<Map<String, String>> get _headers async {
    return await ApiConfig.getHeaders();
  }

  /// Realizar petición GET
  Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
    final headers = requiresAuth ? await _headers : await ApiConfig.getHeaders(requiresAuth: false);
    
    print('🌐 GET: $url');
    
    try {
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(ApiConfig.getTimeoutForEndpoint(endpoint));
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en GET $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Realizar petición POST
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {bool requiresAuth = true}) async {
    final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
    final headers = requiresAuth ? await _headers : await ApiConfig.getHeaders(requiresAuth: false);
    
    print('🌐 POST: $url');
    print('📤 Data: ${json.encode(data)}');
    
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      ).timeout(ApiConfig.getTimeoutForEndpoint(endpoint));
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en POST $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Realizar petición PUT
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data, {bool requiresAuth = true}) async {
    final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
    final headers = requiresAuth ? await _headers : await ApiConfig.getHeaders(requiresAuth: false);
    
    print('🌐 PUT: $url');
    print('📤 Data: ${json.encode(data)}');
    
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(data),
      ).timeout(ApiConfig.getTimeoutForEndpoint(endpoint));
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en PUT $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Realizar petición DELETE
  Future<Map<String, dynamic>> delete(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
    final headers = requiresAuth ? await _headers : await ApiConfig.getHeaders(requiresAuth: false);
    
    print('🌐 DELETE: $url');
    
    try {
      final response = await http.delete(
        url,
        headers: headers,
      ).timeout(ApiConfig.getTimeoutForEndpoint(endpoint));
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en DELETE $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Manejar respuesta HTTP
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('📡 Status: ${response.statusCode}');
    print('📡 Body: ${response.body}');
    
    try {
      final data = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'success': true,
          'data': data,
          'status_code': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'error': data['message'] ?? data['error'] ?? 'Error del servidor',
          'details': data,
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      print('❌ Error decodificando JSON: $e');
      return {
        'success': false,
        'error': 'Respuesta no válida del servidor',
        'raw_response': response.body,
        'status_code': response.statusCode,
      };
    }
  }

  /// Extraer datos específicos de la respuesta
  Map<String, dynamic>? extractData(Map<String, dynamic> response, [String? key]) {
    if (key != null) {
      return response['data']?[key] ?? response[key];
    }
    return response['data'] ?? response;
  }

  /// Obtener lista de elementos de la respuesta
  List<dynamic> extractList(Map<String, dynamic> response, [String? key]) {
    // Si se especifica una clave, buscar en esa ubicación
    if (key != null) {
      final data = response['data']?[key] ?? response[key];
      if (data != null && data is List) {
        return List<dynamic>.from(data as List);
      }
    }
    
    // Buscar lista en response['data']
    if (response['data'] is List) {
      return List<dynamic>.from(response['data']);
    }
    
    // Buscar en campos comunes
    for (final field in ['items', 'results', 'records', 'list']) {
      final data = response['data']?[field] ?? response[field];
      if (data != null && data is List) {
        return List<dynamic>.from(data as List);
      }
    }
    
    return [];
  }
} 