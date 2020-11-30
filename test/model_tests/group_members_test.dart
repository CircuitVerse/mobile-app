import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/models/links.dart';

import '../setup/test_data/mock_group_members.dart';

void main() {
  group('GroupMembersTest -', () {
    test('GroupMembersTest fromJson', () {
      var _groupMembers = GroupMembers.fromJson(mockGroupMembers);

      expect(_groupMembers, isInstanceOf<GroupMembers>());

      expect(_groupMembers.data, isInstanceOf<List<GroupMember>>());
      expect(_groupMembers.data.length, 1);

      expect(_groupMembers.links, isInstanceOf<Links>());
    });

    test('GroupMemberTest fromJson', () {
      var _groupMember = GroupMember.fromJson(mockGroupMember);

      expect(_groupMember, isInstanceOf<GroupMember>());

      expect(_groupMember.id, '1');
      expect(_groupMember.type, 'group_member');
      expect(_groupMember.attributes, isInstanceOf<GroupMemberAttributes>());
    });

    test('GroupMemberAttributesTest fromJson', () {
      var _groupMemberAttributes =
          GroupMemberAttributes.fromJson(mockGroupMemberAttributes);

      expect(_groupMemberAttributes, isInstanceOf<GroupMemberAttributes>());

      expect(_groupMemberAttributes.groupId, 1);
      expect(_groupMemberAttributes.userId, 1);
      expect(_groupMemberAttributes.createdAt,
          DateTime.parse('2020-08-15T14:36:38.228Z'));
      expect(_groupMemberAttributes.updatedAt,
          DateTime.parse('2020-08-15T14:36:38.228Z'));
      expect(_groupMemberAttributes.name, 'Test User');
      expect(_groupMemberAttributes.email, 'test@test.com');
    });
  });
}
