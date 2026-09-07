import 'package:flutter/foundation.dart';

class SubChapter {
  final int id;
  final String name;

  SubChapter({required this.id, required this.name});

  /// Returns `null` when the payload is missing the fields a sub-chapter
  /// needs, so one malformed entry cannot take the whole navbar down with it.
  static SubChapter? tryFromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];

    if (id is! int || name is! String) {
      debugPrint('Skipping malformed sub-chapter: $json');
      return null;
    }

    return SubChapter(id: id, name: name);
  }
}

class Chapter {
  final int id;
  final String name;

  /// Slug the content API addresses this chapter's pages by, e.g.
  /// `binary-representation`.
  final String path;
  final List<SubChapter> subChapters;

  Chapter({
    required this.id,
    required this.name,
    required this.path,
    required this.subChapters,
  });

  /// Returns `null` unless the payload carries everything a chapter needs to
  /// be navigable — including the slug its pages are fetched by, without which
  /// every request for the chapter would 404.
  static Chapter? tryFromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final path = json['path'];

    if (id is! int || name is! String || path is! String || path.isEmpty) {
      debugPrint('Skipping malformed chapter: $json');
      return null;
    }

    final subChapters = <SubChapter>[];
    for (final entry in (json['sub-chapters'] as List? ?? const [])) {
      if (entry is! Map<String, dynamic>) continue;
      final subChapter = SubChapter.tryFromJson(entry);
      if (subChapter != null) subChapters.add(subChapter);
    }

    return Chapter(id: id, name: name, path: path, subChapters: subChapters);
  }
}

class InteractiveBookNavbarModel {
  final List<Chapter> chapters;

  InteractiveBookNavbarModel({required this.chapters});

  factory InteractiveBookNavbarModel.fromJson(Map<String, dynamic> json) {
    final chapters = <Chapter>[];

    for (final entry in (json['chapters'] as List? ?? const [])) {
      if (entry is! Map<String, dynamic>) continue;
      final chapter = Chapter.tryFromJson(entry);
      if (chapter != null) chapters.add(chapter);
    }

    return InteractiveBookNavbarModel(chapters: chapters);
  }

  Chapter? chapterById(int id) {
    final index = indexOfChapter(id);
    return index < 0 ? null : chapters[index];
  }

  /// Position of a chapter in reading order, or `-1` when it is not in the
  /// book. Reading order comes from the list, never from the ids themselves,
  /// so neighbouring chapters resolve correctly even if ids are sparse.
  int indexOfChapter(int id) => chapters.indexWhere((c) => c.id == id);
}
