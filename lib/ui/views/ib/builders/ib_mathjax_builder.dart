import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

/// IbMathjaxBuilder builds RichText widget for the Mathjax Support.
///
/// It will be inserted/merged inline only if selectable is set to false
/// which means neighbouring widgets should also be RichText so that
/// their children's are merged together otherwise it's rendered
/// as any other block widget with line breaks.
class IbMathjaxBuilder extends MarkdownElementBuilder {
  IbMathjaxBuilder();

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var _content = element.textContent.trim();

    // Remove auto-numbering and custom-numbering tags
    _content = _content.replaceAll('\\begin{equation}', ' ');
    _content = _content.replaceAll('\\end{equation}', ' ');

    _content = _content.replaceAll(RegExp(r'\\tag{.+}'), ' ');

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            // Intentional Nesting due to a bug in flutter_markdown
            children: [
              WidgetSpan(
                child: SizedBox(
                  child: Wrap(
                    spacing: 1.0,
                    runSpacing: 5.0,
                    direction: Axis.vertical,
                    children: <Widget>[Math.tex(_content)],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
