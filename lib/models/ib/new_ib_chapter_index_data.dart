// Model for chapter index page API response

class NewIbChapterIndexData {
  final String id;
  final String title;
  final String description;
  final int navOrder;
  final bool hasChildren;
  final String? parent;
  final String level;
  final String path;
  final NewIbChapterMetadata metadata;
  final NewIbChapterContent content;
  final List<NewIbChapterChild> children;
  final NewIbChapterApiEndpoints apiEndpoints;

  NewIbChapterIndexData({
    required this.id,
    required this.title,
    required this.description,
    required this.navOrder,
    required this.hasChildren,
    this.parent,
    required this.level,
    required this.path,
    required this.metadata,
    required this.content,
    required this.children,
    required this.apiEndpoints,
  });

  factory NewIbChapterIndexData.fromJson(Map<String, dynamic> json) {
    final childrenList = json['children'] as List<dynamic>;
    final children = childrenList.map((e) {
      final Map<String, dynamic> childMap = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbChapterChild.fromJson(childMap);
    }).toList();

    return NewIbChapterIndexData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      navOrder: json['nav_order'] as int,
      hasChildren: json['has_children'] as bool,
      parent: json['parent'] as String?,
      level: json['level'] as String,
      path: json['path'] as String,
      metadata: NewIbChapterMetadata.fromJson(
        json['metadata'] is Map<String, dynamic>
            ? json['metadata'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['metadata'] as Map),
      ),
      content: NewIbChapterContent.fromJson(
        json['content'] is Map<String, dynamic>
            ? json['content'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['content'] as Map),
      ),
      children: children,
      apiEndpoints: NewIbChapterApiEndpoints.fromJson(
        json['api_endpoints'] is Map<String, dynamic>
            ? json['api_endpoints'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['api_endpoints'] as Map),
      ),
    );
  }
}

class NewIbChapterMetadata {
  final String layout;
  final bool hasToc;

  NewIbChapterMetadata({
    required this.layout,
    required this.hasToc,
  });

  factory NewIbChapterMetadata.fromJson(Map<String, dynamic> json) {
    return NewIbChapterMetadata(
      layout: json['layout'] as String,
      hasToc: json['has_toc'] as bool,
    );
  }
}

class NewIbChapterContent {
  final List<NewIbChapterSection> sections;

  NewIbChapterContent({
    required this.sections,
  });

  factory NewIbChapterContent.fromJson(Map<String, dynamic> json) {
    final sectionsList = json['sections'] as List<dynamic>;
    final sections = sectionsList.map((e) {
      final Map<String, dynamic> sectionMap = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbChapterSection.fromJson(sectionMap);
    }).toList();

    return NewIbChapterContent(sections: sections);
  }
}

class NewIbChapterSection {
  final String type;
  final int? level;
  final String? text;
  final String? id;

  NewIbChapterSection({
    required this.type,
    this.level,
    this.text,
    this.id,
  });

  factory NewIbChapterSection.fromJson(Map<String, dynamic> json) {
    return NewIbChapterSection(
      type: json['type'] as String,
      level: json['level'] as int?,
      text: json['text'] as String?,
      id: json['id'] as String?,
    );
  }
}

class NewIbChapterChild {
  final String title;
  final String path;
  final String navOrder;
  final String level;

  NewIbChapterChild({
    required this.title,
    required this.path,
    required this.navOrder,
    required this.level,
  });

  factory NewIbChapterChild.fromJson(Map<String, dynamic> json) {
    return NewIbChapterChild(
      title: json['title'] as String,
      path: json['path'] as String,
      navOrder: json['nav_order'] as String,
      level: json['level'] as String,
    );
  }
}

class NewIbChapterApiEndpoints {
  final String self;
  final String children;

  NewIbChapterApiEndpoints({
    required this.self,
    required this.children,
  });

  factory NewIbChapterApiEndpoints.fromJson(Map<String, dynamic> json) {
    return NewIbChapterApiEndpoints(
      self: json['self'] as String,
      children: json['children'] as String,
    );
  }
}
