class ChapterContentsItemsContentModel {
  int id;
  String name;

  ChapterContentsItemsContentModel({required this.id, required this.name});

  factory ChapterContentsItemsContentModel.fromJson(Map<String, dynamic> json) {
    return ChapterContentsItemsContentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ChapterItemsModel {
  String category;
  List<ChapterContentsItemsContentModel> content;

  ChapterItemsModel({required this.category, required this.content});

  factory ChapterItemsModel.fromJson(Map<String, dynamic> json) {
    return ChapterItemsModel(
      category: json['category'] ?? '',
      content:
          (json['content'] as List<dynamic>? ?? [])
              .map(
                (e) => ChapterContentsItemsContentModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}
