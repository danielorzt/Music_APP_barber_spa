// lib/features/products/models/product_model.dart

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final int stock;
  final List<String> categories;
  final bool available;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description = '',
    this.imageUrl = '',
    this.stock = 0,
    this.categories = const [],
    this.available = true,
    this.rating = 0.0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      stock: json['stock'] ?? 0,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : [],
      available: json['available'] ?? true,
      rating: json['rating'] != null
          ? double.parse(json['rating'].toString())
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'stock': stock,
      'categories': categories,
      'available': available,
      'rating': rating,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
    int? stock,
    List<String>? categories,
    bool? available,
    double? rating,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      categories: categories ?? this.categories,
      available: available ?? this.available,
      rating: rating ?? this.rating,
    );
  }
}