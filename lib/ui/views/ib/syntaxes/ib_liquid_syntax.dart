import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/config/environment_config.dart';

class IbLiquidSyntax extends md.BlockSyntax {
  IbLiquidSyntax() : super();

  @override
  md.Node? parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current.content);
    if (match == null) {
      parser.advance();
      return md.Element.empty('p');
    }
    var tags = match[1]!.split(' ');
    md.Element? node;

    // Liquid include tags
    if (tags[0] == 'include' && tags.length >= 2) {
      // chapter_toc include
      if (tags[1] == 'chapter_toc.html') {
        node = md.Element.text('chapter_contents', '');
      } else if (tags[1] == 'image.html' && tags.length >= 3) {
        // Images
        var urlMatch =
            RegExp(r'''url=("|')([^"'\n\r]+)("|')''').firstMatch(match[1]!);
        var altMatch =
            RegExp(
              r'''description=("|')([^"'\n\r]*)("|')''',
            ).firstMatch(match[1]!);

        if (urlMatch != null && urlMatch[2] != null) {
          var imgNode = md.Element.withTag('img');
          imgNode.attributes['src'] =
              '${EnvironmentConfig.IB_BASE_URL}${urlMatch[2]}';
          imgNode.attributes['alt'] = altMatch?[2] ?? '';
          // Wrap img in a p block so flutter_markdown treats it as block-level
          node = md.Element('p', [imgNode]);
        }
      } else {
        // Interactions using html
        node = md.Element.text('interaction', tags[1]);
      }
    }

    parser.advance();
    return node ?? md.Element.empty('p');
  }

  @override
  RegExp get pattern => RegExp(r'^\s*{%\s?(.+)\s?%}\s*$');
}
