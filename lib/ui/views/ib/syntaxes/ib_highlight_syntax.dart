import 'package:markdown/markdown.dart' as md;

class HighlightSyntax extends md.InlineSyntax {
  HighlightSyntax(this.query) : super(query, caseSensitive: false);
  final String query;

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match[0] != null) {
      parser.addNode(md.Element.text('mark', match[0]!.trim()));
    }

    return true;
  }
}
