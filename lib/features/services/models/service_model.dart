// lib/features/services/models/service_model.dart

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final String? imagen;
  final double price;
  final int duration;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    this.imagen,
    required this.price,
    required this.duration,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['nombre'] ?? '',
      description: json['description'] ?? json['descripcion'] ?? '',
      imagen: json['imagen'],
      price: (json['price'] ?? json['precio'] ?? 0.0).toDouble(),
      duration: json['duration'] ?? json['duracion'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagen': imagen,
      'price': price,
      'duration': duration,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagen': imagen,
      'price': price,
      'duration': duration,
    };
  }
}