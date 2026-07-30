class MachineModel {
  final String id;
  final String name;
  final String code;
  final String line;
  final String status;
  final String? location;
  final String? description;
  final String? imageUrl;
  final DateTime? lastMaintenance;
  final DateTime? nextMaintenance;

  MachineModel({
    required this.id,
    required this.name,
    required this.code,
    required this.line,
    required this.status,
    this.location,
    this.description,
    this.imageUrl,
    this.lastMaintenance,
    this.nextMaintenance,
  });

  factory MachineModel.fromMap(Map<String, dynamic> map) {
    return MachineModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      code: map['code']?.toString() ?? '',
      line: map['line']?.toString() ?? '',
      status: map['status']?.toString() ?? 'Active',
      location: map['location']?.toString(),
      description: map['description']?.toString(),
      imageUrl: map['image_url']?.toString(),
      lastMaintenance: map['last_maintenance'] != null
          ? DateTime.tryParse(map['last_maintenance'].toString())
          : null,
      nextMaintenance: map['next_maintenance'] != null
          ? DateTime.tryParse(map['next_maintenance'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'line': line,
      'status': status,
      'location': location,
      'description': description,
      'image_url': imageUrl,
      'last_maintenance': lastMaintenance?.toIso8601String(),
      'next_maintenance': nextMaintenance?.toIso8601String(),
    };
  }
}
