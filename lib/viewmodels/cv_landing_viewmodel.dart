import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:mobile_app/viewmodels/notifications/notifications_viewmodel.dart';

class CVLandingViewModel extends BaseModel {
  final LocalStorageService _storage = locator<LocalStorageService>();
  final DialogService _dialogService = locator<DialogService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final NotificationsViewModel _viewModel = locator<NotificationsViewModel>();

  User? _currentUser;
  int _selectedIndex = 0;

  bool get isLoggedIn => _storage.isLoggedIn;

  User? get currentUser => _currentUser;

  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  bool _hasPendingNotif = false;

  bool get hasPendingNotif => _hasPendingNotif;

  set hasPendingNotif(bool val) {
    _hasPendingNotif = val;
    notifyListeners();
  }

  void onLogout() async {
    _storage.isLoggedIn = false;
    _storage.currentUser = null;
    _storage.token = null;

    // Perform facebook logout if auth type is facebook..
    if (_storage.authType == AuthType.FACEBOOK) {
      await FacebookAuth.instance.logOut();
    }

    // Perform google signout if auth type is google..
    if (_storage.authType == AuthType.GOOGLE) {
      await _googleSignIn.signOut();
    }

    notifyListeners();
  }

  void setUser() async {
    _currentUser = _storage.currentUser;
    // fetch notifications
    hasPendingNotif = await _viewModel.fetchNotifications();
  }

  void onProfileUpdated() {
    final _updatedUser = _storage.currentUser;
    if (_currentUser?.data.attributes.name ==
        _updatedUser?.data.attributes.name) return;

    currentUser = _updatedUser;
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setSelectedIndexTo(int index) {
    Get.back();
    if (_selectedIndex != index) {
      selectedIndex = index;
    }
  }

  Future<void> onLogoutPressed() async {
    Get.back();

    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: AppLocalizations.of(Get.context!)!.logout,
      description: AppLocalizations.of(Get.context!)!.logout_confirmation,
      confirmationTitle:
          AppLocalizations.of(Get.context!)!.logout_confirmation_button,
    );

    if (_dialogResponse?.confirmed ?? false) {
      onLogout();
      selectedIndex = 0;
      SnackBarUtils.showDark(
        AppLocalizations.of(Get.context!)!.logout_success,
        AppLocalizations.of(Get.context!)!.logout_success_acknowledgement,
      );
    }
  }
}
