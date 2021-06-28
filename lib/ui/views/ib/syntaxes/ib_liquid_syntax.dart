import 'package:markdown/markdown.dart' as md;

class IbLiquidSyntax extends md.BlockSyntax {
  IbLiquidSyntax() : super();

  @override
  md.Node parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current);
    var tags = match[1].split(' ');
    var node;

    // Liquid include tags
    if (tags[0] == 'include') {
      // chapter_toc include
      if (tags[1] == 'chapter_toc.html') {
        node = md.Element.text('chapter_contents', '');
      }

      // [TODO] image.html for images
      // [TODO] interactions that will use webview
    }

    parser.advance();

    return node;
  }

  @override
  RegExp get pattern => RegExp(r'{%\s?(.+)\s?%}');
}
