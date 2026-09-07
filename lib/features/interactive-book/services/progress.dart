import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';

enum TopicStatus { completed, inProgress, notStarted }

/// Tracks which sub-chapters the reader has opened.
///
/// A topic counts as completed once it has been opened, and the topic that is
/// currently on screen is reported separately as in-progress. Chapter intro
/// pages (`sub_chapter_id == 0`) are navigation landings rather than topics, so
/// they are excluded from every count — this keeps a chapter's percentage
/// consistent with the rows shown underneath it in the drawer.
class BookProgress extends ChangeNotifier {
  static const String boxName = 'ib_progress';
  static const String _visitedKey = 'visited';

  final Set<String> _visited = <String>{};

  Box? _box;
  bool _disposed = false;
  int _currentChapter = -1;
  int _currentSubChapter = -1;

  static String _key(int chapter, int subChapter) => '$chapter:$subChapter';

  Future<void> load() async {
    try {
      _box =
          Hive.isBoxOpen(boxName)
              ? Hive.box(boxName)
              : await Hive.openBox(boxName);

      final stored = _box?.get(_visitedKey);
      if (stored is List) {
        _visited.addAll(stored.map((e) => e.toString()));
      }
    } catch (_) {
      // Storage is unavailable — progress still works, it just won't survive
      // a restart.
      _box = null;
    }
    _notify();
  }

  Future<void> _persist() async {
    try {
      await _box?.put(_visitedKey, _visited.toList());
    } catch (_) {
      // Losing a write is not worth interrupting navigation for.
    }
  }

  /// Records a page the reader has navigated to. Intro pages move the
  /// in-progress marker without ever being counted as a completed topic.
  Future<void> visit(int chapter, int subChapter) async {
    _currentChapter = chapter;
    _currentSubChapter = subChapter;

    if (subChapter > 0 && _visited.add(_key(chapter, subChapter))) {
      await _persist();
    }
    _notify();
  }

  /// Clears the in-progress marker, e.g. when the reader returns to the home
  /// page and is no longer sitting on any topic.
  void clearCurrent() {
    _currentChapter = -1;
    _currentSubChapter = -1;
    _notify();
  }

  Future<void> reset() async {
    _visited.clear();
    await _persist();
    _notify();
  }

  TopicStatus statusOf(int chapter, int subChapter) {
    if (_currentChapter == chapter && _currentSubChapter == subChapter) {
      return TopicStatus.inProgress;
    }
    return _visited.contains(_key(chapter, subChapter))
        ? TopicStatus.completed
        : TopicStatus.notStarted;
  }

  bool isCurrentChapter(int chapter) => _currentChapter == chapter;

  int completedIn(Chapter chapter) {
    return chapter.subChapters
        .where((s) => _visited.contains(_key(chapter.id, s.id)))
        .length;
  }

  double chapterProgress(Chapter chapter) {
    if (chapter.subChapters.isEmpty) return 0;
    return completedIn(chapter) / chapter.subChapters.length;
  }

  int totalTopics(List<Chapter> chapters) {
    return chapters.fold(0, (sum, c) => sum + c.subChapters.length);
  }

  int completedTopics(List<Chapter> chapters) {
    return chapters.fold(0, (sum, c) => sum + completedIn(c));
  }

  double overallProgress(List<Chapter> chapters) {
    final total = totalTopics(chapters);
    if (total == 0) return 0;
    return completedTopics(chapters) / total;
  }

  /// First topic the reader has not opened yet, used by the drawer footer to
  /// jump back to where they left off. Returns `null` once the book is done.
  ({int chapter, int subChapter})? nextUnread(List<Chapter> chapters) {
    for (final chapter in chapters) {
      for (final sub in chapter.subChapters) {
        if (!_visited.contains(_key(chapter.id, sub.id))) {
          return (chapter: chapter.id, subChapter: sub.id);
        }
      }
    }
    return null;
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
