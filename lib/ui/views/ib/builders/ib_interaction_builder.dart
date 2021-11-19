import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IbInteractionBuilder extends MarkdownElementBuilder {
  IbInteractionBuilder({this.model});
  
  final IbPageViewModel model;


  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    var id = element.textContent;

    return FutureBuilder<dynamic>(
      future: model.fetchHtmlInteraction(id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data is Failure) {
          return const Text('Error Loading Interaction');
        } else if (!snapshot.hasData) {
          return const Text('Loading Interaction...');
        }

        var _textContent = snapshot.data.toString();
        var _streamController = StreamController<double>();
        WebViewController _webViewController;

        return StreamBuilder<double>(
          initialData: 100,
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return SizedBox(
              height: snapshot.data,
              child: WebView(
                initialUrl:
                    'data:text/html;base64,${base64Encode(const Utf8Encoder().convert(_textContent))}',
                onPageFinished: (some) async {
                  var height = double.parse(
                      await _webViewController.evaluateJavascript(
                          'document.documentElement.scrollHeight;'));
                  _streamController.add(height);
                },
                onWebViewCreated: (_controller) {
                  _webViewController = _controller;
                },
                javascriptMode: JavascriptMode.unrestricted,
              ),
            );
          },
        );
      },
    );
  }
}
