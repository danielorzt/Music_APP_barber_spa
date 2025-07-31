import '../config/api_config.dart';
import 'base_api_service.dart';

/// Servicio específico para gestionar sucursales
class SucursalesApiService extends BaseApiService {
  
  /// Obtener todas las sucursales
  Future<List<Map<String, dynamic>>> getSucursales() async {
    print('🔍 Obteniendo sucursales...');
    
    try {
      final response = await get(ApiConfig.sucursalesEndpoint);
      
      if (response['success'] && response['data'] != null) {
        final List<dynamic> sucursalesJson = response['data'];
        final sucursales = sucursalesJson.cast<Map<String, dynamic>>();
        print('✅ ${sucursales.length} sucursales obtenidas de la API');
        return sucursales;
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } catch (e) {
      print('❌ Error obteniendo sucursales: $e');
      print('📋 Usando datos mock para sucursales...');
      
      // Datos mock para sucursales
      return [
        {
          'id': 1,
          'nombre': 'Sucursal Centro',
          'direccion': 'Av. Principal 123, Centro',
          'telefono': '555-0101',
          'horario': 'Lun-Sáb 9:00-20:00',
          'latitud': 19.4326,
          'longitud': -99.1332,
          'activa': true,
        },
        {
          'id': 2,
          'nombre': 'Sucursal Norte',
          'direccion': 'Blvd. Norte 456, Col. Norte',
          'telefono': '555-0202',
          'horario': 'Lun-Sáb 8:00-19:00',
          'latitud': 19.4426,
          'longitud': -99.1432,
          'activa': true,
        },
        {
          'id': 3,
          'nombre': 'Sucursal Sur',
          'direccion': 'Calle Sur 789, Col. Sur',
          'telefono': '555-0303',
          'horario': 'Lun-Sáb 10:00-21:00',
          'latitud': 19.4226,
          'longitud': -99.1232,
          'activa': true,
        },
        {
          'id': 4,
          'nombre': 'Sucursal Este',
          'direccion': 'Av. Este 321, Col. Este',
          'telefono': '555-0404',
          'horario': 'Lun-Sáb 9:00-20:00',
          'latitud': 19.4326,
          'longitud': -99.1132,
          'activa': true,
        },
      ];
    }
  }
  
  /// Obtener una sucursal específica
  Future<Map<String, dynamic>?> getSucursal(int id) async {
    print('🔍 Obteniendo sucursal $id...');
    
    try {
      final response = await get('${ApiConfig.sucursalesEndpoint}/$id');
      
      if (response['success'] && response['data'] != null) {
        print('✅ Sucursal obtenida exitosamente');
        return response['data'];
      } else {
        throw Exception('Sucursal no encontrada');
      }
    } catch (e) {
      print('❌ Error obteniendo sucursal: $e');
      
      // Buscar en datos mock
      final sucursales = await getSucursales();
      return sucursales.firstWhere(
        (sucursal) => sucursal['id'] == id,
        orElse: () => throw Exception('Sucursal no encontrada'),
      );
    }
  }
  
  /// Obtener horarios de una sucursal
  Future<List<Map<String, dynamic>>> getHorariosSucursal(int sucursalId) async {
    print('🔍 Obteniendo horarios de sucursal $sucursalId...');
    
    try {
      final response = await get('${ApiConfig.horariosSucursalEndpoint}?sucursal_id=$sucursalId');
      
      if (response['success'] && response['data'] != null) {
        final List<dynamic> horariosJson = response['data'];
        final horarios = horariosJson.cast<Map<String, dynamic>>();
        print('✅ ${horarios.length} horarios obtenidos');
        return horarios;
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } catch (e) {
      print('❌ Error obteniendo horarios: $e');
      print('📋 Usando horarios mock...');
      
      // Horarios mock
      return [
        {
          'id': 1,
          'sucursal_id': sucursalId,
          'dia_semana': 1, // Lunes
          'hora_inicio': '09:00:00',
          'hora_fin': '20:00:00',
          'activo': true,
        },
        {
          'id': 2,
          'sucursal_id': sucursalId,
          'dia_semana': 2, // Martes
          'hora_inicio': '09:00:00',
          'hora_fin': '20:00:00',
          'activo': true,
        },
        {
          'id': 3,
          'sucursal_id': sucursalId,
          'dia_semana': 3, // Miércoles
          'hora_inicio': '09:00:00',
          'hora_fin': '20:00:00',
          'activo': true,
        },
        {
          'id': 4,
          'sucursal_id': sucursalId,
          'dia_semana': 4, // Jueves
          'hora_inicio': '09:00:00',
          'hora_fin': '20:00:00',
          'activo': true,
        },
        {
          'id': 5,
          'sucursal_id': sucursalId,
          'dia_semana': 5, // Viernes
          'hora_inicio': '09:00:00',
          'hora_fin': '20:00:00',
          'activo': true,
        },
        {
          'id': 6,
          'sucursal_id': sucursalId,
          'dia_semana': 6, // Sábado
          'hora_inicio': '09:00:00',
          'hora_fin': '20:00:00',
          'activo': true,
        },
        {
          'id': 7,
          'sucursal_id': sucursalId,
          'dia_semana': 0, // Domingo
          'hora_inicio': '10:00:00',
          'hora_fin': '18:00:00',
          'activo': true,
        },
      ];
    }
  }
  
  /// Obtener personal de una sucursal
  Future<List<Map<String, dynamic>>> getPersonalSucursal(int sucursalId) async {
    print('🔍 Obteniendo personal de sucursal $sucursalId...');
    
    try {
      final response = await get('${ApiConfig.personalEndpoint}?sucursal_id=$sucursalId');
      
      if (response['success'] && response['data'] != null) {
        final List<dynamic> personalJson = response['data'];
        final personal = personalJson.cast<Map<String, dynamic>>();
        print('✅ ${personal.length} empleados obtenidos');
        return personal;
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } catch (e) {
      print('❌ Error obteniendo personal: $e');
      print('📋 Usando personal mock...');
      
      // Personal mock
      return [
        {
          'id': 1,
          'nombre': 'Carlos Rodríguez',
          'especialidad': 'Barbero',
          'sucursal_id': sucursalId,
          'disponible': true,
          'imagen': 'https://images.unsplash.com/photo-1503951914875-452162b0f3f1?w=400',
        },
        {
          'id': 2,
          'nombre': 'María González',
          'especialidad': 'Estilista',
          'sucursal_id': sucursalId,
          'disponible': true,
          'imagen': 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
        },
        {
          'id': 3,
          'nombre': 'Luis Martínez',
          'especialidad': 'Masajista',
          'sucursal_id': sucursalId,
          'disponible': true,
          'imagen': 'https://images.unsplash.com/photo-1544161512-6ad2f9d19ca9?w=400',
        },
      ];
    }
  }
} 