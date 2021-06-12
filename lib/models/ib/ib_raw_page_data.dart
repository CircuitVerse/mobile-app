class IbRawPageData {
  String id;
  String title;
  String name;
  String content;
  String rawContent;
  String navOrder;
  String cvibLevel;
  String parent;
  bool hasChildren;
  bool hasToc;
  bool disableComments;
  Map<String, dynamic> frontMatter;
  String httpUrl;
  String apiUrl;

  IbRawPageData(
      {this.id,
      this.title,
      this.name,
      this.content,
      this.rawContent,
      this.navOrder,
      this.cvibLevel,
      this.parent,
      this.hasChildren,
      this.hasToc,
      this.disableComments,
      this.frontMatter,
      this.httpUrl,
      this.apiUrl});

  factory IbRawPageData.fromJson(Map<String, dynamic> json) => IbRawPageData(
        id: json['path'] ?? json['relative_path'],
        name: json['name'],
        title: json['title'],
        content: json['content'],
        rawContent: json['raw_content'],
        navOrder: json['nav_order'].toString(),
        cvibLevel: json['cvib_level'],
        parent: json['parent'],
        hasChildren: json['has_children'] ?? false,
        hasToc: json['has_toc'] ?? (json['name'] == 'index.md' ? false : true),
        disableComments: json['disable_comments'] ??
            (json['name'] == 'index.md' ? true : false),
        frontMatter: json['front_matter'] ?? {},
        httpUrl: json['http_url'],
        apiUrl: json['api_url'],
      );
}
