import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IbInteractionBuilder extends MarkdownElementBuilder {
  IbInteractionBuilder({required this.model});

  final IbPageViewModel model;

  @override
  bool isBlockElement() => true;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var id = element.textContent;
    return _IbInteractionWidget(id: id, model: model);
  }
}

class _IbInteractionWidget extends StatefulWidget {
  const _IbInteractionWidget({required this.id, required this.model});

  final String id;
  final IbPageViewModel model;

  @override
  State<_IbInteractionWidget> createState() => _IbInteractionWidgetState();
}

class _IbInteractionWidgetState extends State<_IbInteractionWidget> {
  Future<dynamic>? _future;
  WebViewController? _webController;
  StreamController<double>? _streamController;
  bool _webViewInitialized = false;
  bool _userTappedLoad = false;

  void _loadInteraction() {
    setState(() {
      _userTappedLoad = true;
      _future = widget.model.fetchHtmlInteraction(widget.id);
    });
  }

  void _initWebView(String htmlContent) {
    if (_webViewInitialized) return;
    _webViewInitialized = true;

    _streamController = StreamController<double>();
    _webController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) async {
                if (!mounted) return;
                try {
                  final result = await _webController!
                      .runJavaScriptReturningResult(
                        'document.documentElement.scrollHeight;',
                      );
                  if (!mounted) return;
                  final height = double.tryParse(result.toString()) ?? 400;
                  _streamController?.add(height);
                } catch (_) {
                  if (mounted) _streamController?.add(400);
                }
              },
            ),
          )
          ..loadHtmlString(htmlContent);
  }

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_userTappedLoad) {
      return GestureDetector(
        onTap: _loadInteraction,
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_outline,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Tap to load interaction',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return FutureBuilder<dynamic>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError ||
            snapshot.data is Failure ||
            (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData)) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Error Loading Interaction'),
              TextButton(
                onPressed: _loadInteraction,
                child: const Text('Retry'),
              ),
            ],
          );
        } else if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        _initWebView(snapshot.data.toString());

        return StreamBuilder<double>(
          initialData: 100,
          stream: _streamController!.stream,
          builder: (context, snapshot) {
            return SizedBox(
              height: snapshot.data,
              child: WebViewWidget(controller: _webController!),
            );
          },
        );
      },
    );
  }
}
