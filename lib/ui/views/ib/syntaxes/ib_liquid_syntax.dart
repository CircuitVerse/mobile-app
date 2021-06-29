import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/config/environment_config.dart';

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
      } else if (tags[1] == 'image.html' && tags.length >= 3) {
        // Images
        var url = RegExp('url="([^"\n\r]+)"').firstMatch(match[1])[1];
        var alt = RegExp('description="([^"\n\r]+)"').firstMatch(match[1])[1];

        node = md.Element.withTag('img');
        node.attributes['src'] = '${EnvironmentConfig.IB_BASE_URL}$url';
        node.attributes['alt'] = alt;
      }

      // [TODO] interactions that will use webview
    }

    parser.advance();

    return node;
  }

  @override
  RegExp get pattern => RegExp(r'{%\s?(.+)\s?%}');
}
