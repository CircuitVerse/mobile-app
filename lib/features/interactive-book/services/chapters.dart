import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/interactive-book/models/screen.dart';
import 'package:mobile_app/features/interactive-book/services/api.dart';
import 'package:mobile_app/features/interactive-book/services/offline.dart';

class BookService {
  /// Fetches a page, preferring the network so downloaded content stays fresh
  /// and falling back to the offline cache when the request fails.
  Future<ScreenModel> getChapters({
    String chapterId = '1',
    String subChapterId = '0',
  }) async {
    final chapter = int.tryParse(chapterId) ?? 1;
    final subChapter = int.tryParse(subChapterId) ?? 0;
    final cacheKey = OfflineLibrary.pageKey(chapter, subChapter);

    try {
      final response = await http.get(IbApi.page(chapter, subChapter));

      if (response.statusCode == 200) {
        await OfflineLibrary.write(cacheKey, response.body);
        return ScreenModel.fromJson(jsonDecode(response.body));
      }
    } catch (_) {
      // Fall through to the cache below.
    }

    final cached = await OfflineLibrary.read(cacheKey);
    if (cached != null) {
      return ScreenModel.fromJson(jsonDecode(cached));
    }

    throw Exception("Failed to load chapters");
  }
}
