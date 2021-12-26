import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/utils/unicode_map.dart';

class IbSubscriptBuilder extends MarkdownElementBuilder {
  IbSubscriptBuilder({this.selectable = true});

  final bool selectable;

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final textContent = element.textContent;

    // We don't currently have a way to control the vertical alignment of text spans.
    // See https://github.com/flutter/flutter/issues/10906#issuecomment-385723664
    // Also, SelectableText for flutter_markdown doesn't supports WidgetSpan

    var text = '';
    for (var i = 0; i < textContent.length; i++) {
      if (UnicodeMap.containsKey(textContent[i])) {
        text += UnicodeMap[textContent[i]]![1];
      }
    }

    var _span = TextSpan(text: text);

    if (selectable) {
      return SelectableText.rich(_span);
    }

    return RichText(text: _span);
  }
}
