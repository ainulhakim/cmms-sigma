class WorkOrder {
  final String id;
  final String workOrderNumber;
  final String machineId;
  final String? maintenancePlanId;
  final String? assignedUserId;
  final DateTime? scheduledDate;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String status; // OPEN, ASSIGNED, IN_PROGRESS, PAUSED, COMPLETED, VERIFIED, CANCELLED
  final String priority; // low, medium, high, critical
  final String problemDescription;
  final String actionTaken;
  final String rootCause;
  final int downtimeMinutes;
  final String technicianNotes;
  final String supervisorNotes;
  final String? verifiedBy;
  final DateTime? verifiedAt;
  final bool isSyncComplete;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Transient / joined fields (not stored directly on table)
  String? machineName;
  String? machineCode;
  String? assignedUserName;

  WorkOrder({
    required this.id,
    required this.workOrderNumber,
    required this.machineId,
    this.maintenancePlanId,
    this.assignedUserId,
    this.scheduledDate,
    this.startedAt,
    this.completedAt,
    this.status = 'OPEN',
    this.priority = 'medium',
    this.problemDescription = '',
    this.actionTaken = '',
    this.rootCause = '',
    this.downtimeMinutes = 0,
    this.technicianNotes = '',
    this.supervisorNotes = '',
    this.verifiedBy,
    this.verifiedAt,
    this.isSyncComplete = true,
    this.createdAt,
    this.updatedAt,
    this.machineName,
    this.machineCode,
    this.assignedUserName,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      id: json['id'] as String? ?? '',
      workOrderNumber: json['work_order_number'] as String? ?? '',
      machineId: json['machine_id'] as String? ?? '',
      maintenancePlanId: json['maintenance_plan_id'] as String?,
      assignedUserId: json['assigned_user_id'] as String?,
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.tryParse(json['scheduled_date'] as String)
          : null,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      status: json['status'] as String? ?? 'OPEN',
      priority: json['priority'] as String? ?? 'medium',
      problemDescription: json['problem_description'] as String? ?? '',
      actionTaken: json['action_taken'] as String? ?? '',
      rootCause: json['root_cause'] as String? ?? '',
      downtimeMinutes: json['downtime_minutes'] as int? ?? 0,
      technicianNotes: json['technician_notes'] as String? ?? '',
      supervisorNotes: json['supervisor_notes'] as String? ?? '',
      verifiedBy: json['verified_by'] as String?,
      verifiedAt: json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'] as String)
          : null,
      isSyncComplete: json['is_sync_complete'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      machineName: json['machine_name'] as String?,
      machineCode: json['machine_code'] as String?,
      assignedUserName: json['assigned_user_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (workOrderNumber.isNotEmpty)
        'work_order_number': workOrderNumber,
      'machine_id': machineId,
      if (maintenancePlanId != null) 'maintenance_plan_id': maintenancePlanId,
      if (assignedUserId != null) 'assigned_user_id': assignedUserId,
      if (scheduledDate != null)
        'scheduled_date': scheduledDate!.toIso8601String().split('T')[0],
      if (startedAt != null) 'started_at': startedAt!.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
      'status': status,
      'priority': priority,
      'problem_description': problemDescription,
      'action_taken': actionTaken,
      'root_cause': rootCause,
      'downtime_minutes': downtimeMinutes,
      'technician_notes': technicianNotes,
      'supervisor_notes': supervisorNotes,
      if (verifiedBy != null) 'verified_by': verifiedBy,
      if (verifiedAt != null) 'verified_at': verifiedAt!.toIso8601String(),
      'is_sync_complete': isSyncComplete,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'work_order_number': workOrderNumber,
      'machine_id': machineId,
      'maintenance_plan_id': maintenancePlanId,
      'assigned_user_id': assignedUserId,
      'scheduled_date': scheduledDate?.toIso8601String().split('T')[0],
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'status': status,
      'priority': priority,
      'problem_description': problemDescription,
      'action_taken': actionTaken,
      'root_cause': rootCause,
      'downtime_minutes': downtimeMinutes,
      'technician_notes': technicianNotes,
      'supervisor_notes': supervisorNotes,
      'verified_by': verifiedBy,
      'verified_at': verifiedAt?.toIso8601String(),
      'is_sync_complete': isSyncComplete ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory WorkOrder.fromMap(Map<String, dynamic> map) {
    return WorkOrder(
      id: map['id'] as String? ?? '',
      workOrderNumber: map['work_order_number'] as String? ?? '',
      machineId: map['machine_id'] as String? ?? '',
      maintenancePlanId: map['maintenance_plan_id'] as String?,
      assignedUserId: map['assigned_user_id'] as String?,
      scheduledDate: map['scheduled_date'] != null
          ? DateTime.tryParse(map['scheduled_date'] as String)
          : null,
      startedAt: map['started_at'] != null
          ? DateTime.tryParse(map['started_at'] as String)
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'] as String)
          : null,
      status: map['status'] as String? ?? 'OPEN',
      priority: map['priority'] as String? ?? 'medium',
      problemDescription: map['problem_description'] as String? ?? '',
      actionTaken: map['action_taken'] as String? ?? '',
      rootCause: map['root_cause'] as String? ?? '',
      downtimeMinutes: map['downtime_minutes'] as int? ?? 0,
      technicianNotes: map['technician_notes'] as String? ?? '',
      supervisorNotes: map['supervisor_notes'] as String? ?? '',
      verifiedBy: map['verified_by'] as String?,
      verifiedAt: map['verified_at'] != null
          ? DateTime.tryParse(map['verified_at'] as String)
          : null,
      isSyncComplete: (map['is_sync_complete'] == 1 ||
          map['is_sync_complete'] == true),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  WorkOrder copyWith({
    String? id,
    String? workOrderNumber,
    String? machineId,
    String? maintenancePlanId,
    String? assignedUserId,
    DateTime? scheduledDate,
    DateTime? startedAt,
    DateTime? completedAt,
    String? status,
    String? priority,
    String? problemDescription,
    String? actionTaken,
    String? rootCause,
    int? downtimeMinutes,
    String? technicianNotes,
    String? supervisorNotes,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool? isSyncComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? machineName,
    String? machineCode,
    String? assignedUserName,
    bool clearMaintenancePlanId = false,
    bool clearAssignedUserId = false,
    bool clearVerifiedBy = false,
    bool clearScheduledDate = false,
    bool clearStartedAt = false,
    bool clearCompletedAt = false,
  }) {
    return WorkOrder(
      id: id ?? this.id,
      workOrderNumber: workOrderNumber ?? this.workOrderNumber,
      machineId: machineId ?? this.machineId,
      maintenancePlanId: clearMaintenancePlanId
          ? null
          : (maintenancePlanId ?? this.maintenancePlanId),
      assignedUserId: clearAssignedUserId
          ? null
          : (assignedUserId ?? this.assignedUserId),
      scheduledDate:
          clearScheduledDate ? null : (scheduledDate ?? this.scheduledDate),
      startedAt: clearStartedAt ? null : (startedAt ?? this.startedAt),
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      status: status ?? this.status,
      priority: priority ?? this.priority,
      problemDescription: problemDescription ?? this.problemDescription,
      actionTaken: actionTaken ?? this.actionTaken,
      rootCause: rootCause ?? this.rootCause,
      downtimeMinutes: downtimeMinutes ?? this.downtimeMinutes,
      technicianNotes: technicianNotes ?? this.technicianNotes,
      supervisorNotes: supervisorNotes ?? this.supervisorNotes,
      verifiedBy:
          clearVerifiedBy ? null : (verifiedBy ?? this.verifiedBy),
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isSyncComplete: isSyncComplete ?? this.isSyncComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      machineName: machineName ?? this.machineName,
      machineCode: machineCode ?? this.machineCode,
      assignedUserName: assignedUserName ?? this.assignedUserName,
    );
  }

  bool get isOpen => status == 'OPEN';
  bool get isAssigned => status == 'ASSIGNED';
  bool get isInProgress => status == 'IN_PROGRESS';
  bool get isPaused => status == 'PAUSED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isVerified => status == 'VERIFIED';
  bool get isCancelled => status == 'CANCELLED';
  bool get isActive =>
      status == 'OPEN' ||
      status == 'ASSIGNED' ||
      status == 'IN_PROGRESS' ||
      status == 'PAUSED';

  String get statusLabel {
    switch (status) {
      case 'OPEN':
        return 'Open';
      case 'ASSIGNED':
        return 'Assigned';
      case 'IN_PROGRESS':
        return 'In Progress';
      case 'PAUSED':
        return 'Paused';
      case 'COMPLETED':
        return 'Completed';
      case 'VERIFIED':
        return 'Verified';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  String toString() =>
      'WorkOrder(id: $id, number: $workOrderNumber, status: $status)';
}
