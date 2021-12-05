import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/viewmodels/groups/my_groups_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('MyGroupsViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _groups = Groups.fromJson(mockGroups);
    var _group = Group.fromJson(mockGroup);

    group('onGroupCreated -', () {
      test('When called, adds group to _mentoredGroups', () {
        var _model = MyGroupsViewModel();
        _model.onGroupCreated(_group);

        expect(_model.mentoredGroups.last, _group);
      });
    });

    group('onGroupUpdated -', () {
      test('When called, updates a particular group', () {
        var _model = MyGroupsViewModel();
        _model.mentoredGroups.add(_group);
        _model.onGroupUpdated(_group..attributes.name = 'Test Group Updated');

        expect(
          _model.mentoredGroups
              .firstWhere((group) => group.id == _group.id)
              .attributes
              .name,
          'Test Group Updated',
        );
      });
    });

    group('fetchMentoredGroups -', () {
      test('When first time fetched & service returns success response',
          () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchMentoringGroups())
            .thenAnswer((_) => Future.value(_groups));

        var _model = MyGroupsViewModel();
        await _model.fetchMentoredGroups();

        verify(_mockGroupsApi.fetchMentoringGroups());
        expect(
            _model.stateFor(_model.fetchMentoredGroupsKey), ViewState.Success);
        expect(_model.previousMentoredGroupsBatch, _groups);
        expect(deepEq(_model.mentoredGroups, _groups.data), true);
      });

      test('When not first time fetched & service returns success response',
          () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchMentoringGroups(page: 2))
            .thenAnswer((_) => Future.value(_groups));

        var _model = MyGroupsViewModel();
        _model.previousMentoredGroupsBatch = _groups;
        await _model.fetchMentoredGroups();

        verify(_mockGroupsApi.fetchMentoringGroups(page: 2));
        expect(
            _model.stateFor(_model.fetchMentoredGroupsKey), ViewState.Success);
        expect(_model.previousMentoredGroupsBatch, _groups);
      });

      test('When first time fetched & service returns error response',
          () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchMentoringGroups())
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = MyGroupsViewModel();
        await _model.fetchMentoredGroups();

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.fetchMentoredGroupsKey), ViewState.Error);
        expect(_model.errorMessageFor(_model.fetchMentoredGroupsKey),
            'Some Error Occurred!');
      });
    });

    group('fetchMemberGroups -', () {
      test('When first time fetched & service returns success response',
          () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchMemberGroups())
            .thenAnswer((_) => Future.value(_groups));

        var _model = MyGroupsViewModel();
        await _model.fetchMemberGroups();

        verify(_mockGroupsApi.fetchMemberGroups());
        expect(_model.stateFor(_model.fetchMemberGroupsKey), ViewState.Success);
        expect(_model.previousMemberGroupsBatch, _groups);
        expect(deepEq(_model.memberGroups, _groups.data), true);
      });

      test('When not first time fetched & service returns success response',
          () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchMemberGroups(page: 2))
            .thenAnswer((_) => Future.value(_groups));

        var _model = MyGroupsViewModel();
        _model.previousMemberGroupsBatch = _groups;
        await _model.fetchMemberGroups();

        verify(_mockGroupsApi.fetchMemberGroups(page: 2));
        expect(_model.stateFor(_model.fetchMemberGroupsKey), ViewState.Success);
        expect(_model.previousMemberGroupsBatch, _groups);
      });

      test('When first time fetched & service returns error response',
          () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchMemberGroups())
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = MyGroupsViewModel();
        await _model.fetchMemberGroups();

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.fetchMemberGroupsKey), ViewState.Error);
        expect(_model.errorMessageFor(_model.fetchMemberGroupsKey),
            'Some Error Occurred!');
      });
    });

    group('deleteGroup -', () {
      test('When called & service returns success/true response', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.deleteGroup('1'))
            .thenAnswer((_) => Future.value(true));

        var _model = MyGroupsViewModel();
        _model.mentoredGroups.add(_group);
        await _model.deleteGroup('1');

        // verify API call is made..
        verify(_mockGroupsApi.deleteGroup('1'));
        expect(_model.stateFor(_model.deleteGroupKey), ViewState.Success);

        // verify group member is deleted..
        expect(
            _model.mentoredGroups
                .where((group) => _group.id == group.id)
                .isEmpty,
            true);
      });

      test('When called & service returns false', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.deleteGroup('1'))
            .thenAnswer((_) => Future.value(false));

        var _model = MyGroupsViewModel();
        _model.mentoredGroups.add(_group);
        await _model.deleteGroup('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.deleteGroupKey), ViewState.Error);
        expect(_model.errorMessageFor(_model.deleteGroupKey),
            'Group can\'t be deleted');
      });

      test('When called & service returns error', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.deleteGroup('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = MyGroupsViewModel();
        _model.mentoredGroups.add(_group);
        await _model.deleteGroup('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.deleteGroupKey), ViewState.Error);
        expect(_model.errorMessageFor(_model.deleteGroupKey),
            'Some Error Occurred!');
      });
    });
  });
}
