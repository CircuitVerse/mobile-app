import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/interactive-book/models/screen.dart';

class BookService {
  Future<ScreenModel> getChapters({String chapterId = '1', String subChapterId = '0'}) async {
    String BASE_URL_DEV = "http://localhost:8000";
    String BASE_URL_PROD = "https://cv-mobile-backend.fastapicloud.dev";
    final response = await http.get(
      Uri.parse("$BASE_URL_PROD/?chapter_id=$chapterId&sub_chapter_id=$subChapterId"),
    );

    if (response.statusCode == 200) {
      return ScreenModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load chapters");
  }
}
