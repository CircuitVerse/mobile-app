import 'package:flutter/foundation.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/chapter_contents/items.dart';
import 'package:mobile_app/features/interactive-book/models/view.dart';

class ChapterContentsModel extends ViewModel {
  final List<ChapterItemsModel> items;

  ChapterContentsModel({
    required super.type,
    required super.subType,
    required this.items,
  });

  factory ChapterContentsModel.fromJson(Map<String, dynamic> json) {
    debugPrint("Parsing ChapterContentsModel from JSON: $json");
    return ChapterContentsModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((e) => ChapterItemsModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}
