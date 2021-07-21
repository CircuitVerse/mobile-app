import 'package:flutter/material.dart';

abstract class IbContent {
  String content;

  IbContent({@required this.content});
}

class IbTocItem extends IbContent {
  final List<IbTocItem> items;

  IbTocItem({@required String content, this.items}) : super(content: content);
}

class IbMd extends IbContent {
  IbMd({@required String content}) : super(content: content);
}
