import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class IbInlineHtmlSyntax extends md.InlineSyntax {
  IbInlineHtmlSyntax({required this.builders}) : super(_pattern);

  Map<String, MarkdownElementBuilder> builders;

  static const String _pattern = r'<(\S*?)[^>]*>(.*?)<\/\1>|<.*?\/>';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match[1] != null &&
        match[2] != null &&
        builders.containsKey(match[1]?.trim())) {
      parser.addNode(md.Element.text(match[1]!.trim(), match[2]!.trim()));
    }

    return true;
  }
}
