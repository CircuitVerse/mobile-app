import 'package:flutter/widgets.dart';

class TextWidget extends StatelessWidget {
  final String size;
  final String content;

  const TextWidget({super.key, required this.size, required this.content});

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
