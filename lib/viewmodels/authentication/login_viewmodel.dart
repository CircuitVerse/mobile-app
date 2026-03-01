import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseModel {
  // ViewState Keys
  final String LOGIN = 'login';

  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  Future<void> login(String email, String password) async {
    setStateFor(LOGIN, ViewState.Busy);
    try {
      // Step 1: Authenticate and get token
      var token = await _userApi.login(email, password);

      // Step 2: Store token immediately
      _storage.token = token;
      _storage.isLoggedIn = true;

      // Step 3: Fetch current user (non-blocking)
      // If this fails, user is still logged in with token
      try {
        _storage.currentUser = await _userApi.fetchCurrentUser();
        print("_storage.currentUser: ${_storage.currentUser}");
      } on Failure catch (e) {
        // Log the error but don't fail the login
        print('Warning: Failed to fetch current user: ${e.message}');
        // User will be fetched later when accessing profile or landing screen
        _storage.currentUser = null;
      }

      // Step 4: Mark login as successful
      setStateFor(LOGIN, ViewState.Success);
    } on Failure catch (f) {
      // Only reach here if login() itself fails
      setStateFor(LOGIN, ViewState.Error);
      setErrorMessageFor(LOGIN, f.message);
    }
  }
}
