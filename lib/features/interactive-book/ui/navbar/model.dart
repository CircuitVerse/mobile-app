class SubChapter {
  final int id;
  final String name;

  SubChapter({required this.id, required this.name});

  factory SubChapter.fromJson(Map<String, dynamic> json) {
    return SubChapter(id: json["id"], name: json["name"]);
  }
}

class Chapter {
  final int id;
  final String name;
  final List<SubChapter> subChapters;

  Chapter({required this.id, required this.name, required this.subChapters});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json["id"],
      name: json["name"],
      subChapters:
          (json["sub-chapters"] as List)
              .map((e) => SubChapter.fromJson(e))
              .toList(),
    );
  }
}

class InteractiveBookNavbarModel {
  final List<Chapter> chapters;

  InteractiveBookNavbarModel({required this.chapters});

  factory InteractiveBookNavbarModel.fromJson(Map<String, dynamic> json) {
    return InteractiveBookNavbarModel(
      chapters:
          (json["chapters"] as List).map((e) => Chapter.fromJson(e)).toList(),
    );
  }
}



