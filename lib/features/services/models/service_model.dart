// lib/features/services/models/service_model.dart

class Service {
  final int id;
  final String name;
  final double price;
  final String icon;
  final String description;
  final int durationMinutes;
  final String imageUrl;
  final List<String> categories;
  final bool available;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    this.description = '',
    this.durationMinutes = 60,
    this.imageUrl = '',
    this.categories = const [],
    this.available = true,
  });

  // Convertir de JSON a objeto Service
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      icon: json['icon'],
      description: json['description'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 60,
      imageUrl: json['imageUrl'] ?? '',
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      available: json['available'] ?? true,
    );
  }

  // Convertir de objeto Service a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'icon': icon,
      'description': description,
      'durationMinutes': durationMinutes,
      'imageUrl': imageUrl,
      'categories': categories,
      'available': available,
    };
  }

  // Crear una copia del objeto con algunas propiedades modificadas
  Service copyWith({
    int? id,
    String? name,
    double? price,
    String? icon,
    String? description,
    int? durationMinutes,
    String? imageUrl,
    List<String>? categories,
    bool? available,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      available: available ?? this.available,
    );
  }
}