import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/services/API/group_members_api.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class GroupDetailsViewModel extends BaseModel {
  // ViewState Keys
  String fetchGroupDetailsKey = 'fetch_group_details';
  String addGroupMembersKey = 'add_group_members';
  String deleteGroupMemberKey = 'delete_group_member';
  String reopenAssignmentKey = 'reopen_assignment';
  String startAssignmentKey = 'start_assignment';
  String deleteAssignmentKey = 'delete_assignment';

  final GroupsApi _groupsApi = locator<GroupsApi>();
  final GroupMembersApi _groupMembersApi = locator<GroupMembersApi>();
  final AssignmentsApi _assignmentsApi = locator<AssignmentsApi>();

  Group _group;

  Group get group => _group;

  set group(Group group) {
    _group = group;
    notifyListeners();
  }

  List<GroupMember> _groupMembers = [];

  List<GroupMember> get groupMembers => _groupMembers;

  set groupMembers(List<GroupMember> groupMembers) {
    _groupMembers = groupMembers;
    notifyListeners();
  }

  List<Assignment> _assignments = [];

  List<Assignment> get assignments => _assignments;

  set assignments(List<Assignment> assignments) {
    _assignments = assignments;
    notifyListeners();
  }

  String _addedMembersSuccessMessage;

  String get addedMembersSuccessMessage => _addedMembersSuccessMessage;

  set addedMembersSuccessMessage(String addedMembersSuccessMessage) {
    _addedMembersSuccessMessage = addedMembersSuccessMessage;
    notifyListeners();
  }

  Future fetchGroupDetails(String groupId) async {
    setStateFor(fetchGroupDetailsKey, ViewState.Busy);
    try {
      group = await _groupsApi.fetchGroupDetails(groupId);
      groupMembers = _group.groupMembers;
      assignments = _group.assignments;

      setStateFor(fetchGroupDetailsKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchGroupDetailsKey, ViewState.Error);
      setErrorMessageFor(fetchGroupDetailsKey, f.message);
    }
  }

  Future addMembers(String groupId, String emails) async {
    setStateFor(addGroupMembersKey, ViewState.Busy);
    try {
      var addGroupMembers =
          await _groupMembersApi.addGroupMembers(groupId, emails);

      var _addedMembers = addGroupMembers.added.join(', ');
      var _pendingMembers = addGroupMembers.pending.join(', ');
      var _invalidMembers = addGroupMembers.invalid.join(', ');

      addedMembersSuccessMessage = (_addedMembers.isNotEmpty
              ? '$_addedMembers was/were added '
              : '') +
          (_pendingMembers.isNotEmpty
              ? '$_pendingMembers is/are pending '
              : '') +
          (_invalidMembers.isNotEmpty ? '$_invalidMembers is/are invalid' : '');

      // Fetch & Update all Group Members..
      var _members = await _groupMembersApi.fetchGroupMembers(groupId);
      groupMembers = _members.data;

      setStateFor(addGroupMembersKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(addGroupMembersKey, ViewState.Error);
      setErrorMessageFor(addGroupMembersKey, f.message);
    }
  }

  Future deleteGroupMember(String groupMemberId) async {
    setStateFor(deleteGroupMemberKey, ViewState.Busy);
    try {
      var _isDeleted = await _groupMembersApi.deleteGroupMember(groupMemberId);

      if (_isDeleted) {
        // Remove Group Member from the list..
        groupMembers.removeWhere((member) => member.id == groupMemberId);
        setStateFor(deleteGroupMemberKey, ViewState.Success);
      } else {
        setStateFor(deleteGroupMemberKey, ViewState.Error);
        setErrorMessageFor(
            deleteGroupMemberKey, 'Group Member can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteGroupMemberKey, ViewState.Error);
      setErrorMessageFor(deleteGroupMemberKey, f.message);
    }
  }

  void onAssignmentAdded(Assignment assignment) async {
    _assignments.add(assignment);
    notifyListeners();
  }

  void onAssignmentUpdated(Assignment assignment) async {
    var _index =
        _assignments.indexWhere((assignment) => assignment.id == assignment.id);
    _assignments.removeAt(_index);
    _assignments.insert(_index, assignment);
    notifyListeners();
  }

  Future reopenAssignment(String assignmentId) async {
    setStateFor(reopenAssignmentKey, ViewState.Busy);
    try {
      await _assignmentsApi.reopenAssignment(assignmentId);

      // Reopen the assignment with id being assignmentId..
      assignments
          .firstWhere((assignment) => assignment.id == assignmentId)
          .attributes
          .status = 'open';
      notifyListeners();

      setStateFor(reopenAssignmentKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(reopenAssignmentKey, ViewState.Error);
      setErrorMessageFor(reopenAssignmentKey, f.message);
    }
  }

  Future startAssignment(String assignmentId) async {
    setStateFor(startAssignmentKey, ViewState.Busy);
    try {
      await _assignmentsApi.startAssignment(assignmentId);
      _group = await _groupsApi.fetchGroupDetails(_group.id);

      // update assignments after creating a project for any assignment..
      groupMembers = _group.groupMembers;
      assignments = _group.assignments;

      setStateFor(startAssignmentKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(startAssignmentKey, ViewState.Error);
      setErrorMessageFor(startAssignmentKey, f.message);
    }
  }

  Future deleteAssignment(String assignmentId) async {
    setStateFor(deleteAssignmentKey, ViewState.Busy);
    try {
      var _isDeleted = await _assignmentsApi.deleteAssignment(assignmentId);

      if (_isDeleted) {
        // Remove Assignment from the list..
        assignments.removeWhere((assignment) => assignment.id == assignmentId);
        setStateFor(deleteAssignmentKey, ViewState.Success);
      } else {
        setStateFor(deleteAssignmentKey, ViewState.Error);
        setErrorMessageFor(deleteAssignmentKey, 'Assignment can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteAssignmentKey, ViewState.Error);
      setErrorMessageFor(deleteAssignmentKey, f.message);
    }
  }
}
