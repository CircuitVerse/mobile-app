import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/notifications_service.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:mobile_app/viewmodels/notifications/notifications_viewmodel.dart';
import 'dart:async';

class CVLandingViewModel extends BaseModel {
  final LocalStorageService _storage = locator<LocalStorageService>();
  final DialogService _dialogService = locator<DialogService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final NotificationsViewModel _viewModel = locator<NotificationsViewModel>();

  User? _currentUser;
  int _selectedIndex = 0;
  
  // Polling timer for notifications
  Timer? _notificationPollingTimer;
  
  // Track last notification count to detect new ones
  int _lastNotificationCount = 0;
  
  // Navigation stream subscription
  StreamSubscription<bool>? _navigationSubscription;

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

  // Start polling for notifications
  void startNotificationPolling() {
    _notificationPollingTimer?.cancel();
    
    if (_storage.isLoggedIn) {
      // Initialize the count
      _lastNotificationCount = _viewModel.notifications.length;
      
      // Poll every 10 seconds
      _notificationPollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (_storage.isLoggedIn) {
          final previousCount = _viewModel.notifications.length;
          _viewModel.fetchNotifications(silent: true).then((value) async {
            hasPendingNotif = value;
            final currentCount = _viewModel.notifications.length;
            
            // Check if there are new notifications
            if (currentCount > previousCount) {
              final newNotificationsCount = currentCount - previousCount;
              
              // Show local notification for new notifications
              await NotificationsServiceImpl.showLocalNotification(
                title: 'CircuitVerse',
                body: newNotificationsCount == 1
                    ? 'You have 1 new notification'
                    : 'You have $newNotificationsCount new notifications',
              );
            }
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  // Stop polling
  void stopNotificationPolling() {
    _notificationPollingTimer?.cancel();
  }

  @override
  void dispose() {
    _notificationPollingTimer?.cancel();
    _navigationSubscription?.cancel();
    super.dispose();
  }

  void onLogout() async {
    _storage.isLoggedIn = false;
    _storage.currentUser = null;
    _storage.token = null;

    // Stop notification polling on logout
    stopNotificationPolling();

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
    // Start polling for new notifications
    startNotificationPolling();
    // Listen for navigation events from notifications
    _navigationSubscription = NotificationsServiceImpl.navigateToNotificationsStream.listen((_) {
      selectedIndex = 8;
    });
  }

  void onProfileUpdated() {
    final _updatedUser = _storage.currentUser;
    if (_currentUser?.data.attributes.name ==
        _updatedUser?.data.attributes.name) {
      return;
    }

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
      title: AppLocalizations.of(Get.context!)!.cv_logout,
      description: AppLocalizations.of(Get.context!)!.cv_logout_confirmation,
      confirmationTitle:
          AppLocalizations.of(Get.context!)!.cv_logout_confirmation_button,
    );

    if (_dialogResponse?.confirmed ?? false) {
      onLogout();
      selectedIndex = 0;
      SnackBarUtils.showDark(
        AppLocalizations.of(Get.context!)!.cv_logout_success,
        AppLocalizations.of(Get.context!)!.cv_logout_success_acknowledgement,
      );
    }
  }
}
