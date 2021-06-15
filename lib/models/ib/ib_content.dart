import 'package:flutter/material.dart';

abstract class IbContent {
  String content;

  IbContent({@required this.content});
}

enum IbHeadingType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  subtitle,
}

class IbHeading extends IbContent {
  final IbHeadingType type;

  IbHeading({@required String content, @required this.type})
      : super(content: content);
}

class IbParagraph extends IbContent {
  IbParagraph({@required String content}) : super(content: content);
}

class IbDivider extends IbContent {
  IbDivider() : super(content: '');
}
