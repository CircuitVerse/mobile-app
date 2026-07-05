import 'package:mobile_app/features/interactive-book/models/view.dart';

class TextModel extends ViewModel {
  String size;
  String content;

  TextModel({
    required super.type,
    required this.size,
    required this.content,
  });

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      content: json['content'] ?? '',
    );
  }
}