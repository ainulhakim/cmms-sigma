class MaintenancePlan {
  final String id;
  final String machineId;
  final String maintenanceName;
  final String maintenanceType; // preventive, corrective, predictive, condition_based, emergency
  final String intervalType; // DAY, WEEK, MONTH, OPERATING_HOUR, PRODUCTION_COUNT, MANUAL
  final int intervalValue;
  final int estimatedDurationMinutes;
  final String priority; // low, medium, high, critical
  final String sopDocumentUrl;
  final String description;
  final bool isActive;
  final DateTime? lastGeneratedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MaintenancePlan({
    required this.id,
    required this.machineId,
    required this.maintenanceName,
    this.maintenanceType = 'preventive',
    this.intervalType = 'DAY',
    this.intervalValue = 30,
    this.estimatedDurationMinutes = 60,
    this.priority = 'medium',
    this.sopDocumentUrl = '',
    this.description = '',
    this.isActive = true,
    this.lastGeneratedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MaintenancePlan.fromJson(Map<String, dynamic> json) {
    return MaintenancePlan(
      id: json['id'] as String? ?? '',
      machineId: json['machine_id'] as String? ?? '',
      maintenanceName: json['maintenance_name'] as String? ?? '',
      maintenanceType: json['maintenance_type'] as String? ?? 'preventive',
      intervalType: json['interval_type'] as String? ?? 'DAY',
      intervalValue: json['interval_value'] as int? ?? 30,
      estimatedDurationMinutes:
          json['estimated_duration_minutes'] as int? ?? 60,
      priority: json['priority'] as String? ?? 'medium',
      sopDocumentUrl: json['sop_document_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      lastGeneratedAt: json['last_generated_at'] != null
          ? DateTime.tryParse(json['last_generated_at'] as String)
          : null,
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
      'machine_id': machineId,
      'maintenance_name': maintenanceName,
      'maintenance_type': maintenanceType,
      'interval_type': intervalType,
      'interval_value': intervalValue,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'priority': priority,
      'sop_document_url': sopDocumentUrl,
      'description': description,
      'is_active': isActive,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'machine_id': machineId,
      'maintenance_name': maintenanceName,
      'maintenance_type': maintenanceType,
      'interval_type': intervalType,
      'interval_value': intervalValue,
      'estimated_duration_minutes': estimatedDurationMinutes,
      'priority': priority,
      'sop_document_url': sopDocumentUrl,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'last_generated_at': lastGeneratedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory MaintenancePlan.fromMap(Map<String, dynamic> map) {
    return MaintenancePlan(
      id: map['id'] as String? ?? '',
      machineId: map['machine_id'] as String? ?? '',
      maintenanceName: map['maintenance_name'] as String? ?? '',
      maintenanceType: map['maintenance_type'] as String? ?? 'preventive',
      intervalType: map['interval_type'] as String? ?? 'DAY',
      intervalValue: map['interval_value'] as int? ?? 30,
      estimatedDurationMinutes:
          map['estimated_duration_minutes'] as int? ?? 60,
      priority: map['priority'] as String? ?? 'medium',
      sopDocumentUrl: map['sop_document_url'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isActive: (map['is_active'] == 1 || map['is_active'] == true),
      lastGeneratedAt: map['last_generated_at'] != null
          ? DateTime.tryParse(map['last_generated_at'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  MaintenancePlan copyWith({
    String? id,
    String? machineId,
    String? maintenanceName,
    String? maintenanceType,
    String? intervalType,
    int? intervalValue,
    int? estimatedDurationMinutes,
    String? priority,
    String? sopDocumentUrl,
    String? description,
    bool? isActive,
    DateTime? lastGeneratedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearLastGeneratedAt = false,
  }) {
    return MaintenancePlan(
      id: id ?? this.id,
      machineId: machineId ?? this.machineId,
      maintenanceName: maintenanceName ?? this.maintenanceName,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      intervalType: intervalType ?? this.intervalType,
      intervalValue: intervalValue ?? this.intervalValue,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      priority: priority ?? this.priority,
      sopDocumentUrl: sopDocumentUrl ?? this.sopDocumentUrl,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      lastGeneratedAt: clearLastGeneratedAt
          ? null
          : (lastGeneratedAt ?? this.lastGeneratedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get intervalLabel {
    switch (intervalType) {
      case 'DAY':
        return 'Every $intervalValue day${intervalValue > 1 ? 's' : ''}';
      case 'WEEK':
        return 'Every $intervalValue week${intervalValue > 1 ? 's' : ''}';
      case 'MONTH':
        return 'Every $intervalValue month${intervalValue > 1 ? 's' : ''}';
      case 'OPERATING_HOUR':
        return 'Every $intervalValue operating hours';
      case 'PRODUCTION_COUNT':
        return 'Every $intervalValue units';
      case 'MANUAL':
        return 'As needed';
      default:
        return 'Every $intervalValue $intervalType';
    }
  }

  @override
  String toString() =>
      'MaintenancePlan(id: $id, name: $maintenanceName, type: $maintenanceType)';
}
