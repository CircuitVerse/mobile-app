import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/add_group_members_response.dart';

import '../setup/test_data/mock_add_group_members_response.dart';

void main() {
  group('AddGroupMembersResponseTest -', () {
    test('fromJson', () {
      var _collaborator_response =
          AddGroupMembersResponse.fromJson(mockAddGroupMembersResponse);

      expect(_collaborator_response, isInstanceOf<AddGroupMembersResponse>());

      expect(_collaborator_response.added.length, 1);
      expect(_collaborator_response.added[0], 'test@test.com');
      expect(_collaborator_response.pending.length, 1);
      expect(_collaborator_response.pending[0], 'pending@test.com');
      expect(_collaborator_response.invalid.length, 1);
      expect(_collaborator_response.invalid[0], 'invalid@test.com');
    });
  });
}
