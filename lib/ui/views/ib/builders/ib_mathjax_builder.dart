import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

Widget _buildMathTex(
  String tex, {
  MathStyle mathStyle = MathStyle.text,
  TextStyle? textStyle,
}) {
  return Math.tex(
    tex,
    mathStyle: mathStyle,
    textStyle: textStyle,
    onErrorFallback: (err) => Text(
      tex,
      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
    ),
  );
}

TextStyle _safeMathStyle(BuildContext context, TextStyle? preferredStyle) {
  final resolved = DefaultTextStyle.of(context).style.merge(preferredStyle);
  return resolved.copyWith(
    fontSize: resolved.fontSize ?? 14.0,
    color: resolved.color ?? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
  );
}

String _cleanTex(String content) {
  content = content.replaceAll('\\begin{equation}', ' ');
  content = content.replaceAll('\\end{equation}', ' ');
  content = content.replaceAll(RegExp(r'\\tag\{.+?\}'), ' ');
  content = content.replaceAll(RegExp(r'\\{3,}'), '\\\\');
  content = content.replaceAll(r'\_', '_');
  content = content.replaceAll(r'\*', '*');
  return content.trim();
}

/// Inline math builder for $...$ expressions.
class IbMathjaxBuilder extends MarkdownElementBuilder {
  IbMathjaxBuilder();

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    var content = _cleanTex(element.textContent.trim());
    final style = _safeMathStyle(context, preferredStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32;
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildMathTex(content, textStyle: style),
          ),
        );
      },
    );
  }
}


class IbMathjaxBlockBuilder extends MarkdownElementBuilder {
  IbMathjaxBlockBuilder();

  @override
  bool isBlockElement() => true;

  @override
  Widget visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    var content = _cleanTex(element.textContent.trim());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _buildMathTex(
          content,
          mathStyle: MathStyle.display,
          textStyle: _safeMathStyle(context, preferredStyle),
        ),
      ),
    );
  }
}
