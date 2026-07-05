import 'package:mobile_app/features/interactive-book/models/view.dart';

class TocModel extends ViewModel {
  final List<String> items;

  TocModel({
    required String type,
    required String subType,
    required this.items,
  }) : super(type: type, subType: subType);

  factory TocModel.fromJson(Map<String, dynamic> json) {
    return TocModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      items: List<String>.from(json['Items'] ?? []),
    );
  }
}