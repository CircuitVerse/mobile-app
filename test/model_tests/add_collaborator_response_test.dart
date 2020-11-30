import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/add_collaborator_response.dart';

import '../setup/test_data/mock_add_collaborators_response.dart';

void main() {
  group('AddCollaboratorResponseTest -', () {
    test('fromJson', () {
      var _collaboratorResponse =
          AddCollaboratorsResponse.fromJson(mockAddCollaboratorsResponse);

      expect(_collaboratorResponse, isInstanceOf<AddCollaboratorsResponse>());

      expect(_collaboratorResponse.added.length, 1);
      expect(_collaboratorResponse.added[0], 'test@test.com');
      expect(_collaboratorResponse.existing.length, 1);
      expect(_collaboratorResponse.existing[0], 'existing@test.com');
      expect(_collaboratorResponse.invalid.length, 1);
      expect(_collaboratorResponse.invalid[0], 'invalid@test.com');
    });
  });
}
