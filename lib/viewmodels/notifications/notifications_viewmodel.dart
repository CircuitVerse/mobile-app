import 'package:mobile_app/cache/cache_keys.dart';
import 'package:mobile_app/cache/cache_service.dart';
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
  final _cache = CacheService.instance;

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
      // Invalidate so the next fetch hits the network and the badge updates.
      _cache.invalidate(CacheKeys.notifications);
      hasUnread = await fetchNotifications();
      setStateFor(MARK_AS_READ, ViewState.Idle);
    } on Failure catch (f) {
      setStateFor(MARK_AS_READ, ViewState.Error);
      setErrorMessageFor(MARK_AS_READ, f.message);
    }
  }

  Future<bool> fetchNotifications() async {
    if (!_storageService.isLoggedIn) return false;

    // ── Cache hit ─────────────────────────────────────────────────────────
    // fetchNotifications() is called twice in quick succession every time
    // the app starts:
    //   1. CVLandingViewModel.setUser() — to show the red dot on the menu icon.
    //   2. NotificationsView.onModelReady() — to populate the list.
    // The second call fires within ~300 ms of the first. The cache prevents
    // a redundant network round-trip.  TTL is short (10 min) so the list stays
    // fresh; mark-as-read always invalidates immediately.
    final cached = _cache.get<_NotificationCache>(CacheKeys.notifications);
    if (cached != null) {
      _notifications = List.from(cached.notifications);
      hasUnread = cached.hasUnread;
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Success);
      notifyListeners();
      return hasUnread;
    }

    // ── Cache miss: network fetch ──────────────────────────────────────────
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
        break;
      }
    }

    // Store in cache only on success.
    if (isSuccess(FETCH_NOTIFICATIONS)) {
      _cache.set(
        CacheKeys.notifications,
        _NotificationCache(
          notifications: List.from(_notifications),
          hasUnread: hasUnread,
        ),
        ttl: CacheKeys.notificationsTtl,
      );
    }

    return hasUnread;
  }
}

/// Private value-object stored in the cache.
class _NotificationCache {
  const _NotificationCache({
    required this.notifications,
    required this.hasUnread,
  });
  final List<Notification> notifications;
  final bool hasUnread;
}
