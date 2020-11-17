import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/links.dart';

import '../setup/test_data/mock_collaborators.dart';

void main() {
  group('CollaboratorsTest -', () {
    test('CollaboratorsTest', () {
      var _collaborators = Collaborators.fromJson(mockCollaborators);

      expect(_collaborators, isInstanceOf<Collaborators>());

      expect(_collaborators.data, isInstanceOf<List<Collaborator>>());
      expect(_collaborators.data.length, 1);

      expect(_collaborators.links, isInstanceOf<Links>());
    });

    test('CollaboratorTest', () {
      var _collaborator = Collaborator.fromJson(mockCollaborator);

      expect(_collaborator, isInstanceOf<Collaborator>());

      expect(_collaborator.id, '1');
      expect(_collaborator.type, 'user');
      expect(_collaborator.attributes, isInstanceOf<CollaboratorAttributes>());
    });

    test('CollaboratorAttributesTest', () {
      var _collaboratorAttributes =
          CollaboratorAttributes.fromJson(mockCollaboratorAttributes);

      expect(_collaboratorAttributes, isInstanceOf<CollaboratorAttributes>());

      expect(_collaboratorAttributes.name, 'Test User');
    });
  });
}
