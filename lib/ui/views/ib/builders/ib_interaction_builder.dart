import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IbInteractionBuilder extends MarkdownElementBuilder {
  IbInteractionBuilder({required this.model});

  final IbPageViewModel model;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final id = element.textContent;

    return FutureBuilder<dynamic>(
      future: model.fetchHtmlInteraction(id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data is Failure) {
          return const Text('Error Loading Interaction');
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final textContent = snapshot.data.toString();
        return IbInteractionWidget(htmlContent: textContent);
      },
    );
  }
}

class IbInteractionWidget extends StatefulWidget {
  final String htmlContent;
  const IbInteractionWidget({Key? key, required this.htmlContent})
      : super(key: key);

  @override
  State<IbInteractionWidget> createState() => _IbInteractionWidgetState();
}

class _IbInteractionWidgetState extends State<IbInteractionWidget> {
  final StreamController<double> _heightStreamController =
      StreamController<double>();
  late final WebViewController _webViewController;
  double _height = 100; // Initial height

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(widget.htmlContent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            try {
              final result = await _webViewController.runJavaScriptReturningResult(
                'document.documentElement.scrollHeight;'
              );
              
              // Convert result to double (result is already a number with the new API)
              final newHeight = result is num ? result.toDouble() : 100.0;
              
              if (!_heightStreamController.isClosed) {
                _heightStreamController.add(newHeight);
                setState(() {
                  _height = newHeight;
                });
              }
            } catch (e) {
              debugPrint('Error getting webview height: $e');
            }
          },
        ),
      );
  }

  @override
  void dispose() {
    _heightStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: _height,
      stream: _heightStreamController.stream,
      builder: (context, streamSnapshot) {
        return SizedBox(
          height: streamSnapshot.data,
          width: double.infinity,
          child: WebViewWidget(controller: _webViewController),
        );
      },
    );
  }
}

