import 'package:mobile_app/features/interactive-book/models/view.dart';

class BinarySimulatorModel extends ViewModel {
  const BinarySimulatorModel({required super.type, required super.subType});

  factory BinarySimulatorModel.fromJson(Map<String, dynamic> json) {
    return BinarySimulatorModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
    );
  }
}
