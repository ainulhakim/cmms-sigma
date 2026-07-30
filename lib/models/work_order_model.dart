class WorkOrderModel {
  final String id;
  final String woNumber;
  final String machineId;
  final String machineName;
  final String machineCode;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String type;
  final String? assignedTo;
  final String? assignedToName;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final String? supervisorNotes;
  final String? supervisorId;
  final String? supervisorName;
  final bool isVerified;
  final List<ChecklistItem> checklistItems;
  final List<SparePartUsage> spareParts;
  final List<String> photoBeforeUrls;
  final List<String> photoAfterUrls;
  final String? createdBy;
  final DateTime createdAt;

  WorkOrderModel({
    required this.id,
    required this.woNumber,
    required this.machineId,
    required this.machineName,
    required this.machineCode,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.type,
    this.assignedTo,
    this.assignedToName,
    this.scheduledStart,
    this.scheduledEnd,
    this.startedAt,
    this.completedAt,
    this.notes,
    this.supervisorNotes,
    this.supervisorId,
    this.supervisorName,
    this.isVerified = false,
    this.checklistItems = const [],
    this.spareParts = const [],
    this.photoBeforeUrls = const [],
    this.photoAfterUrls = const [],
    this.createdBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory WorkOrderModel.fromMap(Map<String, dynamic> map) {
    return WorkOrderModel(
      id: map['id']?.toString() ?? '',
      woNumber: map['wo_number']?.toString() ?? '',
      machineId: map['machine_id']?.toString() ?? '',
      machineName: map['machine_name']?.toString() ?? '',
      machineCode: map['machine_code']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      status: map['status']?.toString() ?? 'OPEN',
      priority: map['priority']?.toString() ?? 'MEDIUM',
      type: map['type']?.toString() ?? 'ROUTINE',
      assignedTo: map['assigned_to']?.toString(),
      assignedToName: map['assigned_to_name']?.toString(),
      scheduledStart: map['scheduled_start'] != null
          ? DateTime.tryParse(map['scheduled_start'].toString())
          : null,
      scheduledEnd: map['scheduled_end'] != null
          ? DateTime.tryParse(map['scheduled_end'].toString())
          : null,
      startedAt: map['started_at'] != null
          ? DateTime.tryParse(map['started_at'].toString())
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'].toString())
          : null,
      notes: map['notes']?.toString(),
      supervisorNotes: map['supervisor_notes']?.toString(),
      supervisorId: map['supervisor_id']?.toString(),
      supervisorName: map['supervisor_name']?.toString(),
      isVerified: map['is_verified'] == true,
      checklistItems: (map['checklist_items'] as List<dynamic>?)
              ?.map((e) => ChecklistItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      spareParts: (map['spare_parts'] as List<dynamic>?)
              ?.map((e) => SparePartUsage.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      photoBeforeUrls: (map['photo_before_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      photoAfterUrls: (map['photo_after_urls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdBy: map['created_by']?.toString(),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wo_number': woNumber,
      'machine_id': machineId,
      'machine_name': machineName,
      'machine_code': machineCode,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'type': type,
      'assigned_to': assignedTo,
      'assigned_to_name': assignedToName,
      'scheduled_start': scheduledStart?.toIso8601String(),
      'scheduled_end': scheduledEnd?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'notes': notes,
      'supervisor_notes': supervisorNotes,
      'supervisor_id': supervisorId,
      'supervisor_name': supervisorName,
      'is_verified': isVerified,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class ChecklistItem {
  final String id;
  final String name;
  bool isChecked;
  String? measurementValue;
  String? notes;

  ChecklistItem({
    required this.id,
    required this.name,
    this.isChecked = false,
    this.measurementValue,
    this.notes,
  });

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      isChecked: map['is_checked'] == true,
      measurementValue: map['measurement_value']?.toString(),
      notes: map['notes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_checked': isChecked,
      'measurement_value': measurementValue,
      'notes': notes,
    };
  }
}

class SparePartUsage {
  final String id;
  final String partName;
  final String partCode;
  int quantity;
  String? notes;

  SparePartUsage({
    required this.id,
    required this.partName,
    required this.partCode,
    this.quantity = 1,
    this.notes,
  });

  factory SparePartUsage.fromMap(Map<String, dynamic> map) {
    return SparePartUsage(
      id: map['id']?.toString() ?? '',
      partName: map['part_name']?.toString() ?? '',
      partCode: map['part_code']?.toString() ?? '',
      quantity: map['quantity'] as int? ?? 1,
      notes: map['notes']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'part_name': partName,
      'part_code': partCode,
      'quantity': quantity,
      'notes': notes,
    };
  }
}

class MaintenanceHistoryItem {
  final String id;
  final String woNumber;
  final String machineId;
  final String type;
  final String status;
  final String? technicianName;
  final DateTime? completedAt;
  final Duration? duration;

  MaintenanceHistoryItem({
    required this.id,
    required this.woNumber,
    required this.machineId,
    required this.type,
    required this.status,
    this.technicianName,
    this.completedAt,
    this.duration,
  });

  factory MaintenanceHistoryItem.fromMap(Map<String, dynamic> map) {
    return MaintenanceHistoryItem(
      id: map['id']?.toString() ?? '',
      woNumber: map['wo_number']?.toString() ?? '',
      machineId: map['machine_id']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      status: map['status']?.toString() ?? '',
      technicianName: map['technician_name']?.toString(),
      completedAt: map['completed_at'] != null
          ? DateTime.tryParse(map['completed_at'].toString())
          : null,
      duration: map['duration_minutes'] != null
          ? Duration(minutes: map['duration_minutes'] as int)
          : null,
    );
  }
}

class BreakdownReportModel {
  final String? id;
  final String machineId;
  final String machineName;
  final String problemDescription;
  final String priority;
  final bool productionStoppage;
  final String reporterName;
  final String? photoUrl;
  final DateTime reportedAt;

  BreakdownReportModel({
    this.id,
    required this.machineId,
    required this.machineName,
    required this.problemDescription,
    required this.priority,
    required this.productionStoppage,
    required this.reporterName,
    this.photoUrl,
    DateTime? reportedAt,
  }) : reportedAt = reportedAt ?? DateTime.now();

  factory BreakdownReportModel.fromMap(Map<String, dynamic> map) {
    return BreakdownReportModel(
      id: map['id']?.toString(),
      machineId: map['machine_id']?.toString() ?? '',
      machineName: map['machine_name']?.toString() ?? '',
      problemDescription: map['problem_description']?.toString() ?? '',
      priority: map['priority']?.toString() ?? 'HIGH',
      productionStoppage: map['production_stoppage'] == true,
      reporterName: map['reporter_name']?.toString() ?? '',
      photoUrl: map['photo_url']?.toString(),
      reportedAt: map['reported_at'] != null
          ? DateTime.tryParse(map['reported_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'machine_id': machineId,
      'machine_name': machineName,
      'problem_description': problemDescription,
      'priority': priority,
      'production_stoppage': productionStoppage,
      'reporter_name': reporterName,
      'photo_url': photoUrl,
      'reported_at': reportedAt.toIso8601String(),
    };
  }
}
