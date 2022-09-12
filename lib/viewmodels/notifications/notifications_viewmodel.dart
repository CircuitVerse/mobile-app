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

  // Notifications
  List<Notification> _notifications = [];

  List<Notification> get notifications => _notifications;

  set notifications(List<Notification> notif) {
    _notifications = notif;
    notifyListeners();
  }

  bool hasUnread = false;

  // Dropdown value
  String _value = 'All';

  String get value => _value;

  set value(String val) {
    _value = val;
    notifyListeners();
  }

  void markAsRead(String id) async {
    try {
      setStateFor(MARK_AS_READ, ViewState.Busy);
      await _notificationService.markAsRead(id);
      hasUnread = await fetchNotifications();
      setStateFor(MARK_AS_READ, ViewState.Idle);
    } on Failure catch (f) {
      setStateFor(MARK_AS_READ, ViewState.Error);
      setErrorMessageFor(MARK_AS_READ, f.message);
    }
  }

  Future<bool> fetchNotifications() async {
    if (!_storageService.isLoggedIn) return false;

    _notifications.clear();
    hasUnread = false;

    try {
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Busy);
      notifications = await _notificationService.fetchNotifications() ?? [];
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Error);
      setErrorMessageFor(FETCH_NOTIFICATIONS, f.message);
    }

    for (final notif in notifications) {
      if (notif.attributes.unread) {
        hasUnread = true;
        return true;
      }
    }

    return false;
  }
}
