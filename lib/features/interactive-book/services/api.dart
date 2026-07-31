/// Endpoints for the dedicated Interactive Book backend.
class IbApi {
  IbApi._();

  static const String baseUrlDev = "http://localhost:8000";
  static const String baseUrlProd =
      "https://cv-mobile-backend.fastapicloud.dev";

  static const String baseUrl = baseUrlProd;

  static Uri navbar() => Uri.parse("$baseUrl/navbar");

  static Uri page(int chapterId, int subChapterId) =>
      Uri.parse("$baseUrl/?chapter_id=$chapterId&sub_chapter_id=$subChapterId");
}
