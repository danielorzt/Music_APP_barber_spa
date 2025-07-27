// lib/core/services/api_service.dart
class ApiService {
  // Constructor para que pueda ser instanciado
  ApiService();

  // Los métodos pueden dejarse vacíos o lanzar un error si se prefiere
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    // Simular una respuesta vacía o de error
    return Future.value({});
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    return Future.value({});
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    return Future.value({});
  }

  Future<dynamic> delete(String path) async {
    return Future.value({});
  }
}
