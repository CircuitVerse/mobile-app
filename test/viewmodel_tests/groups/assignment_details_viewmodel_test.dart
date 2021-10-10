import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/grade.dart';
import 'package:mobile_app/viewmodels/groups/assignment_details_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_assignments.dart';
import '../../setup/test_data/mock_grade.dart';
import '../../setup/test_data/mock_projects.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('AssignmentDetailsViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _assignment = Assignment.fromJson(mockAssignment);
    var _project = Project.fromJson(mockProject);
    var _grade = Grade.fromJson(mockGrade['data']);

    group('fetchAssignmentDetails -', () {
      test('When called & service returns success response', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.fetchAssignmentDetails('1'))
            .thenAnswer((_) => Future.value(_assignment));

        var _model = AssignmentDetailsViewModel();
        await _model.fetchAssignmentDetails('1');

        // verify API call is made..
        verify(_mockAssignmentsApi.fetchAssignmentDetails('1'));
        expect(_model.stateFor(_model.FETCH_ASSIGNMENT_DETAILS),
            ViewState.Success);

        // verify assignment data is populated..
        expect(_model.assignment, _assignment);
        expect(_model.projects, _assignment.projects);
        expect(_model.grades, _assignment.grades);
      });

      test('When called & service returns error', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.fetchAssignmentDetails('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = AssignmentDetailsViewModel();
        await _model.fetchAssignmentDetails('1');

        // verify Error ViewState with proper error message..
        expect(
            _model.stateFor(_model.FETCH_ASSIGNMENT_DETAILS), ViewState.Error);
        expect(_model.errorMessageFor(_model.FETCH_ASSIGNMENT_DETAILS),
            'Some Error Occurred!');
      });
    });

    group('addGrade -', () {
      test(
          'When called with project selected & service returns success response',
          () async {
        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.addGrade('1', '1', 'A', 'Good'))
            .thenAnswer((_) => Future.value(_grade));

        var _model = AssignmentDetailsViewModel();
        _model.focussedProject = _project;
        await _model.addGrade('1', 'A', 'Good');

        // verify API call is made..
        verify(_mockGradesApi.addGrade('1', '1', 'A', 'Good'));
        expect(_model.stateFor(_model.ADD_GRADE), ViewState.Success);

        // expect grade to be appended to the end of list..
        expect(_model.grades.last, _grade);
      });

      test('When called & service returns error', () async {
        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.addGrade('1', '1', 'A', 'Good'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = AssignmentDetailsViewModel();
        _model.focussedProject = _project;
        await _model.addGrade('1', 'A', 'Good');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.ADD_GRADE), ViewState.Error);
        expect(
            _model.errorMessageFor(_model.ADD_GRADE), 'Some Error Occurred!');
      });
    });

    group('updateGrade -', () {
      test('When called & service returns success response', () async {
        var _updatedGrade = _grade..attributes!.remarks = 'Very Good';

        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.updateGrade('1', 'A', 'Very Good'))
            .thenAnswer((_) => Future.value(_updatedGrade));

        var _model = AssignmentDetailsViewModel();
        _model.grades.add(_grade);
        await _model.updateGrade('1', 'A', 'Very Good');

        // verify API call is made..
        verify(_mockGradesApi.updateGrade('1', 'A', 'Very Good'));
        expect(_model.stateFor(_model.UPDATE_GRADE), ViewState.Success);

        // expect grade to be updated..
        expect(_model.grades.firstWhere((grade) => grade.id == _grade.id),
            _updatedGrade);
      });

      test('When called & service returns error', () async {
        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.updateGrade('1', 'A', 'Very Good'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = AssignmentDetailsViewModel();
        await _model.updateGrade('1', 'A', 'Very Good');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.UPDATE_GRADE), ViewState.Error);
        expect(_model.errorMessageFor(_model.UPDATE_GRADE),
            'Some Error Occurred!');
      });
    });

    group('deleteGrade -', () {
      test('When called & service returns success/true response', () async {
        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.deleteGrade('1'))
            .thenAnswer((_) => Future.value(true));

        var _model = AssignmentDetailsViewModel();
        _model.grades.add(_grade);
        await _model.deleteGrade('1');

        // verify API call is made..
        verify(_mockGradesApi.deleteGrade('1'));
        expect(_model.stateFor(_model.DELETE_GRADE), ViewState.Success);

        // expect grade to be deleted..
        expect(_model.grades.where((grade) => grade.id == _grade.id).isEmpty,
            true);
      });

      test('When called & service returns false', () async {
        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.deleteGrade('1'))
            .thenAnswer((_) => Future.value(false));

        var _model = AssignmentDetailsViewModel();
        await _model.deleteGrade('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.DELETE_GRADE), ViewState.Error);
        expect(_model.errorMessageFor(_model.DELETE_GRADE),
            'Grade can\'t be deleted');
      });

      test('When called & service returns error', () async {
        var _mockGradesApi = getAndRegisterGradesApiMock();
        when(_mockGradesApi.deleteGrade('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = AssignmentDetailsViewModel();
        await _model.deleteGrade('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.DELETE_GRADE), ViewState.Error);
        expect(_model.errorMessageFor(_model.DELETE_GRADE),
            'Some Error Occurred!');
      });
    });
  });
}
