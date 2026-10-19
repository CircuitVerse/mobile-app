import 'package:flutter/widgets.dart';
import 'package:flutter/widget_previews.dart';

class TextWidget extends StatelessWidget {
  final String size;
  final String content;

  const TextWidget({super.key, required this.size, required this.content});

  @Preview(name: 'Text - Heading (H1)')
  static Widget preview() =>
   const TextWidget(size: 'H1', content: 'What is a bit?');

  @Preview(name: 'Text - Body (P)')
  static Widget previewBody() =>
   const TextWidget(size: 'P', content: 'A bit is the smallest unit of data.');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        content,
        style: TextStyle(fontSize: size == 'H1' ? 24 : 15, height: 1.5),
      ),
    );
  }
}
