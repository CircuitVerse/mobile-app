import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class BookService {
  Future<InteractiveBookNavbarModel> getChapters() async {
    String BASE_URL_DEV = "http://localhost:8000";
    String BASE_URL_PROD = "https://cv-mobile-backend.fastapicloud.dev";

    final response = await http.get(
      Uri.parse(
        "$BASE_URL_PROD/navbar",
      ),
    );

    if (response.statusCode == 200) {
      return InteractiveBookNavbarModel.fromJson(jsonDecode(response.body));
    }

    throw Exception("Failed to load chapters");
  }
}
