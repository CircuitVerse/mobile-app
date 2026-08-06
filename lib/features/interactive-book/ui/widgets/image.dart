import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/image.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ImageWidget extends StatefulWidget {
  final Content content;

  const ImageWidget({super.key, required this.content});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..loadRequest(Uri.parse(widget.content.link));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 200, child: WebViewWidget(controller: _controller));
  }
}
