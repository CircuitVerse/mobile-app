import 'package:hive/hive.dart';

part 'ib_raw_page_data.g.dart';

@HiveType(typeId: 0)
class IbRawPageData {
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

  IbRawPageData({
    required this.id,
    required this.title,
    this.name,
    this.content,
    required this.rawContent,
    this.navOrder,
    this.cvibLevel,
    this.parent,
    required this.hasChildren,
    required this.hasToc,
    required this.disableComments,
    required this.frontMatter,
    required this.httpUrl,
    this.apiUrl,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? content;

  @HiveField(4)
  String rawContent;

  @HiveField(5)
  String? navOrder;

  @HiveField(6)
  String? cvibLevel;

  @HiveField(7)
  String? parent;

  @HiveField(8)
  bool hasChildren;

  @HiveField(9)
  bool hasToc;

  @HiveField(10)
  bool disableComments;

  @HiveField(11)
  Map<String, dynamic> frontMatter;

  @HiveField(12)
  String httpUrl;

  @HiveField(13)
  String? apiUrl;
}
