import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class IbChapterContentsBuilder extends MarkdownElementBuilder {
  IbChapterContentsBuilder({this.chapterContents});

  final Widget? chapterContents;

  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return chapterContents;
  }
}
