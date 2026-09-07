import 'package:mobile_app/features/interactive-book/models/models.dart';

class BulletPointsModel extends ViewModel {
  List<String> items;

  BulletPointsModel({
    required super.type,
    required super.subType,
    required this.items,
  });

  factory BulletPointsModel.fromJson(Map<String, dynamic> json) {
    return BulletPointsModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      items: List<String>.from(json['items'] ?? []),
    );
  }
}
