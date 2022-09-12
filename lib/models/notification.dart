import 'package:mobile_app/models/user.dart';

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
    required this.type,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
    required this.params,
    required this.unread,
  });

  String recipientType;
  int recipientId;
  String type;
  bool unread;
  DateTime? readAt;
  DateTime createdAt;
  DateTime updatedAt;
  NotificationParams params;

  factory NotificationAttributes.fromJson(Map<String, dynamic> json) {
    return NotificationAttributes(
      recipientType: json['recipient_type'],
      recipientId: json['recipient_id'],
      type: json['type'],
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
    required this.user,
    required this.project,
  });

  final User user;
  final Project project;

  factory NotificationParams.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> mp = {};
    mp['id'] = json['user']['id'].toString();
    mp['attributes'] = json['user'];
    return NotificationParams(
      user: User.fromJson({
        'data': mp,
      }),
      project: Project.fromJson(json['project']),
    );
  }
}

class Project {
  Project({
    required this.id,
    required this.authorId,
    required this.accessType,
    required this.name,
    required this.projectSubmission,
    this.createdAt,
    this.updatedAt,
    required this.description,
    required this.slug,
    required this.view,
    this.imagePreview,
  });

  final int id, authorId, view;
  final String name, accessType, description, slug;
  final DateTime? createdAt, updatedAt;
  final bool projectSubmission;
  final Map<String, dynamic>? imagePreview;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      authorId: json['author_id'],
      accessType: json['project_access_type'],
      name: json['name'],
      projectSubmission: json['project_submission'],
      description: json['description'],
      slug: json['slug'],
      view: json['view'],
      imagePreview: json['image_preview'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
