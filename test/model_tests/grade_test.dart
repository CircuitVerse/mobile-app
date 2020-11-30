import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/grade.dart';

import '../setup/test_data/mock_grade.dart';

void main() {
  group('GradeTest -', () {
    test('GradeFromJson', () {
      var _grade = Grade.fromJson(mockGrade['data']);

      expect(_grade, isInstanceOf<Grade>());

      expect(_grade.id, '1');
      expect(_grade.type, 'grade');

      expect(_grade.attributes, isInstanceOf<GradeAttributes>());
      expect(_grade.relationships, isInstanceOf<GradeRelationships>());
    });

    test('GradeAttributesFromJson', () {
      var _gradeAttributes = GradeAttributes.fromJson(mockGradeAttributes);

      expect(_gradeAttributes, isInstanceOf<GradeAttributes>());

      expect(_gradeAttributes.grade, 'A');
      expect(_gradeAttributes.remarks, 'Good');
      expect(_gradeAttributes.createdAt,
          DateTime.parse('2020-08-20T15:23:50.073Z'));
      expect(_gradeAttributes.updatedAt,
          DateTime.parse('2020-08-20T15:23:50.073Z'));
    });

    test('GradeRelationshipsFromJson', () {
      var _gradeRelationships =
          GradeRelationships.fromJson(mockGradeRelationships);

      expect(_gradeRelationships, isInstanceOf<GradeRelationships>());
      expect(_gradeRelationships.project, isInstanceOf<GradedProject>());
    });

    test('GradedProjectFromJson', () {
      var _gradedProject = GradedProject.fromJson(mockGradedProject);

      expect(_gradedProject, isInstanceOf<GradedProject>());
      expect(_gradedProject.data, isInstanceOf<GradedProjectData>());
    });
  });
}
