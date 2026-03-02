import 'package:markdown/markdown.dart' as md;

class IbMathjaxBlockSyntax extends md.BlockSyntax {
  IbMathjaxBlockSyntax() : super();

  @override
  RegExp get pattern => RegExp(r'^\$(\$|\\begin\{)');

  @override
  md.Node? parse(md.BlockParser parser) {
    final currentLine = parser.current.content;
    var content = '';

    if (currentLine.trimLeft().startsWith(r'$\begin{') ||
        currentLine.trimLeft().startsWith(r'$\Begin{')) {
      content = currentLine.substring(currentLine.indexOf(r'$') + 1);
      parser.advance();


      if (content.trimRight().endsWith(r'}$')) {
        content = content.trimRight();
        content = content.substring(0, content.length - 1);
      } else {
        while (!parser.isDone) {
          final line = parser.current.content;
          content += '\n$line';
          parser.advance();
          if (line.trimRight().endsWith(r'}$')) {
            content = content.trimRight();
            if (content.endsWith(r'$')) {
              content = content.substring(0, content.length - 1);
            }
            break;
          }
        }
      }
    } else {

      final match = RegExp(r'^\$\$(.*)$').firstMatch(currentLine);
      if (match != null && match[1]!.trim().isNotEmpty) {
        content += match[1]!.trim();
      }
      parser.advance();

      while (!parser.isDone) {
        final line = parser.current.content;
        if (line.trim() == r'$$') {
          parser.advance();
          break;
        }

        if (line.trimRight().endsWith(r'$$')) {
          content +=
              '\n${line.trimRight().substring(0, line.trimRight().length - 2)}';
          parser.advance();
          break;
        }
        content += '\n$line';
        parser.advance();
      }
    }

    return md.Element.text('mathjax_block', content.trim());
  }
}
