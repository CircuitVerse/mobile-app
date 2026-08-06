import 'package:mobile_app/features/interactive-book/models/view.dart';

class Content{
  final String link;
  Content({required this.link});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      link: json['link'] ?? '',
    );
  }
}

class ImageModel extends ViewModel {
  final Content content;

  ImageModel({
    required super.type,
    required super.subType,
    required this.content
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      content: Content.fromJson(json['content'] as Map<String, dynamic>)
    );
  }
}