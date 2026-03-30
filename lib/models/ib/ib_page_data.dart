import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';

class IbPageData {
  IbPageData({
    required this.id,
    required this.pageUrl,
    required this.title,
    this.content,
    this.tableOfContents,
    this.chapterOfContents,
    this.rawPageData,
  });
  final String id;
  final String pageUrl;
  final String title;
  final List<IbContent>? content;
  final List<IbTocItem>? tableOfContents;
  final List<IbTocItem>? chapterOfContents;
  final IbRawPageData? rawPageData;
}
