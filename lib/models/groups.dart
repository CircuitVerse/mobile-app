import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/services/local_storage_service.dart';

class Groups {
  List<Group> data;
  Links links;
  Groups({
    this.data,
    this.links,
  });


  factory Groups.fromJson(Map<String, dynamic> json) => Groups(
        data: List<Group>.from(json['data'].map((x) => Group.fromJson(x))),
        links: Links.fromJson(json['links']),
      );
}

class Group {
  String id;
  String type;
  GroupAttributes attributes;
  List<GroupMember> groupMembers;
  List<Assignment> assignments;
  Group({
    this.id,
    this.type,
    this.attributes,
    this.groupMembers,
    this.assignments,
  });


  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['id'] ?? json['data']['id'],
        type: json['type'] ?? json['data']['type'],
        attributes: GroupAttributes.fromJson(
            json['attributes'] ?? json['data']['attributes']),
        groupMembers: json['included'] != null
            ? List<GroupMember>.from(
                json['included']
                    ?.where((e) => e['type'] == 'group_member')
                    ?.map((e) => GroupMember.fromJson(e)),
              )
            : null,
        assignments: json['included'] != null
            ? List<Assignment>.from(
                json['included']
                    ?.where((e) => e['type'] == 'assignment')
                    ?.map((e) => Assignment.fromJson(e)),
              )
            : null,
      );

  // returns true if the logged in user is mentor for this group
  bool get isMentor => locator<LocalStorageService>().currentUser.data.id ==
          attributes.mentorId.toString()
      ? true
      : false;
}

class GroupAttributes {
  int memberCount;
  String mentorName;
  String name;
  int mentorId;
  DateTime createdAt;
  DateTime updatedAt;
  GroupAttributes({
    this.memberCount,
    this.mentorName,
    this.name,
    this.mentorId,
    this.createdAt,
    this.updatedAt,
  });


  factory GroupAttributes.fromJson(Map<String, dynamic> json) =>
      GroupAttributes(
        memberCount: json['member_count'],
        mentorName: json['mentor_name'],
        name: json['name'],
        mentorId: json['mentor_id'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );
}
