import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/models/page.dart';
import 'package:mobile_app/features/interactive-book/services/api.dart';

enum DownloadState { idle, downloading, done, failed }

/// Service for caching the book's content for offline use.
/// The cache is stored in a Hive box, which is a key-value store that persists across app restarts
class OfflineLibrary extends ChangeNotifier {
  static const String boxName = 'ib_offline';
  static const String navbarKey = 'navbar';

  static String pageKey(int chapter, int subChapter) =>
      'page:$chapter:$subChapter';

  /// Cache key for the About and Guidelines pages.
  static String staticKey(IbPage page) => 'static:${page.name}';

  /// Standalone pages that are downloaded alongside the chapters.
  static const List<IbPage> staticPages = [IbPage.about, IbPage.guidelines];

  DownloadState _state = DownloadState.idle;
  int _done = 0;
  int _total = 0;
  int _bytes = 0;
  String? _error;
  bool _disposed = false;

  DownloadState get state => _state;
  int get done => _done;
  int get total => _total;
  int get bytes => _bytes;
  String? get error => _error;

  bool get isDownloading => _state == DownloadState.downloading;
  bool get hasContent => _bytes > 0;

  double get downloadProgress => _total == 0 ? 0 : _done / _total;

  static Future<Box> openBox() async {
    return Hive.isBoxOpen(boxName)
        ? Hive.box(boxName)
        : await Hive.openBox(boxName);
  }

  /// Cached response body, or `null` when the key has never been downloaded.
  static Future<String?> read(String key) async {
    try {
      final box = await openBox();
      final value = box.get(key);
      return value is String ? value : null;
    } catch (_) {
      // A cache miss must never break a request that could still hit network.
      return null;
    }
  }

  static Future<void> write(String key, String body) async {
    try {
      final box = await openBox();
      await box.put(key, body);
    } catch (_) {
      // Storage failures are not worth failing a successful fetch over.
    }
  }

  /// Loads the cached size so the card can show it before any download runs.
  Future<void> refresh() async {
    _bytes = await _measure();
    if (_state == DownloadState.idle && _bytes > 0) {
      _state = DownloadState.done;
    }
    _notify();
  }

  /// Size of the cached payloads in UTF-8 bytes.
  Future<int> _measure() async {
    try {
      final box = await openBox();
      var total = 0;
      for (final value in box.values) {
        if (value is String) total += utf8.encode(value).length;
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  /// Fetches and caches every page in the book. Individual page failures are
  /// tolerated — the download is reported as failed only if nothing landed.
  Future<void> downloadAll(InteractiveBookNavbarModel navbar) async {
    if (isDownloading) return;

    // Everything the book needs offline: the chapter tree, every chapter and
    // sub-chapter page, and the two standalone pages.
    final requests = <({Uri uri, String key})>[
      (uri: IbApi.navbar(), key: navbarKey),
    ];

    for (final chapter in navbar.chapters) {
      // Sub-chapter 0 is the chapter intro page.
      requests.add((
        uri: IbApi.page(chapter.path, 0),
        key: pageKey(chapter.id, 0),
      ));
      for (final sub in chapter.subChapters) {
        requests.add((
          uri: IbApi.page(chapter.path, sub.id),
          key: pageKey(chapter.id, sub.id),
        ));
      }
    }

    for (final page in staticPages) {
      requests.add((
        uri: page == IbPage.about ? IbApi.about() : IbApi.guidelines(),
        key: staticKey(page),
      ));
    }

    _state = DownloadState.downloading;
    _error = null;
    _done = 0;
    _total = requests.length;
    _notify();

    var failures = 0;

    for (final request in requests) {
      if (_disposed) return;
      try {
        final response = await http.get(request.uri);
        if (response.statusCode == 200) {
          await write(request.key, response.body);
        } else {
          failures++;
        }
      } catch (_) {
        failures++;
      }
      _done++;
      _notify();
    }

    _bytes = await _measure();

    if (failures == _total) {
      _state = DownloadState.failed;
      _error = 'Download failed. Check your connection and try again.';
    } else {
      _state = DownloadState.done;
      _error =
          failures > 0
              ? '$failures of $_total items could not be downloaded.'
              : null;
    }
    _notify();
  }

  Future<void> clear() async {
    try {
      final box = await openBox();
      await box.clear();
    } catch (_) {
      // Nothing to do — the card re-measures below either way.
    }
    _bytes = await _measure();
    _done = 0;
    _total = 0;
    _error = null;
    _state = DownloadState.idle;
    _notify();
  }

  /// Human-readable cache size, e.g. `1.4 MB`.
  String get formattedSize => formatBytes(_bytes);

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
