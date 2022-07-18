import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/add_group_members_response.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/viewmodels/groups/group_details_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_add_group_members_response.dart';
import '../../setup/test_data/mock_assignments.dart';
import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_data/mock_group_members.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('GroupDetailsViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _group = Group.fromJson(mockGroup);
    var _groupMembers = GroupMembers.fromJson(mockGroupMembers);
    var _groupMember = GroupMember.fromJson(mockGroupMember);
    var _assignment = Assignment.fromJson(mockAssignment);
    var _addedMembers =
        AddGroupMembersResponse.fromJson(mockAddGroupMembersResponse);

    group('fetchGroupDetails -', () {
      test('When called & service returns success response', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchGroupDetails('1'))
            .thenAnswer((_) => Future.value(_group));

        var _model = GroupDetailsViewModel();
        await _model.fetchGroupDetails('1');

        // verify API call is made..
        verify(_mockGroupsApi.fetchGroupDetails('1'));
        expect(_model.stateFor(_model.FETCH_GROUP_DETAILS), ViewState.Success);

        // verify group data is populated..
        expect(_model.group, _group);
        expect(_model.members, _group.groupMembers);
        expect(_model.assignments, _group.assignments);
      });

      test('When called & service returns error', () async {
        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchGroupDetails('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = GroupDetailsViewModel();
        await _model.fetchGroupDetails('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.FETCH_GROUP_DETAILS), ViewState.Error);
        expect(_model.errorMessageFor(_model.FETCH_GROUP_DETAILS),
            'Some Error Occurred!');
      });
    });

    group('addMembers -', () {
      test('When called & service returns success response', () async {
        var _mockGroupMembersApi = getAndRegisterGroupMembersApiMock();
        when(_mockGroupMembersApi.addGroupMembers(
                '1', 'test@test.com,pending@test.com,invalid@test.com', false))
            .thenAnswer((_) => Future.value(_addedMembers));

        when(_mockGroupMembersApi.fetchGroupMembers('1'))
            .thenAnswer((_) => Future.value(_groupMembers));

        var _model = GroupDetailsViewModel();
        await _model.addMembers(
            '1', 'test@test.com,pending@test.com,invalid@test.com', false);

        // verify API call is made..
        verify(_mockGroupMembersApi.addGroupMembers(
            '1', 'test@test.com,pending@test.com,invalid@test.com', false));
        verify(_mockGroupMembersApi.fetchGroupMembers('1'));
        expect(_model.stateFor(_model.ADD_GROUP_MEMBERS), ViewState.Success);

        expect(_model.addedMembersSuccessMessage,
            'test@test.com was/were added pending@test.com is/are pending invalid@test.com is/are invalid');
        expect(_model.members, _groupMembers.data);
      });

      test('When called & service returns error', () async {
        var _mockGroupMembersApi = getAndRegisterGroupMembersApiMock();
        when(_mockGroupMembersApi.addGroupMembers(
                '1', 'test@test.com,pending@test.com,invalid@test.com', false))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = GroupDetailsViewModel();
        await _model.addMembers(
            '1', 'test@test.com,pending@test.com,invalid@test.com', false);

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.ADD_GROUP_MEMBERS), ViewState.Error);
        expect(_model.errorMessageFor(_model.ADD_GROUP_MEMBERS),
            'Some Error Occurred!');
      });
    });

    group('deleteGroupMember -', () {
      test('When called & service returns success/true response', () async {
        var _mockGroupMembersApi = getAndRegisterGroupMembersApiMock();
        when(_mockGroupMembersApi.deleteGroupMember('1'))
            .thenAnswer((_) => Future.value(true));

        var _model = GroupDetailsViewModel();
        _model.members.add(_groupMember);
        await _model.deleteGroupMember('1', true);

        // verify API call is made..
        verify(_mockGroupMembersApi.deleteGroupMember('1'));
        expect(_model.stateFor(_model.DELETE_GROUP_MEMBER), ViewState.Success);

        // verify group member is deleted..
        expect(
            _model.members
                .where((member) => _groupMember.id == member.id)
                .isEmpty,
            true);
      });

      test('When called & service returns false', () async {
        var _mockGroupMembersApi = getAndRegisterGroupMembersApiMock();
        when(_mockGroupMembersApi.deleteGroupMember('1'))
            .thenAnswer((_) => Future.value(false));

        var _model = GroupDetailsViewModel();
        _model.members.add(_groupMember);
        await _model.deleteGroupMember('1', true);

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.DELETE_GROUP_MEMBER), ViewState.Error);
        expect(_model.errorMessageFor(_model.DELETE_GROUP_MEMBER),
            'Group Member can\'t be deleted');
      });

      test('When called & service returns error', () async {
        var _mockGroupMembersApi = getAndRegisterGroupMembersApiMock();
        when(_mockGroupMembersApi.deleteGroupMember('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = GroupDetailsViewModel();
        _model.members.add(_groupMember);
        await _model.deleteGroupMember('1', true);

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.DELETE_GROUP_MEMBER), ViewState.Error);
        expect(_model.errorMessageFor(_model.DELETE_GROUP_MEMBER),
            'Some Error Occurred!');
      });
    });

    group('onAssignmentAdded -', () {
      test('When called, adds assignment to _assignments', () {
        var _model = GroupDetailsViewModel();
        _model.onAssignmentAdded(_assignment);

        // verify assignment is added in the list..
        expect(_model.assignments.contains(_assignment), true);
      });
    });

    group('onAssignmentUpdated -', () {
      test('When called, updates assignment', () {
        var _model = GroupDetailsViewModel();
        _model.assignments.add(_assignment);
        _model.onAssignmentUpdated(
            _assignment..attributes.name = 'Updated Assignment');

        // verify updated assignment is present in the list..
        expect(
            _model.assignments
                .contains(_assignment..attributes.name = 'Updated Assignment'),
            true);
      });
    });

    group('reopenAssignment -', () {
      test('When called & service returns success response', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.reopenAssignment('1'))
            .thenAnswer((_) => Future.value(''));

        var _model = GroupDetailsViewModel();
        _model.assignments.add(_assignment..attributes.status = 'closed');
        await _model.reopenAssignment('1');

        // verify API call is made..
        verify(_mockAssignmentsApi.reopenAssignment('1'));
        expect(_model.stateFor(_model.REOPEN_ASSIGNMENT), ViewState.Success);

        // verify status of assignment to be "open"..
        expect(
            _model.assignments
                .firstWhere((assignment) => assignment.id == _assignment.id)
                .attributes
                .status,
            'open');
      });

      test('When called & service returns error', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.reopenAssignment('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = GroupDetailsViewModel();
        _model.assignments.add(_assignment..attributes.status = 'closed');
        await _model.reopenAssignment('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.REOPEN_ASSIGNMENT), ViewState.Error);
        expect(_model.errorMessageFor(_model.REOPEN_ASSIGNMENT),
            'Some Error Occurred!');
      });
    });

    group('startAssignment -', () {
      test('When called & service returns success response', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.startAssignment('1'))
            .thenAnswer((_) => Future.value(''));

        var _mockGroupsApi = getAndRegisterGroupsApiMock();
        when(_mockGroupsApi.fetchGroupDetails('1')).thenAnswer((_) =>
            Future.value(_group
              ..assignments
                  ?.firstWhere((assignment) => assignment.id == _assignment.id)
                  .attributes
                  .currentUserProjectId = 1));

        var _model = GroupDetailsViewModel();
        _model.group = _group;
        _model.assignments.add(_assignment);
        await _model.startAssignment('1');

        // verify API call is made..
        verify(_mockAssignmentsApi.startAssignment('1'));
        expect(_model.stateFor(_model.START_ASSIGNMENT), ViewState.Success);

        // verify status of assignment to be "open"..
        expect(
            _model.assignments
                .firstWhere((assignment) => assignment.id == _assignment.id)
                .attributes
                .currentUserProjectId,
            isNot(null));
      });

      test('When called & service returns error', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.startAssignment('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = GroupDetailsViewModel();
        _model.group = _group;
        _model.assignments.add(_assignment);
        await _model.startAssignment('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.START_ASSIGNMENT), ViewState.Error);
        expect(_model.errorMessageFor(_model.START_ASSIGNMENT),
            'Some Error Occurred!');
      });
    });

    group('deleteAssignment -', () {
      test('When called & service returns success/true response', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.deleteAssignment('1'))
            .thenAnswer((_) => Future.value(true));

        var _model = GroupDetailsViewModel();
        _model.assignments.add(_assignment);
        await _model.deleteAssignment('1');

        // verify API call is made..
        verify(_mockAssignmentsApi.deleteAssignment('1'));
        expect(_model.stateFor(_model.DELETE_ASSIGNMENT), ViewState.Success);

        // expect assignment to be deleted..
        expect(
            _model.assignments
                .where((assignment) => assignment.id == _assignment.id)
                .isEmpty,
            true);
      });

      test('When called & service returns false', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.deleteAssignment('1'))
            .thenAnswer((_) => Future.value(false));

        var _model = GroupDetailsViewModel();
        _model.assignments.add(_assignment);
        await _model.deleteAssignment('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.DELETE_ASSIGNMENT), ViewState.Error);
        expect(_model.errorMessageFor(_model.DELETE_ASSIGNMENT),
            'Assignment can\'t be deleted');
      });

      test('When called & service returns error', () async {
        var _mockAssignmentsApi = getAndRegisterAssignmentsApiMock();
        when(_mockAssignmentsApi.deleteAssignment('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = GroupDetailsViewModel();
        _model.assignments.add(_assignment);
        await _model.deleteAssignment('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.DELETE_ASSIGNMENT), ViewState.Error);
        expect(_model.errorMessageFor(_model.DELETE_ASSIGNMENT),
            'Some Error Occurred!');
      });
    });
  });
}
