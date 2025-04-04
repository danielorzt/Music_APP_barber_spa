// lib/features/promotions/models/promotion_model.dart

class Promotion {
  final int id;
  final String title;
  final String description;
  final double discount;
  final bool isPercentage;
  final List<int> applicableServiceIds;
  final List<int> applicableProductIds;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final String code;
  final bool active;

  Promotion({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    this.isPercentage = true,
    this.applicableServiceIds = const [],
    this.applicableProductIds = const [],
    required this.startDate,
    required this.endDate,
    this.imageUrl = '',
    this.code = '',
    this.active = true,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      discount: double.parse(json['discount'].toString()),
      isPercentage: json['isPercentage'] ?? true,
      applicableServiceIds: json['applicableServiceIds'] != null
          ? List<int>.from(json['applicableServiceIds'])
          : [],
      applicableProductIds: json['applicableProductIds'] != null
          ? List<int>.from(json['applicableProductIds'])
          : [],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      imageUrl: json['imageUrl'] ?? '',
      code: json['code'] ?? '',
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discount': discount,
      'isPercentage': isPercentage,
      'applicableServiceIds': applicableServiceIds,
      'applicableProductIds': applicableProductIds,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'imageUrl': imageUrl,
      'code': code,
      'active': active,
    };
  }

  bool get isValid {
    final now = DateTime.now();
    return active && startDate.isBefore(now) && endDate.isAfter(now);
  }

  Promotion copyWith({
    int? id,
    String? title,
    String? description,
    double? discount,
    bool? isPercentage,
    List<int>? applicableServiceIds,
    List<int>? applicableProductIds,
    DateTime? startDate,
    DateTime? endDate,
    String? imageUrl,
    String? code,
    bool? active,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      discount: discount ?? this.discount,
      isPercentage: isPercentage ?? this.isPercentage,
      applicableServiceIds: applicableServiceIds ?? this.applicableServiceIds,
      applicableProductIds: applicableProductIds ?? this.applicableProductIds,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      code: code ?? this.code,
      active: active ?? this.active,
    );
  }
}