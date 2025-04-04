import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'https://api.example.com/v1'});

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

  // Método para obtener servicios disponibles
  Future<List<Map<String, dynamic>>> getServices() async {
    try {
      final response = await get('services');
      return List<Map<String, dynamic>>.from(response['data']);
    } catch (e) {
      // Si la API falla, devolvemos datos demo
      return [
        {'id': 1, 'name': 'Corte de Cabello', 'price': '250', 'icon': 'cut'},
        {'id': 2, 'name': 'Afeitado Clásico', 'price': '180', 'icon': 'face'},
        {'id': 3, 'name': 'Masaje Relajante', 'price': '400', 'icon': 'spa'},
        {'id': 4, 'name': 'Tratamiento Facial', 'price': '350', 'icon': 'face'},
      ];
    }
  }
}