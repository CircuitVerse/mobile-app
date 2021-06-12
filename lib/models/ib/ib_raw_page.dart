class IbRawPage {
  String id;
  String name;
  String title;
  String navOrder;
  String cvibLevel;
  String parent;
  bool hasChildren;
  bool hasToc;
  bool disableComments;
  String httpUrl;
  String apiUrl;

  IbRawPage(
      {this.id,
      this.name,
      this.title,
      this.navOrder,
      this.cvibLevel,
      this.parent,
      this.hasChildren,
      this.hasToc,
      this.disableComments,
      this.httpUrl,
      this.apiUrl});

  factory IbRawPage.fromJson(Map<String, dynamic> json) => IbRawPage(
        id: json['path'] ?? json['relative_path'],
        name: json['name'],
        title: json['title'],
        navOrder: json['nav_order'].toString(),
        cvibLevel: json['cvib_level'],
        parent: json['parent'],
        hasChildren: json['has_children'] ?? false,
        hasToc: json['has_toc'] ?? (json['name'] == 'index.md' ? false : true),
        disableComments: json['disable_comments'] ??
            (json['name'] == 'index.md' ? true : false),
        httpUrl: json['http_url'],
        apiUrl: json['api_url'],
      );
}
