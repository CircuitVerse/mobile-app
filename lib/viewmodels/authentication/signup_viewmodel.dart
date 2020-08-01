import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class SignupViewModel extends BaseModel {
  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  bool _isSignupSuccessful = false;

  bool get isSignupSuccessful => _isSignupSuccessful;

  set isSignupSuccessful(bool isSignupSuccessful) {
    _isSignupSuccessful = isSignupSuccessful;
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    setState(ViewState.Busy);
    try {
      var token = await _userApi.signup(name, email, password);

      // store token in local storage..
      _storage.token = token;

      // update is_logged_in status..
      _storage.isLoggedIn = true;

      // save current user to local storage..
      _storage.currentUser = await _userApi.fetchProfile();

      isSignupSuccessful = true;

      setState(ViewState.Idle);

      // show signup successful snackbar..
      SnackBarUtils.showDark('Signup Successful');

      // move to home view on successful signup..
      await Future.delayed(Duration(seconds: 1));
      await Get.offAllNamed(HomeView.id);
    } on Failure catch (f) {
      // show failure snackbar..
      SnackBarUtils.showDark(f.message);

      setErrorMessage(f.message);
      setState(ViewState.Error);
    }
  }
}
