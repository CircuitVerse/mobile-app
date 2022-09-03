import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/notification.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/notifications_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class NotificationsViewModel extends BaseModel {
  // State keys
  final String FETCH_NOTIFICATIONS = 'fetch_notifications';
  final String MARK_AS_READ = 'mark_as_read';
  final String MARK_ALL_AS_READ = 'mark_all_as_read';

  // Service
  final _notificationService = locator<NotificationsService>();
  final _storageService = locator<LocalStorageService>();

  List<Notification>? _notifications;

  List<Notification> get notifications => _notifications ?? [];

  set notification(List<Notification>? notif) {
    _notifications = notif;
    notifyListeners();
  }

  void fetchNotifications() async {
    if (!_storageService.isLoggedIn) return;

    try {
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Busy);
      _notifications = await _notificationService.fetchNotifications();
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Error);
      setErrorMessageFor(FETCH_NOTIFICATIONS, f.message);
    }
  }
}
