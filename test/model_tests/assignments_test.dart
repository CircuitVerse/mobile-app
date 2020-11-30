import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/grade.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/models/projects.dart';

import '../setup/test_data/mock_assignments.dart';

void main() {
  group('AssignmentsTest -', () {
    test('AssignmentsFromJson', () {
      var _assignments = Assignments.fromJson(mockAssignments);

      expect(_assignments, isInstanceOf<Assignments>());

      expect(_assignments.data, isInstanceOf<List<Assignment>>());
      expect(_assignments.data.length, 1);

      expect(_assignments.links, isInstanceOf<Links>());
    });

    test('AssignmentTest', () {
      var _assignment = Assignment.fromJson(mockAssignment);

      expect(_assignment, isInstanceOf<Assignment>());

      expect(_assignment.id, '1');
      expect(_assignment.type, 'assignment');
      expect(_assignment.attributes, isInstanceOf<AssignmentAttributes>());
      expect(_assignment.projects, isInstanceOf<List<Project>>());
      expect(_assignment.projects.length, 1);
      expect(_assignment.grades, isInstanceOf<List<Grade>>());
      expect(_assignment.grades.length, 1);

      expect(_assignment.canBeGraded, true);
      expect(_assignment.gradingScaleHint,
          'Assignment can be graded with any of the letters A/B/C/D/E/F');
    });

    test('AssignmentAttributesTest', () {
      var _assignmentAttributes =
          AssignmentAttributes.fromJson(mockAssignmentAttributes);

      expect(_assignmentAttributes, isInstanceOf<AssignmentAttributes>());

      expect(_assignmentAttributes.name, 'Test');
      expect(_assignmentAttributes.deadline,
          DateTime.parse('2020-08-15T15:23:00.000Z').toLocal());
      expect(_assignmentAttributes.description, 'description');
      expect(_assignmentAttributes.status, 'open');
      expect(_assignmentAttributes.hasMentorAccess, true);
      expect(_assignmentAttributes.createdAt,
          DateTime.parse('2020-08-19T15:00:30.423Z').toLocal());
      expect(_assignmentAttributes.updatedAt,
          DateTime.parse('2020-08-20T15:23:03.018Z').toLocal());
      expect(_assignmentAttributes.currentUserProjectId, null);
      expect(_assignmentAttributes.gradingScale, 'letter');
      expect(_assignmentAttributes.gradesFinalized, false);
      expect(_assignmentAttributes.restrictions, '[]');
    });
  });
}
