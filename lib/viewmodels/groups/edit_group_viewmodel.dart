import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class EditGroupViewModel extends BaseModel {
  // ViewState Keys
  String UPDATE_GROUP = 'update_group';

  final GroupsApi _groupsApi = locator<GroupsApi>();

  Group? _updatedGroup;

  Group? get updatedGroup => _updatedGroup;

  set updatedGroup(Group? updatedGroup) {
    _updatedGroup = updatedGroup;
    notifyListeners();
  }

  Future? updateGroup(String groupId, String name) async {
    setStateFor(UPDATE_GROUP, ViewState.Busy);
    try {
      updatedGroup = await _groupsApi.updateGroup(groupId, name);

      setStateFor(UPDATE_GROUP, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(UPDATE_GROUP, ViewState.Error);
      setErrorMessageFor(UPDATE_GROUP, f.message);
    }
  }
}
