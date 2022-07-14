import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class MyGroupsViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_OWNED_GROUPS = 'fetch_owned_groups';
  String FETCH_MEMBER_GROUPS = 'fetch_member_groups';
  String DELETE_GROUP = 'delete_group';

  final GroupsApi _groupsApi = locator<GroupsApi>();

  final List<Group> _ownedGroups = [];

  List<Group> get ownedGroups => _ownedGroups;

  final List<Group> _memberGroups = [];

  List<Group> get memberGroups => _memberGroups;

  Groups? _previousMentoredGroupsBatch;

  Groups? get previousMentoredGroupsBatch => _previousMentoredGroupsBatch;

  set previousMentoredGroupsBatch(Groups? previousMentoredGroupsBatch) {
    _previousMentoredGroupsBatch = previousMentoredGroupsBatch;
    notifyListeners();
  }

  Groups? _previousMemberGroupsBatch;

  Groups? get previousMemberGroupsBatch => _previousMemberGroupsBatch;

  set previousMemberGroupsBatch(Groups? previousMemberGroupsBatch) {
    _previousMemberGroupsBatch = previousMemberGroupsBatch;
    notifyListeners();
  }

  void onGroupCreated(Group group) async {
    _ownedGroups.add(group);
    notifyListeners();
  }

  void onGroupUpdated(Group group) {
    // if update access is granted then group must be one of his/her mentored
    var _mentoredGroupIndex = _ownedGroups.indexWhere(
      (mentoredGroup) => mentoredGroup.id == group.id,
    );
    _ownedGroups.removeAt(_mentoredGroupIndex);
    _ownedGroups.insert(_mentoredGroupIndex, group);
    notifyListeners();
  }

  Future? fetchMentoredGroups() async {
    try {
      if (previousMentoredGroupsBatch?.links.next != null) {
        // fetch next batch of mentoring groups..
        String _nextPageLink = previousMentoredGroupsBatch!.links.next;
        var _nextPageNumber =
            int.parse(_nextPageLink.substring(_nextPageLink.length - 1));
        // fetch groups corresponding to next page number..
        previousMentoredGroupsBatch = await _groupsApi.fetchOwnedGroups(
          page: _nextPageNumber,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(FETCH_OWNED_GROUPS, ViewState.Busy);
        // fetch mentoring groups for the very first time..
        previousMentoredGroupsBatch = await _groupsApi.fetchOwnedGroups();
      }

      ownedGroups.addAll(previousMentoredGroupsBatch?.data ?? []);

      setStateFor(FETCH_OWNED_GROUPS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_OWNED_GROUPS, ViewState.Error);
      setErrorMessageFor(FETCH_OWNED_GROUPS, f.message);
    }
  }

  Future? fetchMemberGroups() async {
    try {
      if (previousMemberGroupsBatch?.links.next != null) {
        // fetch next batch of member groups..
        String _nextPageLink = previousMemberGroupsBatch!.links.next;
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

      memberGroups.addAll(previousMemberGroupsBatch?.data ?? []);

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

      if (_isDeleted ?? false) {
        // remove the group from the list of groups..
        ownedGroups.removeWhere((group) => group.id == groupId);
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
