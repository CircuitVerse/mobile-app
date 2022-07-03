import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class IbHeadingsBuilder extends MarkdownElementBuilder {
  IbHeadingsBuilder({
    required this.slugMap,
    required this.controller,
    this.selectable = true,
  });

  final Map<String, int> slugMap;
  final AutoScrollController controller;
  final bool selectable;
  var index = 0;

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var text = element.textContent;

    // Build Text Span
    List<TextSpan> spans = [];
    text.splitMapJoin(
      RegExp(r'<(\S*?)[^>]*>(.*?)<\/\1>|<.*?\/>'),
      onMatch: (match) {
        spans.add(
          TextSpan(
            text: match[2],
            style: const TextStyle(
              color: Colors.black,
              backgroundColor: Colors.yellowAccent,
            ),
          ),
        );
        return '';
      },
      onNonMatch: (val) {
        spans.add(
          TextSpan(text: val),
        );
        return '';
      },
    );

    var widget = selectable
        ? SelectableText.rich(TextSpan(children: spans), style: preferredStyle)
        : Text.rich(TextSpan(children: spans), style: preferredStyle);

    slugMap[IbEngineService.getSlug(text)] = index;

    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      index: index++,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: widget,
      ),
    );
  }
}
