// lib/features/profile/models/user_model.dart

enum UserRole { client, staff, admin }

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String imageUrl;
  final UserRole role;
  final bool isPremium;
  final DateTime registrationDate;
  final Map<String, dynamic> preferences;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.imageUrl = '',
    this.role = UserRole.client,
    this.isPremium = false,
    DateTime? registrationDate,
    this.preferences = const {},
  }) : registrationDate = registrationDate ?? DateTime.now();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      role: _parseUserRole(json['role']),
      isPremium: json['isPremium'] ?? false,
      registrationDate: json['registrationDate'] != null
          ? DateTime.parse(json['registrationDate'])
          : null,
      preferences: json['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'role': role.toString().split('.').last,
      'isPremium': isPremium,
      'registrationDate': registrationDate.toIso8601String(),
      'preferences': preferences,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? imageUrl,
    UserRole? role,
    bool? isPremium,
    DateTime? registrationDate,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      isPremium: isPremium ?? this.isPremium,
      registrationDate: registrationDate ?? this.registrationDate,
      preferences: preferences ?? this.preferences,
    );
  }

  static UserRole _parseUserRole(String? roleStr) {
    if (roleStr == null) return UserRole.client;

    switch (roleStr.toLowerCase()) {
      case 'admin': return UserRole.admin;
      case 'staff': return UserRole.staff;
      default: return UserRole.client;
    }
  }
}