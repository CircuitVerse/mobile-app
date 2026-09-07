import 'package:mobile_app/features/interactive-book/models/view.dart';

class TextModel extends ViewModel {
  String size;
  String content;

  /// Optional in-page anchor. When present, this section is a scroll target
  /// for a TOC entry whose index equals this id.
  int? scrollToId;

  TextModel({
    required super.type,
    required this.size,
    required this.content,
    this.scrollToId,
  });

  factory TextModel.fromJson(Map<String, dynamic> json) {
    return TextModel(
      type: json['type'] ?? '',
      size: json['size'] ?? '',
      content: json['content'] ?? '',
      scrollToId: json['scrollToId'] as int?,
    );
  }
}
