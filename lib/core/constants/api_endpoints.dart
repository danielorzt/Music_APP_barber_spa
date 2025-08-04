class ApiEndpoints {
  // URL base del backend. Asegúrate de que tu emulador/dispositivo pueda acceder a esta dirección.
  // Si usas el emulador de Android, '10.0.2.2' generalmente apunta al localhost de tu máquina.
  // Para un dispositivo físico, usa la IP de tu máquina en la red local.
  static const String baseUrl = 'https://13b3b2a25fe8.ngrok-free.app/api'; // URL de ngrok

  // Endpoints de Autenticación
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleLogin = '/auth/google';

  // Endpoints de Productos
  static const String products = '/products';

  // Endpoints de Servicios
  static const String services = '/services';

  // Endpoints de Agendamientos
  static const String appointments = '/agendamientos';

  // Endpoints de Órdenes
  static const String orders = '/ordenes';
}