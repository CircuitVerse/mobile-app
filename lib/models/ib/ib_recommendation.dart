class IbRecommendation {
  final String title;
  final String url;
  final String? image;

  IbRecommendation({
    required this.title,
    required this.url,
    this.image,
  });

  factory IbRecommendation.fromJson(Map<String, dynamic> json) {
    return IbRecommendation(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      image: json['image'],
    );
  }
}
