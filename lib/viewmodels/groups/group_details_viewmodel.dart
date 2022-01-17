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
  String fetchGROUPDETAILS = 'fetch_group_details';
  String addGROUPMEMBERS = 'add_group_members';
  String deleteGROUPMEMBER = 'delete_group_member';
  String reopenASSIGNMENT = 'reopen_assignment';
  String startASSIGNMENT = 'start_assignment';
  String deleteASSIGNMENT = 'delete_assignment';

  final GroupsApi _groupsApi = locator<GroupsApi>();
  final GroupMembersApi _groupMembersApi = locator<GroupMembersApi>();
  final AssignmentsApi _assignmentsApi = locator<AssignmentsApi>();

  late Group _group;

  Group get group => _group;

  set group(Group? group) {
    if (group == null) return;
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

  late String _addedMembersSuccessMessage;

  String get addedMembersSuccessMessage => _addedMembersSuccessMessage;

  set addedMembersSuccessMessage(String addedMembersSuccessMessage) {
    _addedMembersSuccessMessage = addedMembersSuccessMessage;
    notifyListeners();
  }

  Future? fetchGroupDetails(String groupId) async {
    setStateFor(fetchGROUPDETAILS, ViewState.Busy);
    try {
      group = await _groupsApi.fetchGroupDetails(groupId);
      groupMembers = _group.groupMembers!;
      assignments = _group.assignments!;

      setStateFor(fetchGROUPDETAILS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchGROUPDETAILS, ViewState.Error);
      setErrorMessageFor(fetchGROUPDETAILS, f.message);
    }
  }

  Future addMembers(String groupId, String emails) async {
    setStateFor(addGROUPMEMBERS, ViewState.Busy);
    try {
      var addGroupMembers =
          await _groupMembersApi.addGroupMembers(groupId, emails);

      var _addedMembers = addGroupMembers!.added.join(', ');
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
      if (_members != null) groupMembers = _members.data;

      setStateFor(addGROUPMEMBERS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(addGROUPMEMBERS, ViewState.Error);
      setErrorMessageFor(addGROUPMEMBERS, f.message);
    }
  }

  Future deleteGroupMember(String groupMemberId) async {
    setStateFor(deleteGROUPMEMBER, ViewState.Busy);
    try {
      var _isDeleted = await _groupMembersApi.deleteGroupMember(groupMemberId);

      if (_isDeleted ?? false) {
        // Remove Group Member from the list..
        groupMembers.removeWhere((member) => member.id == groupMemberId);
        setStateFor(deleteGROUPMEMBER, ViewState.Success);
      } else {
        setStateFor(deleteGROUPMEMBER, ViewState.Error);
        setErrorMessageFor(deleteGROUPMEMBER, 'Group Member can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteGROUPMEMBER, ViewState.Error);
      setErrorMessageFor(deleteGROUPMEMBER, f.message);
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
    setStateFor(reopenASSIGNMENT, ViewState.Busy);
    try {
      await _assignmentsApi.reopenAssignment(assignmentId);

      // Reopen the assignment with id being assignmentId..
      assignments
          .firstWhere((assignment) => assignment.id == assignmentId)
          .attributes
          .status = 'open';
      notifyListeners();

      setStateFor(reopenASSIGNMENT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(reopenASSIGNMENT, ViewState.Error);
      setErrorMessageFor(reopenASSIGNMENT, f.message);
    }
  }

  Future startAssignment(String assignmentId) async {
    setStateFor(startASSIGNMENT, ViewState.Busy);
    try {
      await _assignmentsApi.startAssignment(assignmentId);
      _group = await _groupsApi.fetchGroupDetails(_group.id)!;

      // update assignments after creating a project for any assignment..
      groupMembers = _group.groupMembers!;
      assignments = _group.assignments!;

      setStateFor(startASSIGNMENT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(startASSIGNMENT, ViewState.Error);
      setErrorMessageFor(startASSIGNMENT, f.message);
    }
  }

  Future deleteAssignment(String assignmentId) async {
    setStateFor(deleteASSIGNMENT, ViewState.Busy);
    try {
      var _isDeleted = await _assignmentsApi.deleteAssignment(assignmentId);

      if (_isDeleted ?? false) {
        // Remove Assignment from the list..
        assignments.removeWhere((assignment) => assignment.id == assignmentId);
        setStateFor(deleteASSIGNMENT, ViewState.Success);
      } else {
        setStateFor(deleteASSIGNMENT, ViewState.Error);
        setErrorMessageFor(deleteASSIGNMENT, 'Assignment can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteASSIGNMENT, ViewState.Error);
      setErrorMessageFor(deleteASSIGNMENT, f.message);
    }
  }
}
