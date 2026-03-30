// Model for the new IB home page API response

class NewIbHomeData {
  final String id;
  final String title;
  final String subtitle;
  final String layout;
  final int navOrder;
  final String permalink;
  final NewIbHomeContent content;
  final NewIbHomeNavigation navigation;
  final NewIbMetadata metadata;

  NewIbHomeData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.layout,
    required this.navOrder,
    required this.permalink,
    required this.content,
    required this.navigation,
    required this.metadata,
  });

  factory NewIbHomeData.fromJson(Map<String, dynamic> json) {
    return NewIbHomeData(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      layout: json['layout'] as String,
      navOrder: json['nav_order'] as int,
      permalink: json['permalink'] as String,
      content: NewIbHomeContent.fromJson(
        json['content'] is Map<String, dynamic>
            ? json['content'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['content'] as Map),
      ),
      navigation: NewIbHomeNavigation.fromJson(
        json['navigation'] is Map<String, dynamic>
            ? json['navigation'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['navigation'] as Map),
      ),
      metadata: NewIbMetadata.fromJson(
        json['metadata'] is Map<String, dynamic>
            ? json['metadata'] as Map<String, dynamic>
            : Map<String, dynamic>.from(json['metadata'] as Map),
      ),
    );
  }
}

class NewIbHomeContent {
  final String fullText;
  final List<NewIbHomeSection> sections;

  NewIbHomeContent({
    required this.fullText,
    required this.sections,
  });

  factory NewIbHomeContent.fromJson(Map<String, dynamic> json) {
    final sectionsList = json['sections'] as List<dynamic>;
    final sections = sectionsList.map((e) {
      final Map<String, dynamic> sectionMap = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbHomeSection.fromJson(sectionMap);
    }).toList();

    return NewIbHomeContent(
      fullText: json['full_text'] as String,
      sections: sections,
    );
  }
}

class NewIbHomeSection {
  final String type;
  final int? level;
  final String? text;

  NewIbHomeSection({
    required this.type,
    this.level,
    this.text,
  });

  factory NewIbHomeSection.fromJson(Map<String, dynamic> json) {
    return NewIbHomeSection(
      type: json['type'] as String,
      level: json['level'] as int?,
      text: json['text'] as String?,
    );
  }
}

class NewIbHomeNavigation {
  final String drawerApi;
  final NewIbHomeNext? next;

  NewIbHomeNavigation({
    required this.drawerApi,
    this.next,
  });

  factory NewIbHomeNavigation.fromJson(Map<String, dynamic> json) {
    return NewIbHomeNavigation(
      drawerApi: json['drawer_api'] as String,
      next: json['next'] != null
          ? NewIbHomeNext.fromJson(
              json['next'] is Map<String, dynamic>
                  ? json['next'] as Map<String, dynamic>
                  : Map<String, dynamic>.from(json['next'] as Map),
            )
          : null,
    );
  }
}

class NewIbHomeNext {
  final String title;
  final String url;
  final String apiUrl;

  NewIbHomeNext({
    required this.title,
    required this.url,
    required this.apiUrl,
  });

  factory NewIbHomeNext.fromJson(Map<String, dynamic> json) {
    return NewIbHomeNext(
      title: json['title'] as String,
      url: json['url'] as String,
      apiUrl: json['api_url'] as String,
    );
  }
}

class NewIbMetadata {
  final String copyright;
  final String website;
  final String repository;

  NewIbMetadata({
    required this.copyright,
    required this.website,
    required this.repository,
  });

  factory NewIbMetadata.fromJson(Map<String, dynamic> json) {
    return NewIbMetadata(
      copyright: json['copyright'] as String,
      website: json['website'] as String,
      repository: json['repository'] as String,
    );
  }
}
