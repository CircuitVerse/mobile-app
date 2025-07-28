import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mobile_app/cv_theme.dart';

class CVHtmlEditor extends StatefulWidget {
  const CVHtmlEditor({
    required this.controller,
    this.hasAttachment = true,
    this.height = 300,
    super.key,
  });

  final QuillController controller;
  final double height;
  final bool hasAttachment;

  @override
  State<CVHtmlEditor> createState() => _CVHtmlEditorState();
}

class _CVHtmlEditorState extends State<CVHtmlEditor> {
  @override
  Widget build(BuildContext context) {
    QuillSimpleToolbarConfig toolbarConfig = QuillSimpleToolbarConfig(
      showFontFamily: false,
      showFontSize: false,
      showColorButton: false,
      showBackgroundColorButton: false,
      showClearFormat: false,
      showHeaderStyle: false,
      showListCheck: false,
      showCodeBlock: true,
      showAlignmentButtons: true,
      showQuote: false,
      showIndent: false,
      showSearchButton: false,
    );
    return Container(
      decoration: BoxDecoration(
        color: CVTheme.boxBg(context),
        border: Border.all(color: CVTheme.primaryColorDark),
      ),
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: widget.controller,
            config: toolbarConfig,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.height,
              maxHeight: widget.height,
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: QuillEditor.basic(controller: widget.controller),
            ),
          ),
        ],
      ),
    );
  }
}
