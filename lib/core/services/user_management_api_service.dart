import 'dart:convert';
import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio para gestión de usuarios y perfiles con la API real de Laravel
class UserManagementApiService extends BaseApiService {
  
  /// GESTIÓN DE PERFIL
  
  /// Obtener perfil del usuario autenticado
  Future<Map<String, dynamic>> getPerfil() async {
    print('👤 Obteniendo perfil de usuario...');
    
    try {
      final response = await get(ApiConfig.perfilEndpoint);
      print('✅ Perfil obtenido exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo perfil: $e');
      rethrow;
    }
  }
  
  /// Actualizar perfil del usuario
  Future<Map<String, dynamic>> actualizarPerfil({
    String? nombre,
    String? telefono,
    String? fechaNacimiento,
    String? genero,
    String? fotoPerfilUrl,
    Map<String, dynamic>? datosAdicionales,
  }) async {
    print('👤 Actualizando perfil de usuario...');
    
    try {
      final body = <String, dynamic>{};
      
      if (nombre != null) body['nombre'] = nombre;
      if (telefono != null) body['telefono'] = telefono;
      if (fechaNacimiento != null) body['fecha_nacimiento'] = fechaNacimiento;
      if (genero != null) body['genero'] = genero;
      if (fotoPerfilUrl != null) body['foto_perfil_url'] = fotoPerfilUrl;
      if (datosAdicionales != null) body.addAll(datosAdicionales);
      
      final response = await put(ApiConfig.perfilEndpoint, body);
      print('✅ Perfil actualizado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando perfil: $e');
      rethrow;
    }
  }
  
  /// Cambiar contraseña
  Future<Map<String, dynamic>> cambiarContrasena({
    required String contrasenaActual,
    required String nuevaContrasena,
    required String confirmarContrasena,
  }) async {
    print('🔒 Cambiando contraseña...');
    
    try {
      final body = {
        'current_password': contrasenaActual,
        'password': nuevaContrasena,
        'password_confirmation': confirmarContrasena,
      };
      
      final response = await put('${ApiConfig.perfilEndpoint}/cambiar-contrasena', body);
      print('✅ Contraseña cambiada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error cambiando contraseña: $e');
      rethrow;
    }
  }
  
  /// PREFERENCIAS MUSICALES
  
  /// Obtener preferencias musicales del usuario
  Future<Map<String, dynamic>> getPreferenciasMusicales() async {
    print('🎵 Obteniendo preferencias musicales...');
    
    try {
      final response = await get(ApiConfig.preferenciasMusicaEndpoint);
      print('✅ Preferencias musicales obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo preferencias musicales: $e');
      rethrow;
    }
  }
  
  /// Actualizar preferencias musicales
  Future<Map<String, dynamic>> actualizarPreferenciasMusicales({
    required List<String> generosMusicales,
    String? artista,
    String? cancion,
    String? playlist,
    bool? permitirMusicaAleatoria,
    int? volumenPreferido,
  }) async {
    print('🎵 Actualizando preferencias musicales...');
    
    try {
      final body = {
        'generos_musicales': generosMusicales,
        if (artista != null) 'artista': artista,
        if (cancion != null) 'cancion': cancion,
        if (playlist != null) 'playlist': playlist,
        if (permitirMusicaAleatoria != null) 'permitir_musica_aleatoria': permitirMusicaAleatoria,
        if (volumenPreferido != null) 'volumen_preferido': volumenPreferido,
      };
      
      final response = await put(ApiConfig.preferenciasMusicaEndpoint, body);
      print('✅ Preferencias musicales actualizadas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando preferencias musicales: $e');
      rethrow;
    }
  }
  
  /// RESEÑAS Y CALIFICACIONES
  
  /// Obtener reseñas del usuario
  Future<Map<String, dynamic>> getResenasUsuario({
    int? page,
    int? limit,
  }) async {
    print('⭐ Obteniendo reseñas del usuario...');
    
    try {
      String endpoint = ApiConfig.resenasEndpoint;
      List<String> params = [];
      
      if (page != null) params.add('page=$page');
      if (limit != null) params.add('limit=$limit');
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await get(endpoint);
      print('✅ Reseñas obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo reseñas: $e');
      rethrow;
    }
  }
  
