import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/viewmodels/groups/edit_group_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('EditGroupViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _group = Group.fromJson(mockGroup);

    group('updateGrade -', () {
      test('When called & service returns success response', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.updateGroup('1', 'Test'))
            .thenAnswer((_) => Future.value(_group));

        var _model = EditGroupViewModel();
        await _model.updateGroup('1', 'Test');

        // verify API call is made..
        verify(_mockGroupsApi.updateGroup('1', 'Test'));
        expect(_model.stateFor(_model.updateGROUP), ViewState.Success);

        // verify group is updated..
        expect(_model.updatedGroup, _group);
      });

      test('When called & service returns error', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.updateGroup('1', 'Test'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = EditGroupViewModel();
        await _model.updateGroup('1', 'Test');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.updateGROUP), ViewState.Error);
        expect(
            _model.errorMessageFor(_model.updateGROUP), 'Some Error Occurred!');

        // verify group is not populated on failure
        expect(_model.updatedGroup, null);
      });
    });
  });
}
