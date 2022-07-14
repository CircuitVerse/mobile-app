import 'package:mobile_app/models/links.dart';

class GroupMembers {
  factory GroupMembers.fromJson(Map<String, dynamic> json) => GroupMembers(
        data: List<GroupMember>.from(
            json['data'].map((x) => GroupMember.fromJson(x))),
        links: Links.fromJson(json['links']),
      );

  GroupMembers({
    required this.data,
    required this.links,
  });
  List<GroupMember> data;
  Links links;
}

class GroupMember {
  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
        id: json['id'],
        type: json['type'],
        attributes: GroupMemberAttributes.fromJson(json['attributes']),
      );

  GroupMember({
    required this.id,
    required this.type,
    required this.attributes,
  });
  String id;
  String type;
  GroupMemberAttributes attributes;
}

class GroupMemberAttributes {
  factory GroupMemberAttributes.fromJson(Map<String, dynamic> json) =>
      GroupMemberAttributes(
        groupId: json['group_id'],
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        mentor: json['mentor'] ?? false,
        name: json['name'],
        email: json['email'],
      );

  GroupMemberAttributes({
    required this.groupId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.mentor,
    this.name,
    this.email,
  });
  int groupId;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  String? name;
  String? email;
  bool mentor;
}
