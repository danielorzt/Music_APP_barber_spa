import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/dev_config.dart';
import '../models/agendamiento.dart';

class AppointmentsApiService {
  final Dio _dio = Dio();

  AppointmentsApiService() {
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

  /// Obtiene la lista de agendamientos del usuario.
  /// Devuelve una lista de [Agendamiento] si tiene éxito.
  /// Lanza una excepción con un mensaje claro si falla.
  Future<List<Agendamiento>> getMisAgendamientos() async {
    try {
      print('📅 Obteniendo agendamientos del usuario...');
      
      final options = await _getAuthOptions();
      final response = await _dio.get(
        DevConfig.getEndpoint('agendamientos')!,
        options: options,
      );

      // Laravel a menudo envuelve los resultados en una clave 'data'.
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> agendamientosJson = response.data['data'];
        // Mapea la lista de JSON a una lista de objetos Agendamiento.
        final agendamientos = agendamientosJson
            .map((json) => Agendamiento.fromJson(json))
            .toList();
        
        print('✅ Agendamientos obtenidos exitosamente: ${agendamientos.length}');
        return agendamientos;
      } else {
        // Si la respuesta no es la esperada pero no es un error de Dio.
        throw 'Respuesta inesperada del servidor al obtener agendamientos.';
      }
    } on DioException catch (e) {
      print('❌ Error de Dio al obtener agendamientos: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      
      // Si la API devuelve un error de validación (422) o cualquier otro.
      if (e.response != null && e.response!.data['message'] != null) {
        throw e.response!.data['message'];
      }
      
      // Manejar errores específicos según el código de estado
      switch (e.response?.statusCode) {
        case 401:
          throw 'Sesión expirada. Por favor, inicia sesión nuevamente.';
        case 403:
          throw 'No tienes permisos para ver estos agendamientos.';
        case 404:
          throw 'No se encontraron agendamientos.';
        case 500:
          throw 'Error interno del servidor. Inténtalo más tarde.';
        default:
          throw 'No se pudo conectar al servidor. Revisa tu conexión a internet.';
      }
    } catch (e) {
      print('❌ Error inesperado al obtener agendamientos: $e');
      throw 'Ocurrió un error inesperado al obtener los agendamientos.';
    }
  }

  /// Crea un nuevo agendamiento.
  /// Recibe un objeto [Agendamiento] con los datos a enviar.
  /// Devuelve el agendamiento creado desde la API.
  Future<Agendamiento> crearAgendamiento(Agendamiento nuevoAgendamiento) async {
    try {
      print('📅 Creando nuevo agendamiento...');
      
      // Convierte el objeto Dart a un mapa para enviarlo como JSON.
      final Map<String, dynamic> data = nuevoAgendamiento.toJson();
      
      final options = await _getAuthOptions();
      final response = await _dio.post(
        DevConfig.getEndpoint('agendamientos')!,
        data: data,
        options: options,
      );

      if (response.statusCode == 201) { // 201 Created
        final agendamientoCreado = Agendamiento.fromJson(response.data['data']);
        print('✅ Agendamiento creado exitosamente: ${agendamientoCreado.id}');
        return agendamientoCreado;
      } else {
        throw 'No se pudo crear el agendamiento.';
      }
    } on DioException catch (e) {
      print('❌ Error de Dio al crear agendamiento: ${e.type}');
      print('📄 Respuesta del servidor: ${e.response?.data}');
      
      if (e.response?.statusCode == 422) {
        // Extrae el primer mensaje de error de validación.
        final errors = e.response!.data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw 'Error de validación: $firstError';
      }
      
      // Manejar errores específicos
      switch (e.response?.statusCode) {
        case 400:
          throw 'Datos inválidos para crear el agendamiento.';
        case 401:
          throw 'Sesión expirada. Por favor, inicia sesión nuevamente.';
        case 403:
          throw 'No tienes permisos para crear agendamientos.';
        case 409:
          throw 'Ya existe un agendamiento para esa fecha y hora.';
        case 500:
          throw 'Error interno del servidor. Inténtalo más tarde.';
        default:
          throw 'Error al crear el agendamiento.';
      }
    } catch (e) {
      print('❌ Error inesperado al crear agendamiento: $e');
      throw 'Ocurrió un error inesperado al crear el agendamiento.';
    }
  }

  /// Actualiza un agendamiento existente.
  Future<Agendamiento> actualizarAgendamiento(int agendamientoId, Map<String, dynamic> datos) async {
    try {
      print('📅 Actualizando agendamiento $agendamientoId...');
      
      final options = await _getAuthOptions();
      final response = await _dio.put(
        '${DevConfig.getEndpoint('agendamientos')}/$agendamientoId',
        data: datos,
        options: options,
      );

      if (response.statusCode == 200) {
        final agendamientoActualizado = Agendamiento.fromJson(response.data['data']);
        print('✅ Agendamiento actualizado exitosamente');
        return agendamientoActualizado;
      } else {
        throw 'No se pudo actualizar el agendamiento.';
      }
    } on DioException catch (e) {
      print('❌ Error de Dio al actualizar agendamiento: ${e.type}');
      
      if (e.response?.statusCode == 422) {
        final errors = e.response!.data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        throw 'Error de validación: $firstError';
      }
      
      switch (e.response?.statusCode) {
        case 404:
          throw 'Agendamiento no encontrado.';
        case 403:
          throw 'No tienes permisos para actualizar este agendamiento.';
        default:
          throw 'Error al actualizar el agendamiento.';
      }
    } catch (e) {
      print('❌ Error inesperado al actualizar agendamiento: $e');
      throw 'Ocurrió un error inesperado al actualizar el agendamiento.';
    }
  }

  /// Cancela un agendamiento.
  Future<bool> cancelarAgendamiento(int agendamientoId, {String? motivo}) async {
    try {
      print('📅 Cancelando agendamiento $agendamientoId...');
      
      final data = <String, dynamic>{};
      if (motivo != null) {
        data['motivo_cancelacion'] = motivo;
      }
      
      final options = await _getAuthOptions();
      final response = await _dio.patch(
        '${DevConfig.getEndpoint('agendamientos')}/$agendamientoId/cancelar',
        data: data,
        options: options,
      );

      if (response.statusCode == 200) {
        print('✅ Agendamiento cancelado exitosamente');
        return true;
      } else {
        throw 'No se pudo cancelar el agendamiento.';
      }
    } on DioException catch (e) {
      print('❌ Error de Dio al cancelar agendamiento: ${e.type}');
      
      switch (e.response?.statusCode) {
        case 404:
          throw 'Agendamiento no encontrado.';
        case 403:
          throw 'No tienes permisos para cancelar este agendamiento.';
        case 409:
          throw 'No se puede cancelar un agendamiento que ya fue completado.';
        default:
          throw 'Error al cancelar el agendamiento.';
      }
    } catch (e) {
      print('❌ Error inesperado al cancelar agendamiento: $e');
      throw 'Ocurrió un error inesperado al cancelar el agendamiento.';
    }
  }

  /// Obtiene un agendamiento específico por ID.
  Future<Agendamiento> getAgendamiento(int agendamientoId) async {
    try {
      print('📅 Obteniendo agendamiento $agendamientoId...');
      
      final options = await _getAuthOptions();
      final response = await _dio.get(
        '${DevConfig.getEndpoint('agendamientos')}/$agendamientoId',
        options: options,
      );

      if (response.statusCode == 200) {
        final agendamiento = Agendamiento.fromJson(response.data['data']);
        print('✅ Agendamiento obtenido exitosamente');
        return agendamiento;
      } else {
        throw 'No se pudo obtener el agendamiento.';
      }
    } on DioException catch (e) {
      print('❌ Error de Dio al obtener agendamiento: ${e.type}');
      
      switch (e.response?.statusCode) {
        case 404:
          throw 'Agendamiento no encontrado.';
        case 403:
          throw 'No tienes permisos para ver este agendamiento.';
        default:
          throw 'Error al obtener el agendamiento.';
      }
    } catch (e) {
      print('❌ Error inesperado al obtener agendamiento: $e');
      throw 'Ocurrió un error inesperado al obtener el agendamiento.';
    }
  }

  /// Obtiene la disponibilidad de horarios para una fecha específica.
  Future<List<Map<String, dynamic>>> getDisponibilidad(DateTime fecha, int servicioId) async {
    try {
      print('📅 Obteniendo disponibilidad para ${fecha.toIso8601String()}...');
      
      final options = await _getAuthOptions();
      final response = await _dio.get(
        '${DevConfig.getEndpoint('disponibilidad')}',
        queryParameters: {
          'fecha': fecha.toIso8601String().split('T')[0],
          'servicio_id': servicioId,
        },
        options: options,
      );

      if (response.statusCode == 200) {
        final disponibilidad = List<Map<String, dynamic>>.from(response.data['data'] ?? []);
        print('✅ Disponibilidad obtenida exitosamente');
        return disponibilidad;
      } else {
        throw 'No se pudo obtener la disponibilidad.';
      }
    } on DioException catch (e) {
      print('❌ Error de Dio al obtener disponibilidad: ${e.type}');
      throw 'Error al obtener la disponibilidad de horarios.';
    } catch (e) {
      print('❌ Error inesperado al obtener disponibilidad: $e');
      throw 'Ocurrió un error inesperado al obtener la disponibilidad.';
    }
  }
} 