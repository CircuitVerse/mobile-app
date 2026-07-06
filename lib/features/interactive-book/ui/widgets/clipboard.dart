import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/widget_previews.dart';

class Clipboard extends StatelessWidget {
  final String content;

  @Preview(name: "Clipboard")
  const Clipboard({super.key, this.content = '''```\nExample content\n```'''});

  @override
  Widget build(BuildContext context) {
    final markdown = '```\n$content\n```';
    return MarkdownBody(data: markdown, selectable: true);
  }
}
