import 'dart:convert';

class UserModel {
  final String id;
  final String? email;
  final String fullName;
  final String phone;
  final String? avatarUrl;
  final String role; // admin, supervisor, technician, viewer
  final String employeeCode;
  final bool isActive;
  final String? fcmToken;
  final Map<String, dynamic> preferences;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    this.email,
    this.fullName = '',
    this.phone = '',
    this.avatarUrl,
    this.role = 'technician',
    this.employeeCode = '',
    this.isActive = true,
    this.fcmToken,
    this.preferences = const {},
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String?,
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'technician',
      employeeCode: json['employee_code'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      fcmToken: json['fcm_token'] as String?,
      preferences: json['preferences'] is Map
          ? Map<String, dynamic>.from(json['preferences'])
          : {},
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (email != null) 'email': email,
      'full_name': fullName,
      'phone': phone,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'role': role,
      'employee_code': employeeCode,
      'is_active': isActive,
      if (fcmToken != null) 'fcm_token': fcmToken,
      'preferences': preferences,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role,
      'employee_code': employeeCode,
      'is_active': isActive ? 1 : 0,
      'fcm_token': fcmToken,
      'preferences': jsonEncode(preferences),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      email: map['email'] as String?,
      fullName: map['full_name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      avatarUrl: map['avatar_url'] as String?,
      role: map['role'] as String? ?? 'technician',
      employeeCode: map['employee_code'] as String? ?? '',
      isActive: (map['is_active'] == 1 || map['is_active'] == true),
      fcmToken: map['fcm_token'] as String?,
      preferences: map['preferences'] is String
          ? jsonDecode(map['preferences']) as Map<String, dynamic>?
          : (map['preferences'] is Map
              ? Map<String, dynamic>.from(map['preferences'])
              : {}),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? role,
    String? employeeCode,
    bool? isActive,
    String? fcmToken,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      employeeCode: employeeCode ?? this.employeeCode,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isSupervisor => role == 'admin' || role == 'supervisor';
  bool get isTechnician => role == 'admin' || role == 'supervisor' || role == 'technician';

  @override
  String toString() => 'UserModel(id: $id, fullName: $fullName, role: $role)';
}
