import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:markdown/markdown.dart' as md;

class IbWebViewBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  IbWebViewBuilder({this.context});

  @override
  Widget visitElementAfter(md.Element element, TextStyle preferredStyle) {
    var textContent = element.textContent;

    return Html(
      data: textContent,
      customRender: {
        'iframe': (RenderContext context, Widget child) {
          final width = MediaQuery.of(context.buildContext).size.width;
          final height = (width * 9) / 16;

          return SizedBox(
            width: width,
            height: height,
            child: WebView(
              initialUrl: context.tree.element.attributes['src'],
              javascriptMode: JavascriptMode.unrestricted,
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            ),
          );
        },
      },
    );
  }
}
