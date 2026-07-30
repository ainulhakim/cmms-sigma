class WorkOrderChecklistResult {
  final String id;
  final String workOrderId;
  final String? checklistItemId;
  final String itemName;
  final String itemType; // check, measure, text, yes_no, pass_fail
  final String resultValue;
  final bool? resultBool;
  final double? resultDecimal;
  final bool? isPassed;
  final String notes;
  final int sortOrder;
  final DateTime? createdAt;

  WorkOrderChecklistResult({
    required this.id,
    required this.workOrderId,
    this.checklistItemId,
    required this.itemName,
    this.itemType = 'check',
    this.resultValue = '',
    this.resultBool,
    this.resultDecimal,
    this.isPassed,
    this.notes = '',
    this.sortOrder = 0,
    this.createdAt,
  });

  factory WorkOrderChecklistResult.fromJson(Map<String, dynamic> json) {
    return WorkOrderChecklistResult(
      id: json['id'] as String? ?? '',
      workOrderId: json['work_order_id'] as String? ?? '',
      checklistItemId: json['checklist_item_id'] as String?,
      itemName: json['item_name'] as String? ?? '',
      itemType: json['item_type'] as String? ?? 'check',
      resultValue: json['result_value'] as String? ?? '',
      resultBool: json['result_bool'] as bool?,
      resultDecimal: json['result_decimal'] != null
          ? (json['result_decimal'] as num).toDouble()
          : null,
      isPassed: json['is_passed'] as bool?,
      notes: json['notes'] as String? ?? '',
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'work_order_id': workOrderId,
      if (checklistItemId != null) 'checklist_item_id': checklistItemId,
      'item_name': itemName,
      'item_type': itemType,
      'result_value': resultValue,
      if (resultBool != null) 'result_bool': resultBool,
      if (resultDecimal != null) 'result_decimal': resultDecimal,
      if (isPassed != null) 'is_passed': isPassed,
      'notes': notes,
      'sort_order': sortOrder,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'work_order_id': workOrderId,
      'checklist_item_id': checklistItemId,
      'item_name': itemName,
      'item_type': itemType,
      'result_value': resultValue,
      'result_bool': resultBool == true ? 1 : (resultBool == false ? 0 : null),
      'result_decimal': resultDecimal,
      'is_passed': isPassed == true ? 1 : (isPassed == false ? 0 : null),
      'notes': notes,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory WorkOrderChecklistResult.fromMap(Map<String, dynamic> map) {
    return WorkOrderChecklistResult(
      id: map['id'] as String? ?? '',
      workOrderId: map['work_order_id'] as String? ?? '',
      checklistItemId: map['checklist_item_id'] as String?,
      itemName: map['item_name'] as String? ?? '',
      itemType: map['item_type'] as String? ?? 'check',
      resultValue: map['result_value'] as String? ?? '',
      resultBool: map['result_bool'] is bool
          ? map['result_bool'] as bool
          : (map['result_bool'] as int?) == 1,
      resultDecimal: map['result_decimal'] != null
          ? (map['result_decimal'] as num).toDouble()
          : null,
      isPassed: map['is_passed'] is bool
          ? map['is_passed'] as bool
          : (map['is_passed'] as int?) == 1,
      notes: map['notes'] as String? ?? '',
      sortOrder: map['sort_order'] as int? ?? 0,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  WorkOrderChecklistResult copyWith({
    String? id,
    String? workOrderId,
    String? checklistItemId,
    String? itemName,
    String? itemType,
    String? resultValue,
    bool? resultBool,
    double? resultDecimal,
    bool? isPassed,
    String? notes,
    int? sortOrder,
    DateTime? createdAt,
    bool clearChecklistItemId = false,
  }) {
    return WorkOrderChecklistResult(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      checklistItemId: clearChecklistItemId
          ? null
          : (checklistItemId ?? this.checklistItemId),
      itemName: itemName ?? this.itemName,
      itemType: itemType ?? this.itemType,
      resultValue: resultValue ?? this.resultValue,
      resultBool: resultBool ?? this.resultBool,
      resultDecimal: resultDecimal ?? this.resultDecimal,
      isPassed: isPassed ?? this.isPassed,
      notes: notes ?? this.notes,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'WorkOrderChecklistResult(id: $id, item: $itemName, passed: $isPassed)';
}
