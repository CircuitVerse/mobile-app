import 'package:mobile_app/features/interactive-book/models/view.dart';

class ScreenModel {
  final String name;
  final List<ViewModel> views;

  ScreenModel({
    required this.name,
    required this.views,
  });

  factory ScreenModel.fromJson(Map<String, dynamic> json) {
    return ScreenModel(
      name: json['name'],
      views: (json['views'] as List<dynamic>? ?? [])
          .map((e) => ViewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}