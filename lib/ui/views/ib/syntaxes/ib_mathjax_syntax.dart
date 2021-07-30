import 'package:markdown/markdown.dart' as md;

class IbMathjaxSyntax extends md.InlineSyntax {
  IbMathjaxSyntax() : super(_pattern);

  /// This is not the perfect pattern for any Mathjax formula
  /// It's made in accordance to what flutter_math_fork works with
  /// [ ], $$ $$ and muti-line formulas are unsupported
  static const String _pattern = r'\$([^$\n\r]+)\$';

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    if (match[1] != null) {
      parser.addNode(md.Element.text('mathjax', match[1]));
    }

    return true;
  }
}
