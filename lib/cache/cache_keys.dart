/// All cache keys used across the app.
///
/// Centralised here so:
///   - Keys never diverge between setter and getter.
///   - Prefixes make prefix-based invalidation safe.
abstract class CacheKeys {
  // ── Contributors ────────────────────────────────────────────────
  /// GitHub contributors list.  Cached for [contributorsTtl].
  static const String contributors = 'contributors';

  // ── User profile ────────────────────────────────────────────────
  /// Prefix for per-user profile responses from /users/:id.
  /// Full key: 'user_profile:<userId>'
  static const String userProfilePrefix = 'user_profile:';

  /// Build the full profile cache key for a given user ID.
  static String userProfile(String userId) => '$userProfilePrefix$userId';

  // ── Interactive Book page data ───────────────────────────────────
  /// Prefix for parsed IbPageData objects (after HTML processing).
  /// Full key: 'ib_page:<pageId>'
  static const String ibPagePrefix = 'ib_page:';

  /// Build the full IB page cache key for a given page ID.
  static String ibPage(String pageId) => '$ibPagePrefix$pageId';

  // ── Notifications ────────────────────────────────────────────────
  /// Cached notification list so the dot badge and the full list
  /// share one network call per session open.
  static const String notifications = 'notifications';

  // ─── TTL constants ──────────────────────────────────────────────
  /// Contributors list refreshes once per session (GitHub data is stable).
  static const Duration contributorsTtl = Duration(hours: 12);

  /// User profile data is semi-stable; refresh every 5 minutes.
  static const Duration userProfileTtl = Duration(minutes: 5);

  /// IB page markdown rarely changes; cache for the full session.
  static const Duration ibPageTtl = Duration(hours: 6);

  /// Notifications badge + list: refresh once per session open, then only
  /// on explicit user action (mark-as-read).
  static const Duration notificationsTtl = Duration(minutes: 10);
}
