import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class IbChapterContentsBuilder extends MarkdownElementBuilder {
  final Widget chapterContents;

  IbChapterContentsBuilder({this.chapterContents});

  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    return chapterContents;
  }
}
