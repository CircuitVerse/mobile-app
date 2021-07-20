import 'package:markdown/markdown.dart' as md;

class IbEmbedSyntax extends md.BlockSyntax {
  IbEmbedSyntax() : super();

  @override
  md.Node parse(md.BlockParser parser) {
    var text = parser.current;
    parser.advance();

    return md.Element.text('iframe', text);
  }

  @override
  RegExp get pattern => RegExp(r'^<iframe.+>.+<\/iframe>');
}
