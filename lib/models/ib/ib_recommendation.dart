class IbRecommendation {
  final String title;
  final String url;
  final String? image;
  final String? createdAt;
  final int? posts;

  IbRecommendation({
    required this.title,
    required this.url,
    this.image,
    this.createdAt,
    this.posts,
  });

  factory IbRecommendation.fromJson(Map<String, dynamic> json) {
    return IbRecommendation(
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      image: json['image'],
      createdAt: json['createdAt'],
      posts: json['posts'],
    );
  }
}
