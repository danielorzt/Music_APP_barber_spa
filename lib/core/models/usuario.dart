import 'package:equatable/equatable.dart';

class Usuario extends Equatable {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String rol;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.rol,
  });

  @override
  List<Object?> get props => [id, nombre, apellido, email, rol];

  // Método para crear un Usuario desde un mapa JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      rol: json['rol'] as String,
    );
  }

  // Método para convertir un Usuario a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'rol': rol,
    };
  }
}