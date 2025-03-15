import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:markdown/markdown.dart' as md;

class IbWebViewBuilder extends MarkdownElementBuilder {
  IbWebViewBuilder();

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var textContent = element.textContent;

    return Html(data: textContent, extensions: [
      TagExtension(
          tagsToExtend: {'iframe'},
          builder: (extensionContext) {
            if (extensionContext.buildContext == null) return const SizedBox();
            final width =
                MediaQuery.of(extensionContext.buildContext!).size.width;
            final height = (width * 9) / 16;
            final controller = WebViewController();
            controller
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadRequest(
                  Uri.parse(element.attributes['src'] ?? 'about:blank'));

            return SizedBox(
              width: width,
              height: height,
              child: WebViewWidget(
                controller: controller,
              ),
            );
          }),
    ]);
  }
}
