class HeadingModel {
  List<String> heading;

  HeadingModel ({
    required this.heading,
  });

  factory HeadingModel .fromJson(Map<String, dynamic> json) {
    return HeadingModel (
      heading: List<String>.from(json['heading'] as List<dynamic>),
    );
  }
}

class RowModel{
  List<List<String>> rows;

  RowModel({
    required this.rows,
  });

  factory RowModel.fromJson(Map<String, dynamic> json) {
    return RowModel(
      rows: List<List<String>>.from(
        (json['rows'] as List<dynamic>).map(
          (row) => List<String>.from(row as List<dynamic>),
        ),
      ),
    );
  }
}

class ContentModel {
  final String type;
  final String subType;
  final List<List<String>> data;

  ContentModel({
    required this.type,
    required this.subType,
    required this.data,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      type: json['type'],
      subType: json['sub_type'],
      data: List<List<String>>.from(
        (json['data'] as List<dynamic>).map(
          (row) => List<String>.from(row as List<dynamic>),
        ),
      ),
    );
  }
}