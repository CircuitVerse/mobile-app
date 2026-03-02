import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;

class IbInlineHtmlSyntax extends md.InlineSyntax {
  IbInlineHtmlSyntax({required this.builders}) : super(_pattern);

  Map<String, MarkdownElementBuilder> builders;

  static const String _pattern = '\u27E8(sup|sub|mark)\u27E9(.*?)\u27E8/\\1\u27E9';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match[1] != null &&
        match[2] != null &&
        builders.containsKey(match[1]?.trim())) {
      parser.addNode(md.Element.text(match[1]!.trim(), match[2]!.trim()));
      return true;
    }

    return false;
  }
}
