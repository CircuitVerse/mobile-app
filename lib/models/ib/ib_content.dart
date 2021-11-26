import 'package:flutter/material.dart';

abstract class IbContent {
  IbContent({@required this.content});
  String content;
}

class IbTocItem extends IbContent {
  IbTocItem({@required String content, this.leading, this.items})
      : super(content: content);

  final String leading;
  final List<IbTocItem> items;
}

class IbMd extends IbContent {
  IbMd({@required String content}) : super(content: content);
}
