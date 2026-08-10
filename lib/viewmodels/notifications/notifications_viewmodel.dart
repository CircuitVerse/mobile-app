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

  // Services
  final _notificationService = locator<NotificationsService>();
  final _storageService = locator<LocalStorageService>();
  final _cache = CacheService.instance;

  // Prevents duplicate simultaneous network fetches.
  // Two callers (CVLandingViewModel.setUser + NotificationsView.onModelReady)
  // fire within ~300 ms of each other on every app start.
  Future<bool>? _inflightFetch;

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

      // Invalidate cache AND clear any in-flight fetch so markAsRead always
      // triggers a fresh network call. Without this, fetchNotifications() below
      // could await a stale in-flight request that was started before the
      // mark-as-read and would re-apply the old unread state.
      _cache.invalidate(CacheKeys.notifications);
      _inflightFetch = null;

      hasUnread = await _doFetchNotifications();
      setStateFor(MARK_AS_READ, ViewState.Idle);
    } on Failure catch (f) {
      setStateFor(MARK_AS_READ, ViewState.Error);
      setErrorMessageFor(MARK_AS_READ, f.message);
    }
  }

  Future<bool> fetchNotifications() async {
    if (!_storageService.isLoggedIn) return false;

    // Cache hit
    // Return instantly if fresh data is already in cache.
    final cached = _cache.get<_NotificationCache>(CacheKeys.notifications);
    if (cached != null) {
      _notifications = List.from(cached.notifications);
      hasUnread = cached.hasUnread;
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Success);
      notifyListeners();
      return hasUnread;
    }

    // In-flight deduplication
    // a duplicate. The try/finally guarantees _inflightFetch is cleared
    // whether the request succeeds, fails, or throws.
    if (_inflightFetch != null) return _inflightFetch!;

    _inflightFetch = _doFetchNotifications();
    try {
      return await _inflightFetch!;
    } finally {
      _inflightFetch = null;
    }
  }

  Future<bool> _doFetchNotifications() async {
    //  Session identity snapshot
    // Capture the current user token before any await. If logout happens
    // while the request is in flight, the response arrives for a session
    // that no longer exists. We discard the result in that case to prevent
    // old-session data from repopulating _notifications and the cache.
    final sessionToken = _storageService.token;

    _notifications.clear();
    hasUnread = false;

    try {
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Busy);
      final fetched = await _notificationService.fetchNotifications() ?? [];
      setStateFor(FETCH_NOTIFICATIONS, ViewState.Success);

      // Discard result if the user logged out during the request.
      if (_storageService.token != sessionToken) return false;

      notifications = fetched;
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

    // Store in cache only on a successful fetch for the same session.
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
