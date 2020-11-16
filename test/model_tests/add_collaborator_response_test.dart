import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/add_collaborator_response.dart';

import '../setup/test_data/mock_add_collaborators_response.dart';

void main() {
  group('AddCollaboratorResponseTest -', () {
    test('fromJson', () {
      var _collaborator_response =
          AddCollaboratorsResponse.fromJson(mockAddCollaboratorsResponse);

      expect(_collaborator_response, isInstanceOf<AddCollaboratorsResponse>());

      expect(_collaborator_response.added.length, 1);
      expect(_collaborator_response.added[0], 'test@test.com');
      expect(_collaborator_response.existing.length, 1);
      expect(_collaborator_response.existing[0], 'existing@test.com');
      expect(_collaborator_response.invalid.length, 1);
      expect(_collaborator_response.invalid[0], 'invalid@test.com');
    });
  });
}
