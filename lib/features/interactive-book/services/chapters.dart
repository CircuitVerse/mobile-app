import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/interactive-book/models/page.dart';
import 'package:mobile_app/features/interactive-book/models/screen.dart';
import 'package:mobile_app/features/interactive-book/services/api.dart';
import 'package:mobile_app/features/interactive-book/services/offline.dart';

class BookChaptersService {
  /// Fetches a chapter page, preferring the network so downloaded content
  /// stays fresh and falling back to the offline cache when the request fails.
  Future<ScreenModel> getChapters({
    String chapterId = '1',
    String subChapterId = '0',
  }) {
    final chapter = int.tryParse(chapterId) ?? 1;
    final subChapter = int.tryParse(subChapterId) ?? 0;

    return _load(
      IbApi.page(chapter, subChapter),
      OfflineLibrary.pageKey(chapter, subChapter),
    );
  }

  /// Fetches About or Guidelines. Both endpoints return the same
  /// `{ name, views }` shape as a chapter page, so the renderer handles them
  /// without any special casing.
  Future<ScreenModel> getStaticPage(IbPage page) {
    return _load(
      page == IbPage.about ? IbApi.about() : IbApi.guidelines(),
      OfflineLibrary.staticKey(page),
    );
  }

  Future<ScreenModel> _load(Uri uri, String cacheKey) async {
    try {
      final response = await http.get(uri);

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
