import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/models/links.dart';

import '../setup/test_data/mock_groups.dart';

void main() {
  group('GroupsTest -', () {
    test('GroupsTest fromJson', () {
      var _groups = Groups.fromJson(mockGroups);

      expect(_groups, isInstanceOf<Groups>());

      expect(_groups.data, isInstanceOf<List<Group>>());
      expect(_groups.data.length, 1);

      expect(_groups.links, isInstanceOf<Links>());
    });

    test('GroupTest', () async {
      var _group = Group.fromJson(mockGroup);

      expect(_group, isInstanceOf<Group>());

      expect(_group.id, '1');
      expect(_group.type, 'group');
      expect(_group.attributes, isInstanceOf<GroupAttributes>());
      expect(_group.groupMembers, isInstanceOf<List<GroupMember>>());
      expect(_group.groupMembers.length, 1);
      expect(_group.assignments, isInstanceOf<List<Assignment>>());
      expect(_group.assignments.length, 1);
    });

    test('GroupAttributesTest fromJson', () {
      var _groupAttributes = GroupAttributes.fromJson(mockGroupAttributes);

      expect(_groupAttributes, isInstanceOf<GroupAttributes>());

      expect(_groupAttributes.memberCount, 1);
      expect(_groupAttributes.mentorName, 'Test User');
      expect(_groupAttributes.name, 'Test Group');
      expect(_groupAttributes.mentorId, 1);
      expect(_groupAttributes.createdAt,
          DateTime.parse('2020-08-15T05:49:56.433Z'));
      expect(_groupAttributes.updatedAt,
          DateTime.parse('2020-08-15T17:21:13.813Z'));
    });
  });
}
