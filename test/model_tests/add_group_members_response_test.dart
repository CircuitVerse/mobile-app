import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/add_group_members_response.dart';

import '../setup/test_data/mock_add_group_members_response.dart';

void main() {
  group('AddGroupMembersResponseTest -', () {
    test('fromJson', () {
      var _collaboratorResponse =
          AddGroupMembersResponse.fromJson(mockAddGroupMembersResponse);

      expect(_collaboratorResponse, isInstanceOf<AddGroupMembersResponse>());

      expect(_collaboratorResponse.added.length, 1);
      expect(_collaboratorResponse.added[0], 'test@test.com');
      expect(_collaboratorResponse.pending.length, 1);
      expect(_collaboratorResponse.pending[0], 'pending@test.com');
      expect(_collaboratorResponse.invalid.length, 1);
      expect(_collaboratorResponse.invalid[0], 'invalid@test.com');
    });
  });
}
