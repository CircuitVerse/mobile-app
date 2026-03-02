import 'package:markdown/markdown.dart' as md;

class IbEmbedSyntax extends md.BlockSyntax {
  IbEmbedSyntax() : super();

  @override
  md.Node parse(md.BlockParser parser) {
    final firstLine = parser.current.content;

    if (_singleLinePattern.hasMatch(firstLine)) {
      parser.advance();
      return md.Element.text('iframe', firstLine);
    }

    final buffer = StringBuffer(firstLine);
    parser.advance();

    while (!parser.isDone) {
      final line = parser.current.content;
      buffer.write('\n$line');
      parser.advance();
      if (line.contains('</iframe>')) break;
    }

    return md.Element.text('iframe', buffer.toString());
  }

  static final _singleLinePattern =
      RegExp(r'^<iframe[^>]*>.*<\/iframe>', caseSensitive: false);

  @override
  RegExp get pattern => RegExp(r'^<iframe', caseSensitive: false);
}
