import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';

abstract class DisqusApi {
  Future<List<IbRecommendation>> fetchRecommendations(String threadUrl);
}

class DisqusApiImpl implements DisqusApi {
  static const String _apiKey = 'E8Uh5l5fHZ6gD8U3KycjAIAk46f68Zw7C6eW8WSjZvCLXebZ7p0r1yrYDrLilk2F';
  static const String _forum = 'interactive-book';
  static const String _baseUrl = 'https://disqus.com/api/3.0';
  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<List<IbRecommendation>> fetchRecommendations(String threadUrl) async {
    try {
      final encodedUrl = Uri.encodeComponent(threadUrl);
      final url = Uri.parse(
        '$_baseUrl/discovery/listRecommendations.json?forum=$_forum&thread=url:$encodedUrl&limit=8&api_key=$_apiKey',
      );

      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if response is successful
        if (data['code'] == 0) {
          final items = data['response'] as List? ?? [];

          return items.map((item) {
            // Extract image URL from images array
            String? imageUrl;
            if (item['images'] != null && (item['images'] as List).isNotEmpty) {
              final rawUrl = item['images'][0]['url'] as String;
              // Handle protocol-relative URLs
              if (rawUrl.startsWith('//')) {
                imageUrl = 'https:$rawUrl';
              } else if (!rawUrl.startsWith('http')) {
                imageUrl = 'https://$rawUrl';
              } else {
                imageUrl = rawUrl;
              }
            }

            return IbRecommendation(
              title: item['title'] ?? '',
              url: item['url'] ?? '',
              image: imageUrl,
              createdAt: item['createdAt'],
              posts: item['posts'],
            );
          }).toList();
        }
      }
      return [];
    } on TimeoutException catch (e) {
      return [];
    } catch (e) {
      return [];
    }
  }
}
