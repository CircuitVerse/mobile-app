import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

typedef CountCb = void Function(int);

class HighlightBuilder extends MarkdownElementBuilder {
  HighlightBuilder({
    this.selectable = true,
  });

  final bool selectable;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var text = element.textContent;

    final style = (preferredStyle ?? const TextStyle()).copyWith(
      color: Colors.black,
      backgroundColor: Colors.yellowAccent,
    );
    final textSpan = TextSpan(
      style: style,
      children: [
        WidgetSpan(
          child: Text(
            text,
            style: style,
          ),
        )
      ],
    );
    var widget = selectable
        ? SelectableText.rich(textSpan, style: style)
        : RichText(text: textSpan);

    return widget;
  }
}
