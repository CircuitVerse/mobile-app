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
  String FETCH_GROUP_DETAILS = 'fetch_group_details';
  String ADD_GROUP_MEMBERS = 'add_group_members';
  String DELETE_GROUP_MEMBER = 'delete_group_member';
  String REOPEN_ASSIGNMENT = 'reopen_assignment';
  String START_ASSIGNMENT = 'start_assignment';
  String DELETE_ASSIGNMENT = 'delete_assignment';

  final GroupsApi? _groupsApi = locator<GroupsApi>();
  final GroupMembersApi? _groupMembersApi = locator<GroupMembersApi>();
  final AssignmentsApi? _assignmentsApi = locator<AssignmentsApi>();

  Group? _group;

  Group? get group => _group;

  set group(Group? group) {
    _group = group;
    notifyListeners();
  }

  List<GroupMember>? _groupMembers = [];

  List<GroupMember>? get groupMembers => _groupMembers;

  set groupMembers(List<GroupMember>? groupMembers) {
    _groupMembers = groupMembers;
    notifyListeners();
  }

  List<Assignment>? _assignments = [];

  List<Assignment>? get assignments => _assignments;

  set assignments(List<Assignment>? assignments) {
    _assignments = assignments;
    notifyListeners();
  }

  String? _addedMembersSuccessMessage;

  String? get addedMembersSuccessMessage => _addedMembersSuccessMessage;

  set addedMembersSuccessMessage(String? addedMembersSuccessMessage) {
    _addedMembersSuccessMessage = addedMembersSuccessMessage;
    notifyListeners();
  }

  Future fetchGroupDetails(String? groupId) async {
    setStateFor(FETCH_GROUP_DETAILS, ViewState.Busy);
    try {
      group = await _groupsApi!.fetchGroupDetails(groupId);
      groupMembers = _group!.groupMembers;
      assignments = _group!.assignments;

      setStateFor(FETCH_GROUP_DETAILS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_GROUP_DETAILS, ViewState.Error);
      setErrorMessageFor(FETCH_GROUP_DETAILS, f.message);
    }
  }

  Future addMembers(String? groupId, String? emails) async {
    setStateFor(ADD_GROUP_MEMBERS, ViewState.Busy);
    try {
      var addGroupMembers =
          await _groupMembersApi!.addGroupMembers(groupId, emails);

      var _addedMembers = addGroupMembers.added!.join(', ');
      var _pendingMembers = addGroupMembers.pending!.join(', ');
      var _invalidMembers = addGroupMembers.invalid!.join(', ');

      addedMembersSuccessMessage = (_addedMembers.isNotEmpty
              ? '$_addedMembers was/were added '
              : '') +
          (_pendingMembers.isNotEmpty
              ? '$_pendingMembers is/are pending '
              : '') +
          (_invalidMembers.isNotEmpty ? '$_invalidMembers is/are invalid' : '');

      // Fetch & Update all Group Members..
      var _members = await _groupMembersApi!.fetchGroupMembers(groupId);
      groupMembers = _members.data;

      setStateFor(ADD_GROUP_MEMBERS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(ADD_GROUP_MEMBERS, ViewState.Error);
      setErrorMessageFor(ADD_GROUP_MEMBERS, f.message);
    }
  }

  Future deleteGroupMember(String? groupMemberId) async {
    setStateFor(DELETE_GROUP_MEMBER, ViewState.Busy);
    try {
      var _isDeleted = await _groupMembersApi!.deleteGroupMember(groupMemberId);

      if (_isDeleted) {
        // Remove Group Member from the list..
        groupMembers!.removeWhere((member) => member.id == groupMemberId);
        setStateFor(DELETE_GROUP_MEMBER, ViewState.Success);
      } else {
        setStateFor(DELETE_GROUP_MEMBER, ViewState.Error);
        setErrorMessageFor(
            DELETE_GROUP_MEMBER, 'Group Member can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(DELETE_GROUP_MEMBER, ViewState.Error);
      setErrorMessageFor(DELETE_GROUP_MEMBER, f.message);
    }
  }

  void onAssignmentAdded(Assignment assignment) async {
    _assignments!.add(assignment);
    notifyListeners();
  }

  void onAssignmentUpdated(Assignment assignment) async {
    var _index =
        _assignments!.indexWhere((assignment) => assignment.id == assignment.id);
    _assignments!.removeAt(_index);
    _assignments!.insert(_index, assignment);
    notifyListeners();
  }

  Future reopenAssignment(String? assignmentId) async {
    setStateFor(REOPEN_ASSIGNMENT, ViewState.Busy);
    try {
      await _assignmentsApi!.reopenAssignment(assignmentId);

      // Reopen the assignment with id being assignmentId..
      assignments!
          .firstWhere((assignment) => assignment.id == assignmentId)
          .attributes!
          .status = 'open';
      notifyListeners();

      setStateFor(REOPEN_ASSIGNMENT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(REOPEN_ASSIGNMENT, ViewState.Error);
      setErrorMessageFor(REOPEN_ASSIGNMENT, f.message);
    }
  }

  Future startAssignment(String? assignmentId) async {
    setStateFor(START_ASSIGNMENT, ViewState.Busy);
    try {
      await _assignmentsApi!.startAssignment(assignmentId);
      _group = await _groupsApi!.fetchGroupDetails(_group!.id);

      // update assignments after creating a project for any assignment..
      groupMembers = _group!.groupMembers;
      assignments = _group!.assignments;

      setStateFor(START_ASSIGNMENT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(START_ASSIGNMENT, ViewState.Error);
      setErrorMessageFor(START_ASSIGNMENT, f.message);
    }
  }

  Future deleteAssignment(String? assignmentId) async {
    setStateFor(DELETE_ASSIGNMENT, ViewState.Busy);
    try {
      var _isDeleted = await _assignmentsApi!.deleteAssignment(assignmentId);

      if (_isDeleted) {
        // Remove Assignment from the list..
        assignments!.removeWhere((assignment) => assignment.id == assignmentId);
        setStateFor(DELETE_ASSIGNMENT, ViewState.Success);
      } else {
        setStateFor(DELETE_ASSIGNMENT, ViewState.Error);
        setErrorMessageFor(DELETE_ASSIGNMENT, 'Assignment can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(DELETE_ASSIGNMENT, ViewState.Error);
      setErrorMessageFor(DELETE_ASSIGNMENT, f.message);
    }
  }
}
