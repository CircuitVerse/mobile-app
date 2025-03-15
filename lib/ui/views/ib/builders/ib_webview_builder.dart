import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:markdown/markdown.dart' as md;

class IbWebViewBuilder extends MarkdownElementBuilder {
  IbWebViewBuilder();

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var textContent = element.textContent;

    return Builder(
      builder: (context) {
        final double width = MediaQuery.of(context).size.width;
        final double height = (width * 9) / 16;

        return Html(
          data: textContent,
          extensions: [
            TagExtension(
              tagsToExtend: {"iframe"},
              builder: (extensionContext) {
                final String url = 
                    extensionContext.attributes['src'] ?? 'about:blank';
                
                // Create and configure WebViewController
                final WebViewController controller = WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onNavigationRequest: (NavigationRequest request) {
                        return NavigationDecision.navigate;
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(url));
                
                return SizedBox(
                  width: width,
                  height: height,
                  child: WebViewWidget(controller: controller),
                );
              },
            ),
          ],
        );
      },
    );
  }
}



