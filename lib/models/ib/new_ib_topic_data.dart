// Model for topic/sub-chapter page API response

class NewIbTopicData {
  final String id;
  final String title;
  final String navOrder;
  final String level;
  final String parent;
  final bool hasChildren;
  final String path;
  final NewIbTopicMetadata metadata;
  final NewIbTopicContent content;
  final List<NewIbKeyConcept> keyConcepts;
  final List<NewIbRelatedTopic> relatedTopics;
  final NewIbTopicApiEndpoints apiEndpoints;

  NewIbTopicData({
    required this.id,
    required this.title,
    required this.navOrder,
    required this.level,
    required this.parent,
    required this.hasChildren,
    required this.path,
    required this.metadata,
    required this.content,
    required this.keyConcepts,
    required this.relatedTopics,
    required this.apiEndpoints,
  });

  factory NewIbTopicData.fromJson(Map<String, dynamic> json) {
    final keyConceptsList = json['key_concepts'] as List<dynamic>;
    final keyConcepts = keyConceptsList.map((e) {
      final Map<String, dynamic> map = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbKeyConcept.fromJson(map);
    }).toList();

    final relatedTopicsList = json['related_topics'] as List<dynamic>;
    final relatedTopics = relatedTopicsList.map((e) {
      final Map<String, dynamic> map = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbRelatedTopic.fromJson(map);
    }).toList();

    return NewIbTopicData(
      id: json['id'] as String,
      title: json['title'] as String,
      navOrder: json['nav_order'] as String,
      level: json['level'] as String,
      parent: json['parent'] as String,
      hasChildren: json['has_children'] as bool,
      path: json['path'] as String,
      metadata: NewIbTopicMetadata.fromJson(
        json['metadata'] is Map<String, dynamic>
            ? json['metadata'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['metadata'] as Map),
      ),
      content: NewIbTopicContent.fromJson(
        json['content'] is Map<String, dynamic>
            ? json['content'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['content'] as Map),
      ),
      keyConcepts: keyConcepts,
      relatedTopics: relatedTopics,
      apiEndpoints: NewIbTopicApiEndpoints.fromJson(
        json['api_endpoints'] is Map<String, dynamic>
            ? json['api_endpoints'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['api_endpoints'] as Map),
      ),
    );
  }
}

class NewIbTopicMetadata {
  final String layout;
  final String? author;

  NewIbTopicMetadata({
    required this.layout,
    this.author,
  });

  factory NewIbTopicMetadata.fromJson(Map<String, dynamic> json) {
    return NewIbTopicMetadata(
      layout: json['layout'] as String,
      author: json['author'] as String?,
    );
  }
}

class NewIbTopicContent {
  final List<dynamic> sections;

  NewIbTopicContent({
    required this.sections,
  });

  factory NewIbTopicContent.fromJson(Map<String, dynamic> json) {
    return NewIbTopicContent(
      sections: json['sections'] as List<dynamic>,
    );
  }
}

class NewIbKeyConcept {
  final String concept;
  final String description;

  NewIbKeyConcept({
    required this.concept,
    required this.description,
  });

  factory NewIbKeyConcept.fromJson(Map<String, dynamic> json) {
    return NewIbKeyConcept(
      concept: json['concept'] as String,
      description: json['description'] as String,
    );
  }
}

class NewIbRelatedTopic {
  final String title;
  final String path;

  NewIbRelatedTopic({
    required this.title,
    required this.path,
  });

  factory NewIbRelatedTopic.fromJson(Map<String, dynamic> json) {
    return NewIbRelatedTopic(
      title: json['title'] as String,
      path: json['path'] as String,
    );
  }
}

class NewIbTopicApiEndpoints {
  final String self;
  final String parent;

  NewIbTopicApiEndpoints({
    required this.self,
    required this.parent,
  });

  factory NewIbTopicApiEndpoints.fromJson(Map<String, dynamic> json) {
    return NewIbTopicApiEndpoints(
      self: json['self'] as String,
      parent: json['parent'] as String,
    );
  }
}
