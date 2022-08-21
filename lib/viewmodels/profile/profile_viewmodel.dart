import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_USER_PROFILE = 'fetch_user_profile';

  final UsersApi _usersApi = locator<UsersApi>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  String? _userId;

  String? get userId => _userId;

  set userId(String? id) {
    _userId = id ?? _localStorageService.currentUser?.data.id;
  }

  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    if (isPersonalProfile) _localStorageService.currentUser = _user;
    notifyListeners();
  }

  bool get isLoggedIn => _localStorageService.isLoggedIn;

  bool get isPersonalProfile =>
      _localStorageService.currentUser?.data.id == _userId;

  Project? _updatedProject;

  Project? get updatedProject => _updatedProject;

  set updatedProject(Project? project) {
    _updatedProject = project;
    notifyListeners();
  }

  Future? fetchUserProfile() async {
    if (_userId == null) return;
    setStateFor(FETCH_USER_PROFILE, ViewState.Busy);
    try {
      user = await _usersApi.fetchUser(_userId!);

      setStateFor(FETCH_USER_PROFILE, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_USER_PROFILE, ViewState.Error);
      setErrorMessageFor(FETCH_USER_PROFILE, f.message);
    }
  }
}