  /// Crear una nueva reseña
  Future<Map<String, dynamic>> crearResena({
    required String servicioId,
    required int calificacion,
    String? comentario,
    String? agendamientoId,
    List<String>? fotos,
  }) async {
    print('⭐ Creando nueva reseña...');
    
    try {
      final body = {
        'servicio_id': servicioId,
        'calificacion': calificacion,
        if (comentario != null) 'comentario': comentario,
        if (agendamientoId != null) 'agendamiento_id': agendamientoId,
        if (fotos != null) 'fotos': fotos,
      };
      
      final response = await post(ApiConfig.resenasEndpoint, body);
      print('✅ Reseña creada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error creando reseña: $e');
      rethrow;
    }
  }
  
  /// Actualizar una reseña
  Future<Map<String, dynamic>> actualizarResena(
    String resenaId,
    Map<String, dynamic> data,
  ) async {
    print('⭐ Actualizando reseña $resenaId...');
    
    try {
      final response = await put('${ApiConfig.resenasEndpoint}/$resenaId', data);
      print('✅ Reseña actualizada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando reseña: $e');
      rethrow;
    }
  }
  
  /// Eliminar una reseña
  Future<Map<String, dynamic>> eliminarResena(String resenaId) async {
    print('⭐ Eliminando reseña $resenaId...');
    
    try {
      final response = await delete('${ApiConfig.resenasEndpoint}/$resenaId');
      print('✅ Reseña eliminada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error eliminando reseña: $e');
      rethrow;
    }
  }
  
  /// RECORDATORIOS
  
