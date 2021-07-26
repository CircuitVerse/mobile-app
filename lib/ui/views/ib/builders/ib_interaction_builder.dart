import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IbInteractionBuilder extends MarkdownElementBuilder {
  final IbPageViewModel model;

  IbInteractionBuilder({this.model});

  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    var id = element.textContent;

    return FutureBuilder<dynamic>(
      future: model.fetchHtmlInteraction(id),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (model.isError(model.IB_FETCH_INTERACTION_DATA)) {
          return Text('Error Loading Interaction');
        } else if (model.isBusy(model.IB_FETCH_INTERACTION_DATA) ||
            !snapshot.hasData) {
          return Text('Loading Interaction...');
        }

        var _textContent = snapshot.data.toString();
        var _streamController = StreamController<double>();
        WebViewController _webViewController;

        return StreamBuilder<double>(
          initialData: 100,
          stream: _streamController.stream,
          builder: (context, snapshot) {
            return Container(
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
