import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

/// Servicio base para todas las APIs
/// Contiene funcionalidades comunes como headers, auth, manejo de errores
class BaseApiService {
  
  // Headers por defecto
  Map<String, String> get _headers => ApiConfig.defaultHeaders;

  // Headers con token de autorización
  Future<Map<String, String>> get _authHeaders async {
    final token = await getStoredToken();
    return {
      ..._headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// GET request genérico
  Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
      print('📥 GET: $url');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final timeout = ApiConfig.getTimeoutForEndpoint(endpoint);
      
      final response = await http.get(url, headers: headers).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en GET $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// POST request genérico
  Future<Map<String, dynamic>> post(
    String endpoint, 
    Map<String, dynamic> data, 
    {bool requiresAuth = true}
  ) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
      print('📤 POST: $url');
      print('📤 Data: ${jsonEncode(data)}');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final timeout = ApiConfig.getTimeoutForEndpoint(endpoint);
      
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en POST $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// PUT request genérico
  Future<Map<String, dynamic>> put(
    String endpoint, 
    Map<String, dynamic> data, 
    {bool requiresAuth = true}
  ) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
      print('📝 PUT: $url');
      print('📝 Data: ${jsonEncode(data)}');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final timeout = ApiConfig.getTimeoutForEndpoint(endpoint);
      
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      ).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en PUT $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// DELETE request genérico
  Future<Map<String, dynamic>> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(endpoint));
      print('🗑️ DELETE: $url');
      
      final headers = requiresAuth ? await _authHeaders : _headers;
      final timeout = ApiConfig.getTimeoutForEndpoint(endpoint);
      
      final response = await http.delete(url, headers: headers).timeout(timeout);
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ Error en DELETE $endpoint: $e');
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  /// Manejo unificado de respuestas
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        print('✅ Respuesta exitosa');
        
        return {
          'success': true,
          'data': data,
          'status_code': response.statusCode,
        };
      } catch (jsonError) {
        print('⚠️ Respuesta no JSON, pero exitosa');
        return {
          'success': true,
          'data': {'raw_response': response.body},
          'status_code': response.statusCode,
        };
      }
    } else {
      print('❌ Status code no exitoso: ${response.statusCode}');
      try {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorData['message'] ?? errorData['error'] ?? 'Error en el servidor',
          'details': errorData,
          'status_code': response.statusCode,
        };
      } catch (e) {
        return {
          'success': false,
          'error': 'Error del servidor (${response.statusCode}): ${response.body}',
          'status_code': response.statusCode,
        };
      }
    }
  }

  /// Buscar datos en diferentes estructuras de respuesta
  dynamic extractData(Map<String, dynamic> response, String key) {
    // Buscar en nivel raíz
    if (response[key] != null) {
      return response[key];
    }
    
    // Buscar en data wrapper
    if (response['data'] != null && response['data'][key] != null) {
      return response['data'][key];
    }
    
    // Buscar en diferentes variaciones
    final variations = ['${key}s', key.toLowerCase(), '${key.toLowerCase()}s'];
    for (final variation in variations) {
      if (response[variation] != null) {
        return response[variation];
      }
      if (response['data'] != null && response['data'][variation] != null) {
        return response['data'][variation];
      }
    }
    
    return null;
  }

  /// Obtener lista de elementos de la respuesta
  List<dynamic> extractList(Map<String, dynamic> response, [String? key]) {
    if (key != null) {
      final data = extractData(response, key);
      if (data is List) return List<dynamic>.from(data);
    }
    
    // Buscar lista en diferentes lugares
    if (response['data'] is List) {
      return List<dynamic>.from(response['data']);
    }
    
    // response siempre es Map<String, dynamic>, no List
    // Eliminar esta verificación que causaba el error de tipos
    
    // Buscar en campos comunes
    for (final field in ['items', 'results', 'records', 'list']) {
      final data = extractData(response, field);
      if (data is List) {
        return List<dynamic>.from(data);
      }
    }
    
    // Si no encontramos una lista, devolver lista vacía
    return [];
  }

  /// Obtener token guardado
  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Crear parámetros de consulta
  String buildQueryParams(Map<String, dynamic> params) {
    if (params.isEmpty) return '';
    
    final queryParams = params.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
    
    return queryParams.isNotEmpty ? '?$queryParams' : '';
  }

  /// Construir endpoint con parámetros
  String buildEndpointWithParams(String baseEndpoint, Map<String, dynamic> params) {
    return '$baseEndpoint${buildQueryParams(params)}';
  }
} 