  /// Obtener recordatorios del usuario
  Future<Map<String, dynamic>> getRecordatorios({
    String? tipo,
    bool? soloActivos,
  }) async {
    print('🔔 Obteniendo recordatorios...');
    
    try {
      String endpoint = ApiConfig.recordatoriosEndpoint;
      List<String> params = [];
      
      if (tipo != null) params.add('tipo=$tipo');
      if (soloActivos != null) params.add('solo_activos=$soloActivos');
      
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }
      
      final response = await get(endpoint);
      print('✅ Recordatorios obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo recordatorios: $e');
      rethrow;
    }
  }
  
  /// Crear un recordatorio
  Future<Map<String, dynamic>> crearRecordatorio({
    required String tipo,
    required String titulo,
    required String fechaHora,
    String? descripcion,
    String? agendamientoId,
    bool? activo,
  }) async {
    print('🔔 Creando recordatorio...');
    
    try {
      final body = {
        'tipo': tipo,
        'titulo': titulo,
        'fecha_hora': fechaHora,
        if (descripcion != null) 'descripcion': descripcion,
        if (agendamientoId != null) 'agendamiento_id': agendamientoId,
        'activo': activo ?? true,
      };
      
      final response = await post(ApiConfig.recordatoriosEndpoint, body);
      print('✅ Recordatorio creado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error creando recordatorio: $e');
      rethrow;
    }
  }
  
  /// Actualizar un recordatorio
  Future<Map<String, dynamic>> actualizarRecordatorio(
    String recordatorioId,
    Map<String, dynamic> data,
  ) async {
    print('🔔 Actualizando recordatorio $recordatorioId...');
    
    try {
      final response = await put('${ApiConfig.recordatoriosEndpoint}/$recordatorioId', data);
      print('✅ Recordatorio actualizado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando recordatorio: $e');
      rethrow;
    }
  }
  
  /// Eliminar un recordatorio
  Future<Map<String, dynamic>> eliminarRecordatorio(String recordatorioId) async {
    print('🔔 Eliminando recordatorio $recordatorioId...');
    
    try {
      final response = await delete('${ApiConfig.recordatoriosEndpoint}/$recordatorioId');
      print('✅ Recordatorio eliminado exitosamente');
      return response;
    } catch (e) {
      print('❌ Error eliminando recordatorio: $e');
      rethrow;
    }
  }
  
  /// FAVORITOS
  
  /// Obtener servicios favoritos
  Future<Map<String, dynamic>> getFavoritos({String? tipo}) async {
    print('❤️ Obteniendo favoritos...');
    
    try {
      String endpoint = ApiConfig.favoritosEndpoint;
      if (tipo != null) {
        endpoint += '?tipo=$tipo';
      }
      
      final response = await get(endpoint);
      print('✅ Favoritos obtenidos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo favoritos: $e');
      rethrow;
    }
  }
  
  /// Agregar a favoritos
  Future<Map<String, dynamic>> agregarAFavoritos({
    required String servicioId,
    String? notas,
  }) async {
    print('❤️ Agregando a favoritos...');
    
    try {
      final body = {
        'servicio_id': servicioId,
        if (notas != null) 'notas': notas,
      };
      
      final response = await post(ApiConfig.favoritosEndpoint, body);
      print('✅ Agregado a favoritos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error agregando a favoritos: $e');
      rethrow;
    }
  }
  
  /// Eliminar de favoritos
  Future<Map<String, dynamic>> eliminarDeFavoritos(String favoritoId) async {
    print('❤️ Eliminando de favoritos...');
    
    try {
      final response = await delete('${ApiConfig.favoritosEndpoint}/$favoritoId');
      print('✅ Eliminado de favoritos exitosamente');
      return response;
    } catch (e) {
      print('❌ Error eliminando de favoritos: $e');
      rethrow;
    }
  }
  
  /// CONFIGURACIÓN DE NOTIFICACIONES
  
  /// Obtener configuración de notificaciones
  Future<Map<String, dynamic>> getConfiguracionNotificaciones() async {
    print('🔔 Obteniendo configuración de notificaciones...');
    
    try {
      final response = await get('${ApiConfig.perfilEndpoint}/notificaciones');
      print('✅ Configuración obtenida exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo configuración: $e');
      rethrow;
    }
  }
  
  /// Actualizar configuración de notificaciones
  Future<Map<String, dynamic>> actualizarConfiguracionNotificaciones({
    bool? recordatoriosCitas,
    bool? promociones,
    bool? nuevosServicios,
    bool? confirmacionCitas,
    bool? notificacionesSMS,
    bool? notificacionesEmail,
    bool? notificacionesPush,
  }) async {
    print('🔔 Actualizando configuración de notificaciones...');
    
    try {
      final body = <String, dynamic>{};
      
      if (recordatoriosCitas != null) body['recordatorios_citas'] = recordatoriosCitas;
      if (promociones != null) body['promociones'] = promociones;
      if (nuevosServicios != null) body['nuevos_servicios'] = nuevosServicios;
      if (confirmacionCitas != null) body['confirmacion_citas'] = confirmacionCitas;
      if (notificacionesSMS != null) body['notificaciones_sms'] = notificacionesSMS;
      if (notificacionesEmail != null) body['notificaciones_email'] = notificacionesEmail;
      if (notificacionesPush != null) body['notificaciones_push'] = notificacionesPush;
      
      final response = await put('${ApiConfig.perfilEndpoint}/notificaciones', body);
      print('✅ Configuración actualizada exitosamente');
      return response;
    } catch (e) {
      print('❌ Error actualizando configuración: $e');
      rethrow;
    }
  }
  
  /// ESTADÍSTICAS DEL USUARIO
  
  /// Obtener estadísticas generales del usuario
  Future<Map<String, dynamic>> getEstadisticasUsuario() async {
    print('📊 Obteniendo estadísticas de usuario...');
    
    try {
      final response = await get('${ApiConfig.perfilEndpoint}/estadisticas');
      print('✅ Estadísticas obtenidas exitosamente');
      return response;
    } catch (e) {
      print('❌ Error obteniendo estadísticas: $e');
      rethrow;
    }
  }
}