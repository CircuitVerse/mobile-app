import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseModel {
  // ViewState Keys
  final String LOGIN = 'login';

  final UsersApi? _userApi = locator<UsersApi>();
  final LocalStorageService? _storage = locator<LocalStorageService>();

  Future<void> login(String? email, String? password) async {
    setStateFor(LOGIN, ViewState.Busy);
    try {
      var token = await _userApi!.login(email, password);

      // store token in local storage..
      _storage!.token = token;

      // update is_logged_in status..
      _storage!.isLoggedIn = true;

      // save current user to local storage..
      _storage!.currentUser = await _userApi!.fetchCurrentUser();

      setStateFor(LOGIN, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(LOGIN, ViewState.Error);
      setErrorMessageFor(LOGIN, f.message);
    }
  }
}
