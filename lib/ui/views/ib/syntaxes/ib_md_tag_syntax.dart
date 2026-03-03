import 'package:markdown/markdown.dart' as md;

class IbMdTagSyntax extends md.BlockSyntax {
  IbMdTagSyntax() : super();

  final _tagsStack = <String>[];

  @override
  md.Node? parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current.content);
    if (match == null) return null;
    _tagsStack.addAll(match[1]!.split(' '));

    // Subtitle Syntax
    // This is a temporary workaround for subtitle
    // Since Markdown tags after text is not supported
    if (_tagsStack.contains('.fs-9')) {
      parser.advance();
      parser.advance();
      var text = parser.current;

      _tagsStack.remove('.fs-9');
      parser.advance();
      return md.Element.text('h5', text.content);
    }

    // Pop Quizzes
    if (_tagsStack.contains('.quiz')) {
      var quizContent = '';

      // Eat all quiz content
      do {
        quizContent += '\n${parser.current}';
        parser.advance();
      } while (parser.next != null || !parser.isDone);

      _tagsStack.remove('.quiz');
      // Wrap in p for paragraph protection and use attributes for data
      return md.Element('p', [
        md.Element.withTag('quiz')..attributes['content'] = quizContent,
      ]);
    }

    parser.advance();

    // Never return null after advancing the parser to keep it in sync
    // Ensure placeholder is wrapped in p for block-level protection
    return md.Element('p', [md.Element.withTag('empty')]);
  }

  @override
  RegExp get pattern => RegExp(r'{:\s?(.+)\s?}');
}
