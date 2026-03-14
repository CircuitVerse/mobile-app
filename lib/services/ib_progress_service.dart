import 'package:shared_preferences/shared_preferences.dart';

class IbProgressService {

  Future<void> saveProgress({
    required String bookId,
    required String chapterId,
    required double progress,
    required double scrollPosition,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('${bookId}_chapter', chapterId);
    await prefs.setDouble('${chapterId}_progress', progress);
    await prefs.setDouble('${chapterId}_scroll', scrollPosition);
  }

  Future<double?> getScrollPosition(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${chapterId}_scroll');
  }

  Future<double?> getProgress(String chapterId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('${chapterId}_progress');
  }

  Future<String?> getLastChapter(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('${bookId}_chapter');
  }
}