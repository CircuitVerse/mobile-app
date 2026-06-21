import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class BookService {
  Future<BookResponse> getChapters() async {
    final response = await http.get(
      // TODO: Replace with HOSTED BASE URL
      Uri.parse(
        "https://2990a5ac-b345-4141-bd0a-99e9963fbf5f.mock.pstmn.io/interactive-book/navbar",
      ),
    );

    if (response.statusCode == 200) {
      return BookResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load chapters");
  }
}
