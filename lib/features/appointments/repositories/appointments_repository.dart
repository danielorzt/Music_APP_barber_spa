// lib/features/appointments/repositories/appointments_repository.dart
// import '../../../core/services/api_service.dart';
import '../models/appointment_model.dart';

class AppointmentsRepository {
  // final ApiService _apiService = ApiService();

  Future<List<Appointment>> getUserAppointments(int userId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Datos mock para citas
    return [
      Appointment(
        id: '1',
        usuarioId: userId.toString(),
        serviceId: '1',
        branchId: '1',
        fechaHora: DateTime.now().add(const Duration(days: 2, hours: 14)),
        estado: 'confirmado',
        mensaje: 'Corte tradicional con acabado profesional',
        servicio: {
          'nombre': 'Corte Clásico',
          'precio': 25000.0,
          'duracion': 30,
        },
        sucursal: {
          'nombre': 'Sucursal Centro',
          'direccion': 'Calle 123 #45-67',
        },
      ),
      Appointment(
        id: '2',
        usuarioId: userId.toString(),
        serviceId: '3',
        branchId: '1',
        fechaHora: DateTime.now().add(const Duration(days: 5, hours: 16, minutes: 30)),
        estado: 'pendiente',
        mensaje: 'Masaje de 60 minutos para relajación',
        servicio: {
          'nombre': 'Masaje Relajante',
          'precio': 45000.0,
          'duracion': 60,
        },
        sucursal: {
          'nombre': 'Sucursal Centro',
          'direccion': 'Calle 123 #45-67',
        },
      ),
      Appointment(
        id: '3',
        usuarioId: userId.toString(),
        serviceId: '2',
        branchId: '1',
        fechaHora: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
        estado: 'completado',
        mensaje: 'Afeitado con navaja tradicional',
        servicio: {
          'nombre': 'Afeitado Tradicional',
          'precio': 18000.0,
          'duracion': 20,
        },
        sucursal: {
          'nombre': 'Sucursal Centro',
          'direccion': 'Calle 123 #45-67',
        },
      ),
    ];
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.get('/appointments/user/$userId');
    //   return (response as List).map((item) => Appointment.fromJson(item)).toList();
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<Appointment> createAppointment(Appointment appointment) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Simular creación exitosa
    return Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      usuarioId: appointment.usuarioId,
      serviceId: appointment.serviceId,
      branchId: appointment.branchId,
      fechaHora: appointment.fechaHora,
      estado: 'pendiente',
      mensaje: appointment.mensaje,
      servicio: appointment.servicio,
      sucursal: appointment.sucursal,
    );
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.post(
    //     '/appointments',
    //     data: appointment.toJson(),
    //   );
    //   return Appointment.fromJson(response);
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<Appointment> updateAppointmentStatus(String appointmentId, String status) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Simular actualización exitosa
    final appointments = await getUserAppointments(1); // Usar userId 1 como ejemplo
    final appointment = appointments.firstWhere(
      (a) => a.id == appointmentId,
      orElse: () => throw Exception('Cita no encontrada'),
    );
    
    return Appointment(
      id: appointment.id,
      usuarioId: appointment.usuarioId,
      serviceId: appointment.serviceId,
      branchId: appointment.branchId,
      fechaHora: appointment.fechaHora,
      estado: status,
      mensaje: appointment.mensaje,
      servicio: appointment.servicio,
      sucursal: appointment.sucursal,
    );
    
    // CÓDIGO ORIGINAL COMENTADO:
    // try {
    //   final response = await _apiService.put(
    //     '/appointments/$appointmentId/status',
    //     data: {'status': status},
    //   );
    //   return Appointment.fromJson(response);
    // } catch (e) {
    //   rethrow;
    // }
  }
}