class WorkOrderPhoto {
  final String id;
  final String workOrderId;
  final String photoUrl;
  final String thumbnailUrl;
  final String caption;
  final String photoType; // general, before, after, problem, signature
  final String? takenBy;
  final DateTime? takenAt;
  final DateTime? createdAt;

  WorkOrderPhoto({
    required this.id,
    required this.workOrderId,
    required this.photoUrl,
    this.thumbnailUrl = '',
    this.caption = '',
    this.photoType = 'general',
    this.takenBy,
    this.takenAt,
    this.createdAt,
  });

  factory WorkOrderPhoto.fromJson(Map<String, dynamic> json) {
    return WorkOrderPhoto(
      id: json['id'] as String? ?? '',
      workOrderId: json['work_order_id'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      photoType: json['photo_type'] as String? ?? 'general',
      takenBy: json['taken_by'] as String?,
      takenAt: json['taken_at'] != null
          ? DateTime.tryParse(json['taken_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'work_order_id': workOrderId,
      'photo_url': photoUrl,
      'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'photo_type': photoType,
      if (takenBy != null) 'taken_by': takenBy,
      if (takenAt != null) 'taken_at': takenAt!.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'work_order_id': workOrderId,
      'photo_url': photoUrl,
      'thumbnail_url': thumbnailUrl,
      'caption': caption,
      'photo_type': photoType,
      'taken_by': takenBy,
      'taken_at': takenAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory WorkOrderPhoto.fromMap(Map<String, dynamic> map) {
    return WorkOrderPhoto(
      id: map['id'] as String? ?? '',
      workOrderId: map['work_order_id'] as String? ?? '',
      photoUrl: map['photo_url'] as String? ?? '',
      thumbnailUrl: map['thumbnail_url'] as String? ?? '',
      caption: map['caption'] as String? ?? '',
      photoType: map['photo_type'] as String? ?? 'general',
      takenBy: map['taken_by'] as String?,
      takenAt: map['taken_at'] != null
          ? DateTime.tryParse(map['taken_at'] as String)
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  WorkOrderPhoto copyWith({
    String? id,
    String? workOrderId,
    String? photoUrl,
    String? thumbnailUrl,
    String? caption,
    String? photoType,
    String? takenBy,
    DateTime? takenAt,
    DateTime? createdAt,
  }) {
    return WorkOrderPhoto(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      photoUrl: photoUrl ?? this.photoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      photoType: photoType ?? this.photoType,
      takenBy: takenBy ?? this.takenBy,
      takenAt: takenAt ?? this.takenAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'WorkOrderPhoto(id: $id, type: $photoType, url: $photoUrl)';
}
