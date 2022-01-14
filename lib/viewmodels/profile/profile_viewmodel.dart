import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ProfileViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_USER_PROFILE = 'fetch_user_profile';

  final UsersApi _usersApi = locator<UsersApi>();

  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  Future? fetchUserProfile(String? userId) async {
    if (userId == null) return;
    setStateFor(FETCH_USER_PROFILE, ViewState.Busy);
    try {
      user = await _usersApi.fetchUser(userId);

      setStateFor(FETCH_USER_PROFILE, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_USER_PROFILE, ViewState.Error);
      setErrorMessageFor(FETCH_USER_PROFILE, f.message);
    }
  }
}
