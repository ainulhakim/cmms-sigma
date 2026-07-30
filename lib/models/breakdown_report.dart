class BreakdownReport {
  final String id;
  final String machineId;
  final String? workOrderId;
  final String? reportedBy;
  final DateTime breakdownTime;
  final DateTime? downtimeStart;
  final DateTime? downtimeEnd;
  final int totalDowntimeMinutes;
  final String symptom;
  final String rootCause;
  final String impact;
  final String actionTaken;
  final bool isResolved;
  final DateTime? resolvedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Transient fields
  String? machineName;
  String? machineCode;
  String? reportedByName;

  BreakdownReport({
    required this.id,
    required this.machineId,
    this.workOrderId,
    this.reportedBy,
    required this.breakdownTime,
    this.downtimeStart,
    this.downtimeEnd,
    this.totalDowntimeMinutes = 0,
    this.symptom = '',
    this.rootCause = '',
    this.impact = '',
    this.actionTaken = '',
    this.isResolved = false,
    this.resolvedAt,
    this.createdAt,
    this.updatedAt,
    this.machineName,
    this.machineCode,
    this.reportedByName,
  });

  factory BreakdownReport.fromJson(Map<String, dynamic> json) {
    return BreakdownReport(
      id: json['id'] as String? ?? '',
      machineId: json['machine_id'] as String? ?? '',
      workOrderId: json['work_order_id'] as String?,
      reportedBy: json['reported_by'] as String?,
      breakdownTime: json['breakdown_time'] != null
          ? DateTime.parse(json['breakdown_time'] as String)
          : DateTime.now(),
      downtimeStart: json['downtime_start'] != null
          ? DateTime.tryParse(json['downtime_start'] as String)
          : null,
      downtimeEnd: json['downtime_end'] != null
          ? DateTime.tryParse(json['downtime_end'] as String)
          : null,
      totalDowntimeMinutes: json['total_downtime_minutes'] as int? ?? 0,
      symptom: json['symptom'] as String? ?? '',
      rootCause: json['root_cause'] as String? ?? '',
      impact: json['impact'] as String? ?? '',
      actionTaken: json['action_taken'] as String? ?? '',
      isResolved: json['is_resolved'] as bool? ?? false,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.tryParse(json['resolved_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      machineName: json['machine_name'] as String?,
      machineCode: json['machine_code'] as String?,
      reportedByName: json['reported_by_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'machine_id': machineId,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (reportedBy != null) 'reported_by': reportedBy,
      'breakdown_time': breakdownTime.toIso8601String(),
      if (downtimeStart != null)
        'downtime_start': downtimeStart!.toIso8601String(),
      if (downtimeEnd != null)
        'downtime_end': downtimeEnd!.toIso8601String(),
      'total_downtime_minutes': totalDowntimeMinutes,
      'symptom': symptom,
      'root_cause': rootCause,
      'impact': impact,
      'action_taken': actionTaken,
      'is_resolved': isResolved,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'machine_id': machineId,
      'work_order_id': workOrderId,
      'reported_by': reportedBy,
      'breakdown_time': breakdownTime.toIso8601String(),
      'downtime_start': downtimeStart?.toIso8601String(),
      'downtime_end': downtimeEnd?.toIso8601String(),
      'total_downtime_minutes': totalDowntimeMinutes,
      'symptom': symptom,
      'root_cause': rootCause,
      'impact': impact,
      'action_taken': actionTaken,
      'is_resolved': isResolved ? 1 : 0,
      'resolved_at': resolvedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory BreakdownReport.fromMap(Map<String, dynamic> map) {
    return BreakdownReport(
      id: map['id'] as String? ?? '',
      machineId: map['machine_id'] as String? ?? '',
      workOrderId: map['work_order_id'] as String?,
      reportedBy: map['reported_by'] as String?,
      breakdownTime: map['breakdown_time'] != null
          ? DateTime.parse(map['breakdown_time'] as String)
          : DateTime.now(),
      downtimeStart: map['downtime_start'] != null
          ? DateTime.tryParse(map['downtime_start'] as String)
          : null,
      downtimeEnd: map['downtime_end'] != null
          ? DateTime.tryParse(map['downtime_end'] as String)
          : null,
      totalDowntimeMinutes: map['total_downtime_minutes'] as int? ?? 0,
      symptom: map['symptom'] as String? ?? '',
      rootCause: map['root_cause'] as String? ?? '',
      impact: map['impact'] as String? ?? '',
      actionTaken: map['action_taken'] as String? ?? '',
      isResolved: (map['is_resolved'] == 1 || map['is_resolved'] == true),
      resolvedAt: map['resolved_at'] != null
          ? DateTime.tryParse(map['resolved_at'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  BreakdownReport copyWith({
    String? id,
    String? machineId,
    String? workOrderId,
    String? reportedBy,
    DateTime? breakdownTime,
    DateTime? downtimeStart,
    DateTime? downtimeEnd,
    int? totalDowntimeMinutes,
    String? symptom,
    String? rootCause,
    String? impact,
    String? actionTaken,
    bool? isResolved,
    DateTime? resolvedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? machineName,
    String? machineCode,
    String? reportedByName,
    bool clearWorkOrderId = false,
    bool clearReportedBy = false,
    bool clearDowntimeStart = false,
    bool clearDowntimeEnd = false,
  }) {
    return BreakdownReport(
      id: id ?? this.id,
      machineId: machineId ?? this.machineId,
      workOrderId:
          clearWorkOrderId ? null : (workOrderId ?? this.workOrderId),
      reportedBy: clearReportedBy ? null : (reportedBy ?? this.reportedBy),
      breakdownTime: breakdownTime ?? this.breakdownTime,
      downtimeStart:
          clearDowntimeStart ? null : (downtimeStart ?? this.downtimeStart),
      downtimeEnd:
          clearDowntimeEnd ? null : (downtimeEnd ?? this.downtimeEnd),
      totalDowntimeMinutes:
          totalDowntimeMinutes ?? this.totalDowntimeMinutes,
      symptom: symptom ?? this.symptom,
      rootCause: rootCause ?? this.rootCause,
      impact: impact ?? this.impact,
      actionTaken: actionTaken ?? this.actionTaken,
      isResolved: isResolved ?? this.isResolved,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      machineName: machineName ?? this.machineName,
      machineCode: machineCode ?? this.machineCode,
      reportedByName: reportedByName ?? this.reportedByName,
    );
  }

  Duration get downtimeDuration {
    if (downtimeStart != null && downtimeEnd != null) {
      return downtimeEnd!.difference(downtimeStart!);
    }
    return Duration.zero;
  }

  @override
  String toString() =>
      'BreakdownReport(id: $id, machine: $machineId, resolved: $isResolved)';
}
