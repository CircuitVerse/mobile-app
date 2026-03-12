// JSON-based page data models for Interactive Book
// These models represent the structured JSON response from the API

class IbJsonPageData {
  final String id;
  final String title;
  final String? description;
  final String? navOrder;
  final String? level;
  final bool hasChildren;
  final String? parent;
  final String path;
  final Map<String, dynamic>? metadata;
  final IbJsonContent? content;
  final List<IbJsonChild>? children;
  final Map<String, String>? apiEndpoints;
  final List<IbJsonKeyConcept>? keyConcepts;
  final List<IbJsonRelatedTopic>? relatedTopics;

  IbJsonPageData({
    required this.id,
    required this.title,
    this.description,
    this.navOrder,
    this.level,
    required this.hasChildren,
    this.parent,
    required this.path,
    this.metadata,
    this.content,
    this.children,
    this.apiEndpoints,
    this.keyConcepts,
    this.relatedTopics,
  });

  factory IbJsonPageData.fromJson(Map<String, dynamic> json) {
    return IbJsonPageData(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      navOrder: json['nav_order']?.toString(),
      level: json['level'] as String?,
      hasChildren: json['has_children'] as bool? ?? false,
      parent: json['parent'] as String?,
      path: json['path'] as String,
      metadata: json['metadata'] as Map<String, dynamic>?,
      content:
          json['content'] != null
              ? IbJsonContent.fromJson(json['content'] as Map<String, dynamic>)
              : null,
      children:
          json['children'] != null
              ? (json['children'] as List<dynamic>)
                  .map((e) => IbJsonChild.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
      apiEndpoints:
          json['api_endpoints'] != null
              ? Map<String, String>.from(json['api_endpoints'] as Map)
              : null,
      keyConcepts:
          json['key_concepts'] != null
              ? (json['key_concepts'] as List<dynamic>)
                  .map(
                    (e) => IbJsonKeyConcept.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
              : null,
      relatedTopics:
          json['related_topics'] != null
              ? (json['related_topics'] as List<dynamic>)
                  .map(
                    (e) =>
                        IbJsonRelatedTopic.fromJson(e as Map<String, dynamic>),
                  )
                  .toList()
              : null,
    );
  }
}

class IbJsonContent {
  final List<IbJsonSection> sections;

  IbJsonContent({required this.sections});

  factory IbJsonContent.fromJson(Map<String, dynamic> json) {
    return IbJsonContent(
      sections:
          (json['sections'] as List<dynamic>)
              .map((e) => IbJsonSection.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class IbJsonSection {
  final String type;
  final dynamic data;

  IbJsonSection({required this.type, this.data});

  factory IbJsonSection.fromJson(Map<String, dynamic> json) {
    return IbJsonSection(type: json['type'] as String, data: json);
  }
}

class IbJsonChild {
  final String title;
  final String path;
  final String? navOrder;
  final String? level;

  IbJsonChild({
    required this.title,
    required this.path,
    this.navOrder,
    this.level,
  });

  factory IbJsonChild.fromJson(Map<String, dynamic> json) {
    return IbJsonChild(
      title: json['title'] as String,
      path: json['path'] as String,
      navOrder: json['nav_order']?.toString(),
      level: json['level'] as String?,
    );
  }
}

class IbJsonKeyConcept {
  final String concept;
  final String description;

  IbJsonKeyConcept({required this.concept, required this.description});

  factory IbJsonKeyConcept.fromJson(Map<String, dynamic> json) {
    return IbJsonKeyConcept(
      concept: json['concept'] as String,
      description: json['description'] as String,
    );
  }
}

class IbJsonRelatedTopic {
  final String title;
  final String path;

  IbJsonRelatedTopic({required this.title, required this.path});

  factory IbJsonRelatedTopic.fromJson(Map<String, dynamic> json) {
    return IbJsonRelatedTopic(
      title: json['title'] as String,
      path: json['path'] as String,
    );
  }
}
