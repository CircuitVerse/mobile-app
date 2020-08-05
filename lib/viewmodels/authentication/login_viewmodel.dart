import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class LoginViewModel extends BaseModel {
  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  bool _isLoginSuccessful = false;

  bool get isLoginSuccessful => _isLoginSuccessful;

  set isLoginSuccessful(bool isLoginSuccessful) {
    _isLoginSuccessful = isLoginSuccessful;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setState(ViewState.Busy);
    try {
      var token = await _userApi.login(email, password);

      // store token in local storage..
      _storage.token = token;

      // update is_logged_in status..
      _storage.isLoggedIn = true;

      // save current user to local storage..
      _storage.currentUser = await _userApi.fetchCurrentUser();

      isLoginSuccessful = true;

      setState(ViewState.Idle);

      // show login successful snackbar..
      SnackBarUtils.showDark('Login Successful');

      // move to home view on successful login..
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
