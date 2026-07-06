import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/features/interactive-book/models/screen.dart';

class BookService {
  Future<ScreenModel> getChapters({String subChapterId = '*'}) async {
    final response = await http.get(
      // TODO: Replace with HOSTED BASE URL
      Uri.parse(
        "http://127.0.0.1:8000?chapter_id=1&sub_chapter_id=$subChapterId",
      ),
    );

    if (response.statusCode == 200) {
      return ScreenModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load chapters");
  }
}
