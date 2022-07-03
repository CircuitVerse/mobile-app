import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:scroll_to_index/scroll_to_index.dart';

typedef CountCb = void Function(int);

class HighlightBuilder extends MarkdownElementBuilder {
  HighlightBuilder({
    required this.controller,
    required this.occurenceCountCb,
    this.selectable = true,
  });

  final AutoScrollController controller;
  final CountCb occurenceCountCb;
  final bool selectable;
  var index = 0;

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var text = element.textContent;

    const style = TextStyle(color: Colors.black);
    final textSpan = TextSpan(text: text, style: style);
    var widget = selectable
        ? SelectableText.rich(textSpan, style: style)
        : RichText(text: textSpan);

    occurenceCountCb(++index);

    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      color: Colors.yellowAccent,
      highlightColor: Colors.orangeAccent,
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: widget,
      ),
    );
  }
}
