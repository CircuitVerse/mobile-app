import 'package:mobile_app/features/interactive-book/models/view.dart';

class GeneralModel extends ViewModel {
  const GeneralModel({required super.type, required super.subType});

  factory GeneralModel.fromJson(Map<String, dynamic> json) {
    return GeneralModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
    );
  }
}
