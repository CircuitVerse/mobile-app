import 'package:markdown/markdown.dart' as md;

class IbMdTagSyntax extends md.BlockSyntax {
  IbMdTagSyntax() : super();

  final _tagsStack = <String>[];

  @override
  md.Node? parse(md.BlockParser parser) {
    var match = pattern.firstMatch(parser.current.content);
    if (match == null) {
      parser.advance();
      return md.Element.empty('p');
    }
    _tagsStack.addAll(match[1]!.split(' '));

    // Subtitle Syntax
    // This is a temporary workaround for subtitle
    // Since Markdown tags after text is not supported
    if (_tagsStack.contains('.fs-9')) {
      parser.advance();
      if (parser.isDone) {
        _tagsStack.remove('.fs-9');
        return md.Element.empty('p');
      }
      parser.advance();
      if (parser.isDone) {
        _tagsStack.remove('.fs-9');
        return md.Element.empty('p');
      }
      var text = parser.current;

      _tagsStack.remove('.fs-9');
      parser.advance();
      return md.Element.text('h5', text.content);
    }

    // Pop Quizzes
    if (_tagsStack.contains('.quiz')) {
      var quizContent = '';

      parser.advance();

      while (!parser.isDone) {
        var line = parser.current.content;
        if (pattern.hasMatch(line) || line.startsWith('#')) {
          break;
        }
        quizContent += '\n$line';
        parser.advance();
      }

      _tagsStack.remove('.quiz');
      return md.Element.text('quiz', quizContent);
    }

    parser.advance();

    return md.Element.empty('p');
  }

  @override
  RegExp get pattern => RegExp(r'{:\s?(.+)\s?}');
}
