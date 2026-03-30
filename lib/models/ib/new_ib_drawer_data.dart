// Models for the new IB drawer API response

class NewIbDrawerData {
  final String id;
  final String title;
  final String version;
  final List<NewIbChapter> chapters;
  final List<NewIbFooterLink> footerLinks;
  final NewIbDrawerMetadata metadata;

  NewIbDrawerData({
    required this.id,
    required this.title,
    required this.version,
    required this.chapters,
    required this.footerLinks,
    required this.metadata,
  });

  factory NewIbDrawerData.fromJson(Map<String, dynamic> json) {
    // Handle chapters list with proper type casting
    final chaptersList = json['chapters'] as List<dynamic>;
    final chapters = chaptersList.map((e) {
      final Map<String, dynamic> chapterMap = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbChapter.fromJson(chapterMap);
    }).toList();
    
    // Handle footer_links list with proper type casting
    final footerLinksList = json['footer_links'] as List<dynamic>;
    final footerLinks = footerLinksList.map((e) {
      final Map<String, dynamic> linkMap = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return NewIbFooterLink.fromJson(linkMap);
    }).toList();
    
    // Handle metadata with proper type casting
    final metadataMap = json['metadata'] is Map<String, dynamic>
        ? json['metadata'] as Map<String, dynamic>
        : Map<String, dynamic>.from(json['metadata'] as Map);
    
    return NewIbDrawerData(
      id: json['id'] as String,
      title: json['title'] as String,
      version: json['version'] as String,
      chapters: chapters,
      footerLinks: footerLinks,
      metadata: NewIbDrawerMetadata.fromJson(metadataMap),
    );
  }
}

class NewIbChapter {
  final String id;
  final String title;
  final int navOrder;
  final String? heading;
  final String? description;
  final String path;
  final bool? hasChildren;
  final String apiUrl;
  final String? navOrderStr;
  final String? level;
  final List<NewIbSubChapter>? children;

  NewIbChapter({
    required this.id,
    required this.title,
    required this.navOrder,
    this.heading,
    this.description,
    required this.path,
    this.hasChildren,
    required this.apiUrl,
    this.navOrderStr,
    this.level,
    this.children,
  });

  factory NewIbChapter.fromJson(Map<String, dynamic> json) {
    // Handle children list with proper type casting
    List<NewIbSubChapter>? children;
    if (json['children'] != null) {
      final childrenList = json['children'] as List<dynamic>;
      children = childrenList.map((e) {
        // Ensure e is a Map<String, dynamic>
        final Map<String, dynamic> childMap = e is Map<String, dynamic> 
            ? e 
            : Map<String, dynamic>.from(e as Map);
        return NewIbSubChapter.fromJson(childMap);
      }).toList();
    }
    
    return NewIbChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      navOrder: json['nav_order'] as int,
      heading: json['heading'] as String?,
      description: json['description'] as String?,
      path: json['path'] as String,
      hasChildren: json['has_children'] as bool?,
      apiUrl: json['api_url'] as String,
      navOrderStr: json['nav_order_str'] as String?,
      level: json['level'] as String?,
      children: children,
    );
  }
}

class NewIbSubChapter {
  final String id;
  final String title;
  final String navOrder;
  final String level;
  final String path;
  final String? apiUrl;

  NewIbSubChapter({
    required this.id,
    required this.title,
    required this.navOrder,
    required this.level,
    required this.path,
    this.apiUrl,
  });

  factory NewIbSubChapter.fromJson(Map<String, dynamic> json) {
    return NewIbSubChapter(
      id: json['id'] as String,
      title: json['title'] as String,
      navOrder: json['nav_order'] as String,
      level: json['level'] as String,
      path: json['path'] as String,
      apiUrl: json['api_url'] as String?,
    );
  }
}

class NewIbFooterLink {
  final String id;
  final String title;
  final String path;
  final String url;

  NewIbFooterLink({
    required this.id,
    required this.title,
    required this.path,
    required this.url,
  });

  factory NewIbFooterLink.fromJson(Map<String, dynamic> json) {
    return NewIbFooterLink(
      id: json['id'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
      url: json['url'] as String,
    );
  }
}

class NewIbDrawerMetadata {
  final int totalChapters;
  final String copyright;
  final String website;
  final String repository;

  NewIbDrawerMetadata({
    required this.totalChapters,
    required this.copyright,
    required this.website,
    required this.repository,
  });

  factory NewIbDrawerMetadata.fromJson(Map<String, dynamic> json) {
    return NewIbDrawerMetadata(
      totalChapters: json['total_chapters'] as int,
      copyright: json['copyright'] as String,
      website: json['website'] as String,
      repository: json['repository'] as String,
    );
  }
}

