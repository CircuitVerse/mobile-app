import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class CVLandingViewModel extends BaseModel {
  final LocalStorageService _storage = locator<LocalStorageService>();
  final DialogService _dialogService = locator<DialogService>();

  bool get isLoggedIn => _storage.isLoggedIn;

  User get currentUser => _storage.currentUser;

  Future<void> onLogout() async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
        title: 'Log Out',
        description: 'Are you sure you want to logout?',
        confirmationTitle: 'LOGOUT');

    if (_dialogResponse.confirmed) {
      _storage.isLoggedIn = false;
      _storage.currentUser = null;
      _storage.token = null;

      notifyListeners();
      SnackBarUtils.showDark('Logged Out Successfully');
    }
  }
}
