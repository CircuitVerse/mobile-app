class Notification {
  Notification({
    required this.id,
    required this.type,
    required this.attributes,
  });

  String id;
  String type;
  NotificationAttributes attributes;

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      type: json['type'],
      attributes: NotificationAttributes.fromJson(json['attributes']),
    );
  }
}

class NotificationAttributes {
  NotificationAttributes({
    required this.recipientType,
    required this.recipientId,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
    required this.params,
    required this.unread,
  });

  String recipientType;
  int recipientId;
  bool unread;
  DateTime? readAt;
  DateTime createdAt;
  DateTime updatedAt;
  NotificationParams params;

  factory NotificationAttributes.fromJson(Map<String, dynamic> json) {
    return NotificationAttributes(
      recipientType: json['recipient_type'],
      recipientId: json['recipient_id'],
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      params: NotificationParams.fromJson(json['params']),
      unread: json['unread'],
    );
  }
}

class NotificationParams {
  NotificationParams({
    required this.userId,
    required this.projectId,
  });

  int userId, projectId;

  factory NotificationParams.fromJson(Map<String, dynamic> json) {
    return NotificationParams(
      userId: json['user_id'],
      projectId: json['project_id'],
    );
  }
}
