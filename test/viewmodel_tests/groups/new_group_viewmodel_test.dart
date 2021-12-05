import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/viewmodels/groups/new_group_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('NewGroupViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _group = Group.fromJson(mockGroup);

    group('addGroup -', () {
      test('When called & service returns success response', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.addGroup('Test Group'))
            .thenAnswer((_) => Future.value(_group));

        var _model = NewGroupViewModel();
        await _model.addGroup('Test Group');

        verify(_mockGroupsApi.addGroup('Test Group'));
        expect(_model.stateFor(_model.addGroupKey), ViewState.Success);
        expect(_model.newGroup, _group);
      });

      test('When called & service returns error response', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.addGroup('Test Group'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = NewGroupViewModel();
        await _model.addGroup('Test Group');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.addGroupKey), ViewState.Error);
        expect(
            _model.errorMessageFor(_model.addGroupKey), 'Some Error Occurred!');
      });
    });
  });
}
