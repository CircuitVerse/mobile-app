import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class SignupViewModel extends BaseModel {
  // ViewState Keys
  final String signUP = 'signup';

  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  Future<void> signup(String name, String email, String password) async {
    setStateFor(signUP, ViewState.Busy);
    try {
      var token = await _userApi.signup(name, email, password);

      // store token in local storage..
      _storage.token = token;

      // update is_logged_in status..
      _storage.isLoggedIn = true;

      // save current user to local storage..
      _storage.currentUser = await _userApi.fetchCurrentUser();

      setStateFor(signUP, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(signUP, ViewState.Error);
      setErrorMessageFor(signUP, f.message);
    }
  }
}
