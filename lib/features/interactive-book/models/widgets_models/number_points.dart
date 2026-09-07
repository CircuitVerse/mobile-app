import 'package:mobile_app/features/interactive-book/models/models.dart';

class ItemModel {
  String content;
  List<String> children;

  ItemModel({required this.content, required this.children});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      content: json['content'] ?? '',
      children: List<String>.from(json['children'] ?? []),
    );
  }
}

class NumberPointsModel extends ViewModel {
  final List<ItemModel> items;

  NumberPointsModel({
    required super.type,
    required super.subType,
    required this.items,
  });

  factory NumberPointsModel.fromJson(Map<String, dynamic> json) {
    return NumberPointsModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      items: List<ItemModel>.from(
        json['items']?.map((e) => ItemModel.fromJson(e)) ?? [],
      ),
    );
  }
}
