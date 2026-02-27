import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/models/ib/ib_recommendation.dart';

abstract class DisqusApi {
  Future<List<IbRecommendation>> fetchRecommendations(String threadUrl);
}

class DisqusApiImpl implements DisqusApi {
  static const String _apiKey = 'E8Uh5l5fHZ6gD8U3KycjAIAk46f68Zw7C6eW8WSjZvCLXebZ7p0r1yrYDrLilk2F';
  static const String _forum = 'interactive-book';
  static const String _baseUrl = 'https://disqus.com/api/3.0';

  @override
  Future<List<IbRecommendation>> fetchRecommendations(String threadUrl) async {
    try {
      final encodedUrl = Uri.encodeComponent(threadUrl);
      final url = Uri.parse(
        '$_baseUrl/discovery/listRecommendations.json?forum=$_forum&thread=url:$encodedUrl&limit=8&api_key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['response']['items'] as List? ?? [];
        
        return items
            .map((item) => IbRecommendation.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      return [];
    }
  }
}
