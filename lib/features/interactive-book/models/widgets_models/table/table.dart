import 'package:mobile_app/features/interactive-book/models/view.dart';

class TableModel extends ViewModel {
  final List<String> heading;
  final List<List<String>> rows;

  TableModel({
    required super.type,
    required super.subType,
    required this.heading,
    required this.rows,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>? ?? {};
    return TableModel(
      type: json['type'] ?? '',
      subType: json['sub_type'] ?? '',
      heading: List<String>.from(content['heading'] as List<dynamic>? ?? []),
      rows: (content['rows'] as List<dynamic>? ?? [])
          .map((row) => List<String>.from(row as List<dynamic>))
          .toList(),
    );
  }
}
