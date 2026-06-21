import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/widget_previews.dart';

class LessonPage extends StatelessWidget {
  @Preview(name: "Clipboard")
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    const markdown = '''
```yaml
Given number        1  0  1  0  1
1's complement      0  1  0  1  0

add 1               +           1
                    ---------------
2's complement      0  1  0  1  1
                    ---------------
''';
    return Markdown(data: markdown, selectable: true);
  }
}
