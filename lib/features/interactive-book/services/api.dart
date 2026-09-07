import 'package:mobile_app/config/environment_config.dart';

/// Endpoints for the Interactive Book content API.
///
/// The host is supplied by [EnvironmentConfig.IB_API_BASE_URL] so it can be
/// pointed at a local backend at build time:
/// `flutter run --dart-define=IB_API_BASE_URL=http://localhost:8000/api`
class IbApi {
  IbApi._();

  static String get _baseUrl => EnvironmentConfig.IB_API_BASE_URL;

  static Uri navbar() => Uri.parse('$_baseUrl/navbar.json');

  static Uri about() => Uri.parse('$_baseUrl/about.json');

  static Uri guidelines() => Uri.parse('$_baseUrl/guidelines.json');

  /// A chapter page, addressed by the chapter's slug. Sub-chapter `0` is the
  /// chapter's intro page.
  static Uri page(String chapterPath, int subChapterId) =>
      Uri.parse('$_baseUrl/$chapterPath/$subChapterId.json');
}
