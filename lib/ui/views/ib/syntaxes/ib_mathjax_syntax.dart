import 'package:markdown/markdown.dart' as md;

class IbMathjaxSyntax extends md.InlineSyntax {
  IbMathjaxSyntax() : super(_pattern);

  static const String _pattern = r'\$([^$\n\r]+)\$';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match[1] != null) {
      parser.addNode(md.Element.text('mathjax', match[1]!));
      return true;
    }

    return false;
  }
}
