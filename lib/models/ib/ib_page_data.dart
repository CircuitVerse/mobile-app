import 'package:flutter/material.dart';
import 'package:mobile_app/models/ib/ib_content.dart';

class IbPageData {
  final String id;
  final String title;
  final List<IbContent> content;
  final List<IbTocItem> tableOfContents;

  IbPageData({
    @required this.id,
    @required this.title,
    @required this.content,
    this.tableOfContents,
  });
}
