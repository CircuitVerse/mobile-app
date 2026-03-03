import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/config/environment_config.dart';

class IbLiquidSyntax extends md.BlockSyntax {
  IbLiquidSyntax() : super();

  @override
  md.Node? parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current.content);
    if (match == null) return null;
    var tags = match[1]!.split(' ');
    md.Element? node;

    // Liquid include tags
    if (tags[0] == 'include') {
      // chapter_toc include
      if (tags[1] == 'chapter_toc.html') {
        node = md.Element('p', [md.Element.withTag('chapter_contents')]);
      } else if (tags[1] == 'image.html' && tags.length >= 3) {
        // Images
        var url =
            RegExp(r'''url=("|')([^"'\n\r]+)("|')''').firstMatch(match[1]!)![2];
        var alt =
            RegExp(
              r'''description=("|')([^"'\n\r]*)("|')''',
            ).firstMatch(match[1]!)![2];

        var img = md.Element.withTag('img');
        img.attributes['src'] = '${EnvironmentConfig.IB_BASE_URL}$url';
        img.attributes['alt'] = alt!;
        node = md.Element('p', [img]);
      } else {
        // Interactions using html
        // Use attribute 'id' for data-via-attributes fix
        var intNode = md.Element.withTag('interaction');
        intNode.attributes['id'] = tags[1];
        node = md.Element('p', [intNode]);
      }
    }

    parser.advance();
    // Ensure all results are wrapped in p for paragraph protection
    return node ?? md.Element('p', [md.Element.withTag('empty')]);
  }

  @override
  RegExp get pattern => RegExp(r'{%\s?(.+)\s?%}');
}
