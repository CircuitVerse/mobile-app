import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/ui/views/ib/syntaxes/ib_inline_html_syntax.dart';

class IbBackTicksSyntax extends md.InlineSyntax {
  IbBackTicksSyntax() : super(_pattern);

  static const String _pattern = r'\`(.*?)\`';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String matched = match[1] ?? '';

    final inlineRegex = RegExp(IbInlineHtmlSyntax.Pattern);

    /// Inline HTML Tags bounded by Backticks(`) are not parsed
    if (inlineRegex.hasMatch(matched)) {
      for (var word in matched.split(' ')) {
        if (inlineRegex.hasMatch(word)) {
          parser.addNode(md.Text(word.substring(0, word.indexOf('<'))));

          final match = inlineRegex.firstMatch(word);
          if (match != null) {
            parser.addNode(md.Element.text(match[1]!, match[2]!));
          }

          parser.addNode(
              md.Text("${word.substring(word.lastIndexOf('>') + 1)} "));
          continue;
        }
        parser.addNode(md.Text('$word '));
      }
    } else {
      parser.addNode(md.Element.text('code', matched));
    }

    return true;
  }
}
