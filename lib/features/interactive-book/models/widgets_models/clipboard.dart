import 'package:mobile_app/features/interactive-book/models/view.dart';

class ClipboardModel extends ViewModel {
  final String content;

  ClipboardModel({
    required super.type,
    required super.subType,
    required this.content,
  });

  factory ClipboardModel.fromJson(Map<String, dynamic> json) {
    return ClipboardModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
