import 'package:markdown/markdown.dart' as md;

class IbMdTagSyntax extends md.BlockSyntax {
  final _tagsStack = <String>[];
  IbMdTagSyntax() : super();

  @override
  md.Node parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current);
    _tagsStack.addAll(match[1].split(' '));

    // Subtitle Syntax
    // This is a temporary workaround for subtitle
    // Since Markdown tags after text is not supported
    if (_tagsStack.contains('.fs-9')) {
      parser.advance();
      parser.advance();
      var text = parser.current;

      _tagsStack.remove('.fs-9');
      parser.advance();
      return md.Element.text('h5', text);
    }

    // (TODO) Fix Pop Quizes
    if (_tagsStack.contains('.quiz')) {
      // Ignore parsing quiz content
      do {
        parser.advance();
      } while (!parser.isDone);

      _tagsStack.remove('.quiz');

      return null;
    }

    parser.advance();

    return null;
  }

  @override
  RegExp get pattern => RegExp(r'{:\s?(.+)\s?}');
}
