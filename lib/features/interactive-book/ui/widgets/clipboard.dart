import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/widget_previews.dart';

class ClipboardWidget extends StatelessWidget {
  final String content;

  @Preview(name: "Clipboard")
  const ClipboardWidget({super.key, this.content = 'Example content'});

  @override
  Widget build(BuildContext context) {
    final markdown = '```\n$content\n```';
    return MarkdownBody(data: markdown, selectable: true);
  }
}
