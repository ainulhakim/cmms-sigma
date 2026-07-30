class Department {
  final String id;
  final String name;
  final String description;
  final String? headUserId;
  final bool isActive;
  final DateTime? createdAt;

  Department({
    required this.id,
    required this.name,
    this.description = '',
    this.headUserId,
    this.isActive = true,
    this.createdAt,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      headUserId: json['head_user_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'description': description,
      if (headUserId != null) 'head_user_id': headUserId,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'head_user_id': headUserId,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      headUserId: map['head_user_id'] as String?,
      isActive: (map['is_active'] == 1 || map['is_active'] == true),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  Department copyWith({
    String? id,
    String? name,
    String? description,
    String? headUserId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      headUserId: headUserId ?? this.headUserId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'Department(id: $id, name: $name)';
}
