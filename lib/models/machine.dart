class Machine {
  final String id;
  final String machineCode;
  final String machineName;
  final String machineNo;
  final String? categoryId;
  final String line;
  final String location;
  final String manufacturer;
  final String model;
  final String serialNumber;
  final DateTime? installationDate;
  final String status; // active, inactive, under_maintenance, broken_down, retired
  final String photoUrl;
  final Map<String, dynamic> specifications;
  final int operatingHours;
  final int productionCount;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Machine({
    required this.id,
    required this.machineCode,
    required this.machineName,
    this.machineNo = '',
    this.categoryId,
    this.line = '',
    this.location = '',
    this.manufacturer = '',
    this.model = '',
    this.serialNumber = '',
    this.installationDate,
    this.status = 'active',
    this.photoUrl = '',
    this.specifications = const {},
    this.operatingHours = 0,
    this.productionCount = 0,
    this.notes = '',
    this.createdAt,
    this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'] as String? ?? '',
      machineCode: json['machine_code'] as String? ?? '',
      machineName: json['machine_name'] as String? ?? '',
      machineNo: json['machine_no'] as String? ?? '',
      categoryId: json['category_id'] as String?,
      line: json['line'] as String? ?? '',
      location: json['location'] as String? ?? '',
      manufacturer: json['manufacturer'] as String? ?? '',
      model: json['model'] as String? ?? '',
      serialNumber: json['serial_number'] as String? ?? '',
      installationDate: json['installation_date'] != null
          ? DateTime.tryParse(json['installation_date'] as String)
          : null,
      status: json['status'] as String? ?? 'active',
      photoUrl: json['photo_url'] as String? ?? '',
      specifications: json['specifications'] is Map
          ? Map<String, dynamic>.from(json['specifications'])
          : {},
      operatingHours: json['operating_hours'] as int? ?? 0,
      productionCount: json['production_count'] as int? ?? 0,
      notes: json['notes'] as String? ?? '',
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
      'machine_code': machineCode,
      'machine_name': machineName,
      'machine_no': machineNo,
      if (categoryId != null) 'category_id': categoryId,
      'line': line,
      'location': location,
      'manufacturer': manufacturer,
      'model': model,
      'serial_number': serialNumber,
      if (installationDate != null)
        'installation_date': installationDate!.toIso8601String().split('T')[0],
      'status': status,
      'photo_url': photoUrl,
      'specifications': specifications,
      'operating_hours': operatingHours,
      'production_count': productionCount,
      'notes': notes,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'machine_code': machineCode,
      'machine_name': machineName,
      'machine_no': machineNo,
      'category_id': categoryId,
      'line': line,
      'location': location,
      'manufacturer': manufacturer,
      'model': model,
      'serial_number': serialNumber,
      'installation_date': installationDate?.toIso8601String().split('T')[0],
      'status': status,
      'photo_url': photoUrl,
      'specifications': specifications.toString(),
      'operating_hours': operatingHours,
      'production_count': productionCount,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Machine.fromMap(Map<String, dynamic> map) {
    return Machine(
      id: map['id'] as String? ?? '',
      machineCode: map['machine_code'] as String? ?? '',
      machineName: map['machine_name'] as String? ?? '',
      machineNo: map['machine_no'] as String? ?? '',
      categoryId: map['category_id'] as String?,
      line: map['line'] as String? ?? '',
      location: map['location'] as String? ?? '',
      manufacturer: map['manufacturer'] as String? ?? '',
      model: map['model'] as String? ?? '',
      serialNumber: map['serial_number'] as String? ?? '',
      installationDate: map['installation_date'] != null
          ? DateTime.tryParse(map['installation_date'] as String)
          : null,
      status: map['status'] as String? ?? 'active',
      photoUrl: map['photo_url'] as String? ?? '',
      specifications: {},
      operatingHours: map['operating_hours'] as int? ?? 0,
      productionCount: map['production_count'] as int? ?? 0,
      notes: map['notes'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  Machine copyWith({
    String? id,
    String? machineCode,
    String? machineName,
    String? machineNo,
    String? categoryId,
    String? line,
    String? location,
    String? manufacturer,
    String? model,
    String? serialNumber,
    DateTime? installationDate,
    String? status,
    String? photoUrl,
    Map<String, dynamic>? specifications,
    int? operatingHours,
    int? productionCount,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearCategoryId = false,
  }) {
    return Machine(
      id: id ?? this.id,
      machineCode: machineCode ?? this.machineCode,
      machineName: machineName ?? this.machineName,
      machineNo: machineNo ?? this.machineNo,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      line: line ?? this.line,
      location: location ?? this.location,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      installationDate: installationDate ?? this.installationDate,
      status: status ?? this.status,
      photoUrl: photoUrl ?? this.photoUrl,
      specifications: specifications ?? this.specifications,
      operatingHours: operatingHours ?? this.operatingHours,
      productionCount: productionCount ?? this.productionCount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'Machine(id: $id, code: $machineCode, name: $machineName, status: $status)';
}
