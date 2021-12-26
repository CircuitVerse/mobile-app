import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class MyGroupsViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_MENTORED_GROUPS = 'fetch_mentored_groups';
  String FETCH_MEMBER_GROUPS = 'fetch_member_groups';
  String DELETE_GROUP = 'delete_group';

  final GroupsApi _groupsApi = locator<GroupsApi>();

  final List<Group> _mentoredGroups = [];

  List<Group> get mentoredGroups => _mentoredGroups;

  final List<Group> _memberGroups = [];

  List<Group> get memberGroups => _memberGroups;

  late Groups _previousMentoredGroupsBatch;

  Groups get previousMentoredGroupsBatch => _previousMentoredGroupsBatch;

  set previousMentoredGroupsBatch(Groups previousMentoredGroupsBatch) {
    _previousMentoredGroupsBatch = previousMentoredGroupsBatch;
    notifyListeners();
  }

  late Groups _previousMemberGroupsBatch;

  Groups get previousMemberGroupsBatch => _previousMemberGroupsBatch;

  set previousMemberGroupsBatch(Groups previousMemberGroupsBatch) {
    _previousMemberGroupsBatch = previousMemberGroupsBatch;
    notifyListeners();
  }

  void onGroupCreated(Group group) async {
    _mentoredGroups.add(group);
    notifyListeners();
  }

  void onGroupUpdated(Group group) {
    // if update access is granted then group must be one of his/her mentored
    var _mentoredGroupIndex = _mentoredGroups.indexWhere(
      (mentoredGroup) => mentoredGroup.id == group.id,
    );
    _mentoredGroups.removeAt(_mentoredGroupIndex);
    _mentoredGroups.insert(_mentoredGroupIndex, group);
    notifyListeners();
  }

  Future fetchMentoredGroups() async {
    try {
      if (previousMentoredGroupsBatch.links.next != null) {
        // fetch next batch of mentoring groups..
        String _nextPageLink = previousMentoredGroupsBatch.links.next;
        var _nextPageNumber =
            int.parse(_nextPageLink.substring(_nextPageLink.length - 1));
        // fetch groups corresponding to next page number..
        previousMentoredGroupsBatch = await _groupsApi.fetchMentoringGroups(
          page: _nextPageNumber,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(FETCH_MENTORED_GROUPS, ViewState.Busy);
        // fetch mentoring groups for the very first time..
        previousMentoredGroupsBatch = await _groupsApi.fetchMentoringGroups();
      }

      mentoredGroups.addAll(previousMentoredGroupsBatch.data);

      setStateFor(FETCH_MENTORED_GROUPS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_MENTORED_GROUPS, ViewState.Error);
      setErrorMessageFor(FETCH_MENTORED_GROUPS, f.message);
    }
  }

  Future fetchMemberGroups() async {
    try {
      if (previousMemberGroupsBatch.links.next != null) {
        // fetch next batch of member groups..
        String _nextPageLink = previousMemberGroupsBatch.links.next;
        var _nextPageNumber =
            int.parse(_nextPageLink.substring(_nextPageLink.length - 1));
        // fetch groups corresponding to next page number..
        previousMemberGroupsBatch = await _groupsApi.fetchMemberGroups(
          page: _nextPageNumber,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(FETCH_MEMBER_GROUPS, ViewState.Busy);
        // fetch mentoring groups for the very first time..
        previousMemberGroupsBatch = await _groupsApi.fetchMemberGroups();
      }

      memberGroups.addAll(previousMemberGroupsBatch.data);

      setStateFor(FETCH_MEMBER_GROUPS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_MEMBER_GROUPS, ViewState.Error);
      setErrorMessageFor(FETCH_MEMBER_GROUPS, f.message);
    }
  }

  Future deleteGroup(String groupId) async {
    setStateFor(DELETE_GROUP, ViewState.Busy);
    try {
      var _isDeleted = await _groupsApi.deleteGroup(groupId);

      if (_isDeleted) {
        // remove the group from the list of groups..
        mentoredGroups.removeWhere((group) => group.id == groupId);
        setStateFor(DELETE_GROUP, ViewState.Success);
      } else {
        setStateFor(DELETE_GROUP, ViewState.Error);
        setErrorMessageFor(DELETE_GROUP, 'Group can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(DELETE_GROUP, ViewState.Error);
      setErrorMessageFor(DELETE_GROUP, f.message);
    }
  }
}
