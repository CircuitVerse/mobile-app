import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/groups/add_assignment_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_assignments.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('AddAssignmentViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _assignment = Assignment.fromJson(mockAssignment);
    var _deadlineFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var _localDeadline = DateTime(2020, 8, 15);
    var _timeZoneOffsetIncludedDeadline =
        _localDeadline.subtract(_localDeadline.timeZoneOffset);

    group('addAssignment -', () {
      test('When called & service returns success response', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(
          _mockAssignmentsApi.addAssignment(
            '1',
            'Test',
            _deadlineFormat.format(_timeZoneOffsetIncludedDeadline),
            'description',
            'letter',
            json.encode([]),
          ),
        ).thenAnswer((_) => Future.value(_assignment));

        var _model = AddAssignmentViewModel();
        await _model.addAssignment(
            '1', 'Test', _localDeadline, 'letter', 'description', []);

        // verify call to addAssignment with timezone offset subtracted was made
        verify(
          _mockAssignmentsApi.addAssignment(
            '1',
            'Test',
            _deadlineFormat.format(_timeZoneOffsetIncludedDeadline),
            'description',
            'letter',
            json.encode([]),
          ),
        );

        expect(_model.stateFor(_model.addASSIGNMENT), ViewState.Success);

        // addedAssignment was populated
        expect(_model.addedAssignment, _assignment);
      });

      test('When called & service returns error', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(
          _mockAssignmentsApi.addAssignment(
            '1',
            'Test',
            _deadlineFormat.format(_timeZoneOffsetIncludedDeadline),
            'description',
            'letter',
            json.encode([]),
          ),
        ).thenThrow(Failure('Some Error Occurred!'));

        var _model = AddAssignmentViewModel();
        await _model.addAssignment(
            '1', 'Test', _localDeadline, 'letter', 'description', []);

        expect(_model.stateFor(_model.addASSIGNMENT), ViewState.Error);
        expect(_model.errorMessageFor(_model.addASSIGNMENT),
            'Some Error Occurred!');
      });
    });
  });
}
