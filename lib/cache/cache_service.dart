/// Lightweight in-memory cache with optional TTL (time-to-live).
///
/// Design constraints:
///   - No new packages: uses only Dart core.
///   - Generic: works for any serialisable value.
///   - Thread-safe within a single Dart isolate (Dart is single-threaded).
///   - TTL is optional. Pass null to cache indefinitely for the session.
///
/// Usage:
///   final _cache = CacheService();
///   _cache.set('key', value, ttl: Duration(minutes: 5));
///   final val = _cache.get<MyType>('key');  // null if missing/expired
class CacheService {
  CacheService._();
  static final CacheService instance = CacheService._();

  final Map<String, _CacheEntry<dynamic>> _store = {};

  /// Store [value] under [key].
  ///
  /// [ttl] – how long the entry stays valid.
  ///         Pass `null` to keep it for the entire app session.
  void set<T>(String key, T value, {Duration? ttl}) {
    final expiry = ttl == null ? null : DateTime.now().add(ttl);
    _store[key] = _CacheEntry<T>(value: value, expiry: expiry);
  }

  /// Retrieve a value. Returns `null` if the key is absent or expired.
  T? get<T>(String key) {
    final entry = _store[key];
    if (entry == null) return null;
    if (entry.expiry != null && DateTime.now().isAfter(entry.expiry!)) {
      _store.remove(key);
      return null;
    }
    return entry.value as T?;
  }

  /// Returns true if the key exists and has not expired.
  bool has(String key) => get<dynamic>(key) != null;

  /// Explicitly remove a single key (e.g. after a mutation).
  void invalidate(String key) => _store.remove(key);

  /// Remove all entries whose key starts with [prefix].
  void invalidatePrefix(String prefix) {
    _store.removeWhere((k, _) => k.startsWith(prefix));
  }

  /// Clear the entire cache (e.g. on logout).
  void clear() => _store.clear();
}

class _CacheEntry<T> {
  _CacheEntry({required this.value, this.expiry});
  final T value;
  final DateTime? expiry;
}
