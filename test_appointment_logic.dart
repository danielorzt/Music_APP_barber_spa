import 'dart:convert';

void main() {
  print('🔍 DEBUG: Probando lógica de agendamiento con datos mock');
  print('=' * 60);
  
  // Simular datos de usuario
  final mockUser = {
    'id': 1,
    'nombre': 'Usuario Test',
    'email': 'test@example.com',
  };
  
  // Simular datos de sucursal
  final mockSucursal = {
    'id': 1,
    'nombre': 'Sucursal Centro',
    'direccion': 'Calle Principal 123',
  };
  
  // Simular datos de servicio
  final mockServicio = {
    'id': 1,
    'nombre': 'Corte Clásico',
    'precio': 25.0,
    'duracion': 30,
  };
  
  // Simular datos de fecha y hora
  final mockFecha = DateTime.now().add(const Duration(days: 1));
  final mockHora = '14:30';
  
  print('📋 Datos de prueba:');
  print('  - Usuario: ${mockUser['nombre']} (ID: ${mockUser['id']})');
  print('  - Sucursal: ${mockSucursal['nombre']} (ID: ${mockSucursal['id']})');
  print('  - Servicio: ${mockServicio['nombre']} (ID: ${mockServicio['id']})');
  print('  - Fecha: ${mockFecha.day}/${mockFecha.month}/${mockFecha.year}');
  print('  - Hora: $mockHora');
  
  // Simular validación de campos requeridos
  print('\n🔍 Validando campos requeridos...');
  
  bool sucursalSeleccionada = true;
  bool servicioSeleccionado = true;
  bool fechaSeleccionada = true;
  bool horaSeleccionada = true;
  
  print('  - Sucursal seleccionada: ${sucursalSeleccionada ? "✅" : "❌"}');
  print('  - Servicio seleccionado: ${servicioSeleccionado ? "✅" : "❌"}');
  print('  - Fecha seleccionada: ${fechaSeleccionada ? "✅" : "❌"}');
  print('  - Hora seleccionada: ${horaSeleccionada ? "✅" : "❌"}');
  
  final canConfirm = sucursalSeleccionada && 
                     servicioSeleccionado && 
                     fechaSeleccionada && 
                     horaSeleccionada;
  
  print('  - Puede confirmar: ${canConfirm ? "✅" : "❌"}');
  
  if (!canConfirm) {
    print('❌ ERROR: Campos requeridos incompletos');
    return;
  }
  
  // Simular creación de objeto Agendamiento
  print('\n📅 Creando objeto Agendamiento...');
  
  final fechaHora = DateTime(
    mockFecha.year,
    mockFecha.month,
    mockFecha.day,
    14, // hora
    30, // minuto
  );
  
  final mockAgendamiento = {
    'id': 0,
    'fecha_hora': fechaHora.toIso8601String(),
    'cliente_usuario_id': mockUser['id'],
    'servicio_id': mockServicio['id'],
    'sucursal_id': mockSucursal['id'],
    'estado': 'PROGRAMADA',
    'notas': 'Cita agendada desde la app móvil',
  };
  
  print('✅ Objeto Agendamiento creado:');
  print(json.encode(mockAgendamiento));
  
  // Simular respuesta exitosa del servidor
  print('\n🎉 Simulando respuesta exitosa del servidor...');
  
  final mockResponse = {
    'success': true,
    'message': 'Agendamiento creado exitosamente',
    'data': {
      ...mockAgendamiento,
      'id': 123, // ID asignado por el servidor
      'created_at': DateTime.now().toIso8601String(),
    }
  };
  
  print('✅ Respuesta del servidor:');
  print(json.encode(mockResponse));
  
  print('\n🏁 Prueba completada exitosamente');
  print('=' * 60);
} 