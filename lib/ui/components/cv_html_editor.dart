import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:mobile_app/cv_theme.dart';

class CVHtmlEditor extends StatelessWidget {
  const CVHtmlEditor({
    required this.editorKey,
    this.hasAttachment = true,
    this.height = 300,
    Key? key,
  }) : super(key: key);

  final GlobalKey<FlutterSummernoteState> editorKey;
  final double height;
  final bool hasAttachment;

  @override
  Widget build(BuildContext context) {
    return FlutterSummernote(
      height: height,
      decoration: BoxDecoration(
        color: CVTheme.htmlEditorBg,
        border: Border.all(
          color: CVTheme.primaryColorDark,
        ),
      ),
      key: editorKey,
      hasAttachment: hasAttachment,
      customToolbar: """
          [
            ['view', ['codeview', 'undo', 'redo']],
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['link', 'hr']]
          ]
        """,
    );
  }
}
