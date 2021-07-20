import 'package:flutter/material.dart';
import 'package:mobile_app/models/ib/ib_content.dart';

class IbPageData {
  final String id;
  final String pageUrl;
  final String title;
  final List<IbContent> content;
  final List<IbTocItem> tableOfContents;
  final List<IbTocItem> chapterOfContents;

  IbPageData({
    @required this.id,
    @required this.pageUrl,
    @required this.title,
    @required this.content,
    this.tableOfContents,
    this.chapterOfContents,
  });
}
