import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../config/dev_config.dart';

class UserManagementApiService {
  final Dio _dio = Dio();

  UserManagementApiService() {
    _dio.options.baseUrl = DevConfig.apiBaseUrl;
    _dio.options.connectTimeout = DevConfig.defaultTimeout;
    _dio.options.receiveTimeout = DevConfig.defaultTimeout;
  }

  /// Obtener token de autenticación
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  /// Configurar headers de autenticación
  Future<Options> _getAuthOptions() async {
    final token = await _getAuthToken();
    return Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  /// Obtener direcciones del usuario
  Future<Map<String, dynamic>> getUserAddresses() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get(
        DevConfig.getEndpoint('userAddresses')!,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': 'Error al obtener direcciones',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Agregar dirección del usuario
  Future<Map<String, dynamic>> addUserAddress(Map<String, String> addressData) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.post(
        DevConfig.getEndpoint('userAddresses')!,
        data: addressData,
        options: options,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al agregar dirección',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Actualizar dirección del usuario
  Future<Map<String, dynamic>> updateUserAddress(String addressId, Map<String, String> addressData) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.put(
        '${DevConfig.getEndpoint('userAddresses')}/$addressId',
        data: addressData,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al actualizar dirección',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Eliminar dirección del usuario
  Future<Map<String, dynamic>> deleteUserAddress(String addressId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.delete(
        '${DevConfig.getEndpoint('userAddresses')}/$addressId',
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al eliminar dirección',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Obtener favoritos del usuario
  Future<Map<String, dynamic>> getUserFavorites() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get(
        DevConfig.getEndpoint('userFavorites')!,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': 'Error al obtener favoritos',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Eliminar favorito del usuario
  Future<Map<String, dynamic>> removeUserFavorite(String favoriteId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.delete(
        '${DevConfig.getEndpoint('userFavorites')}/$favoriteId',
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al eliminar favorito',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Obtener citas del usuario
  Future<Map<String, dynamic>> getUserAppointments() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get(
        DevConfig.getEndpoint('userAppointments')!,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': 'Error al obtener citas',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Obtener órdenes del usuario
  Future<Map<String, dynamic>> getUserOrders() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get(
        DevConfig.getEndpoint('userOrders')!,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': 'Error al obtener órdenes',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Obtener métodos de pago del usuario
  Future<Map<String, dynamic>> getUserPaymentMethods() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get(
        DevConfig.getEndpoint('userPaymentMethods')!,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data['data'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': 'Error al obtener métodos de pago',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Agregar método de pago del usuario
  Future<Map<String, dynamic>> addUserPaymentMethod(Map<String, String> paymentData) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.post(
        DevConfig.getEndpoint('userPaymentMethods')!,
        data: paymentData,
        options: options,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al agregar método de pago',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Actualizar método de pago del usuario
  Future<Map<String, dynamic>> updateUserPaymentMethod(String paymentMethodId, Map<String, String> paymentData) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.put(
        '${DevConfig.getEndpoint('userPaymentMethods')}/$paymentMethodId',
        data: paymentData,
        options: options,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al actualizar método de pago',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  /// Eliminar método de pago del usuario
  Future<Map<String, dynamic>> deleteUserPaymentMethod(String paymentMethodId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.delete(
        '${DevConfig.getEndpoint('userPaymentMethods')}/$paymentMethodId',
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
        };
      } else {
        return {
          'success': false,
          'error': 'Error al eliminar método de pago',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }
}