class SparePart {
  final String id;
  final String partCode;
  final String partName;
  final String description;
  final String category;
  final String unit;
  final int currentStock;
  final int minimumStock;
  final int maximumStock;
  final String location;
  final String supplier;
  final double unitPrice;
  final String photoUrl;
  final List<String> compatibleMachines;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SparePart({
    required this.id,
    required this.partCode,
    required this.partName,
    this.description = '',
    this.category = '',
    this.unit = 'pcs',
    this.currentStock = 0,
    this.minimumStock = 0,
    this.maximumStock = 0,
    this.location = '',
    this.supplier = '',
    this.unitPrice = 0,
    this.photoUrl = '',
    this.compatibleMachines = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SparePart.fromJson(Map<String, dynamic> json) {
    return SparePart(
      id: json['id'] as String? ?? '',
      partCode: json['part_code'] as String? ?? '',
      partName: json['part_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      unit: json['unit'] as String? ?? 'pcs',
      currentStock: json['current_stock'] as int? ?? 0,
      minimumStock: json['minimum_stock'] as int? ?? 0,
      maximumStock: json['maximum_stock'] as int? ?? 0,
      location: json['location'] as String? ?? '',
      supplier: json['supplier'] as String? ?? '',
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      photoUrl: json['photo_url'] as String? ?? '',
      compatibleMachines: _parseCompatibleMachines(json['compatible_machines']),
      isActive: json['is_active'] as bool? ?? true,
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
      'part_code': partCode,
      'part_name': partName,
      'description': description,
      'category': category,
      'unit': unit,
      'current_stock': currentStock,
      'minimum_stock': minimumStock,
      'maximum_stock': maximumStock,
      'location': location,
      'supplier': supplier,
      'unit_price': unitPrice,
      'photo_url': photoUrl,
      'compatible_machines': compatibleMachines,
      'is_active': isActive,
    };
  }

  static List<String> _parseCompatibleMachines(dynamic value) {
    if (value is List) return List<String>.from(value);
    if (value is String) {
      return value
          .split(',')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'part_code': partCode,
      'part_name': partName,
      'description': description,
      'category': category,
      'unit': unit,
      'current_stock': currentStock,
      'minimum_stock': minimumStock,
      'maximum_stock': maximumStock,
      'location': location,
      'supplier': supplier,
      'unit_price': unitPrice,
      'photo_url': photoUrl,
      'compatible_machines': compatibleMachines.join(','),
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory SparePart.fromMap(Map<String, dynamic> map) {
    return SparePart(
      id: map['id'] as String? ?? '',
      partCode: map['part_code'] as String? ?? '',
      partName: map['part_name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      unit: map['unit'] as String? ?? 'pcs',
      currentStock: map['current_stock'] as int? ?? 0,
      minimumStock: map['minimum_stock'] as int? ?? 0,
      maximumStock: map['maximum_stock'] as int? ?? 0,
      location: map['location'] as String? ?? '',
      supplier: map['supplier'] as String? ?? '',
      unitPrice: (map['unit_price'] as num?)?.toDouble() ?? 0,
      photoUrl: map['photo_url'] as String? ?? '',
      compatibleMachines: _parseCompatibleMachines(map['compatible_machines']),
      isActive: (map['is_active'] == 1 || map['is_active'] == true),
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'] as String)
          : null,
    );
  }

  SparePart copyWith({
    String? id,
    String? partCode,
    String? partName,
    String? description,
    String? category,
    String? unit,
    int? currentStock,
    int? minimumStock,
    int? maximumStock,
    String? location,
    String? supplier,
    double? unitPrice,
    String? photoUrl,
    List<String>? compatibleMachines,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SparePart(
      id: id ?? this.id,
      partCode: partCode ?? this.partCode,
      partName: partName ?? this.partName,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      location: location ?? this.location,
      supplier: supplier ?? this.supplier,
      unitPrice: unitPrice ?? this.unitPrice,
      photoUrl: photoUrl ?? this.photoUrl,
      compatibleMachines: compatibleMachines ?? this.compatibleMachines,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLowStock => currentStock <= minimumStock;
  bool get isOverStock =>
      maximumStock > 0 && currentStock > maximumStock;

  @override
  String toString() =>
      'SparePart(id: $id, code: $partCode, name: $partName, stock: $currentStock)';
}
