class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String notificationType; // work_order_assigned, work_order_completed, maintenance_due, breakdown_report, system
  final String referenceType;
  final String? referenceId;
  final bool isRead;
  final DateTime? readAt;
  final String actionUrl;
  final String imageUrl;
  final Map<String, dynamic> data;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    this.body = '',
    this.notificationType = 'system',
    this.referenceType = '',
    this.referenceId,
    this.isRead = false,
    this.readAt,
    this.actionUrl = '',
    this.imageUrl = '',
    this.data = const {},
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      notificationType:
          json['notification_type'] as String? ?? 'system',
      referenceType: json['reference_type'] as String? ?? '',
      referenceId: json['reference_id'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'] as String)
          : null,
      actionUrl: json['action_url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'])
          : {},
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'notification_type': notificationType,
      'reference_type': referenceType,
      if (referenceId != null) 'reference_id': referenceId,
      'is_read': isRead,
      if (readAt != null) 'read_at': readAt!.toIso8601String(),
      'action_url': actionUrl,
      'image_url': imageUrl,
      'data': data,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'notification_type': notificationType,
      'reference_type': referenceType,
      'reference_id': referenceId,
      'is_read': isRead ? 1 : 0,
      'read_at': readAt?.toIso8601String(),
      'action_url': actionUrl,
      'image_url': imageUrl,
      'data': data.toString(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      notificationType:
          map['notification_type'] as String? ?? 'system',
      referenceType: map['reference_type'] as String? ?? '',
      referenceId: map['reference_id'] as String?,
      isRead: (map['is_read'] == 1 || map['is_read'] == true),
      readAt: map['read_at'] != null
          ? DateTime.tryParse(map['read_at'] as String)
          : null,
      actionUrl: map['action_url'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      data: {},
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? notificationType,
    String? referenceType,
    String? referenceId,
    bool? isRead,
    DateTime? readAt,
    String? actionUrl,
    String? imageUrl,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      notificationType: notificationType ?? this.notificationType,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  NotificationModel markAsRead() {
    return copyWith(isRead: true, readAt: DateTime.now());
  }

  @override
  String toString() =>
      'NotificationModel(id: $id, title: $title, read: $isRead)';
}
