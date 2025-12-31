import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/url_launcher.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../viewmodels/ib/ib_floating_button_state.dart';

typedef TocCallback = void Function(Function?);
typedef SetPageCallback = void Function(IbChapter?);
typedef SetShowCaseStateCallback = void Function(IBShowCase);

class IbPageView extends StatefulWidget {
  const IbPageView({
    required Key key,
    required this.tocCallback,
    required this.chapter,
    required this.setPage,
    required this.showCase,
    required this.setShowCase,
    required this.globalKeysMap,
    this.enableWebView = true,
  }) : super(key: key);

  static const String id = 'ib_page_view';
  final bool enableWebView;
  final TocCallback tocCallback;
  final SetPageCallback setPage;
  final IbChapter chapter;
  final IBShowCase showCase;
  final SetShowCaseStateCallback setShowCase;
  final Map<String, dynamic> globalKeysMap;

  @override
  _IbPageViewState createState() => _IbPageViewState();
}

class _IbPageViewState extends State<IbPageView> {
  late IbPageViewModel _model;

  late IbFloatingButtonState _ibFloatingButtonState;
  late ShowCaseWidgetState _showCaseWidgetState;

  late final WebViewController _webViewController;
  bool _isLoading = true;
  String? _currentUrl;
  Timer? _hideTimer;

  static const String _cssToHideElements = '''
  a.btn.btn-info,
  .prev-next-controls,
  #disqus_thread, 
  #disqus_recommendations,
  #giscus, 
  .giscus, 
  .comments, 
  #comments,
  .site-title,
  .navbar,
  .side-bar,
  #back-to-top,
  #sidebarCollapse {
    display: none !important;
    visibility: hidden !important;
  }
''';

  static const String _cleanPageJs = '''
    const cleanPage = () => {
      document.querySelectorAll('a.btn.btn-info, .prev-next-controls, .navbar, .site-title, .side-bar, #back-to-top, #sidebarCollapse')
        .forEach(e => e.remove());

      document.querySelectorAll(
        '#disqus_thread, #disqus_recommendations, #giscus, .giscus, .comments, #comments'
      ).forEach(e => e.remove());
    };
''';

  @override
  void initState() {
    _ibFloatingButtonState = IbFloatingButtonState();
    super.initState();
    _startHideTimer();
    _showCaseWidgetState = ShowCaseWidget.of(context);

    if (widget.enableWebView) {
      _webViewController =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..addJavaScriptChannel(
              'IbInteractionChannel',
              onMessageReceived: (JavaScriptMessage message) {
                _onUserInteraction();
              },
            )
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (String url) async {
                  if (mounted) {
                    setState(() {
                      _isLoading = true;
                    });
                  }
                  await _webViewController.runJavaScript('''
(function () {
  // ---- Cleanup old observer if any ----
  if (window.__ibMutationObserver) {
    try {
      window.__ibMutationObserver.disconnect();
    } catch (e) {}
    window.__ibMutationObserver = null;
  }

  const cleanPage = () => {
    document.querySelectorAll(
      'a.btn.btn-info, .prev-next-controls, .navbar, .site-title, .side-bar, #back-to-top, #sidebarCollapse'
    ).forEach(e => e.remove());

    document.querySelectorAll(
      '#disqus_thread, #disqus_recommendations, #giscus, .giscus, .comments, #comments'
    ).forEach(e => e.remove());
  };

  // Initial cleanup passes
  cleanPage();
  setTimeout(cleanPage, 50);
  setTimeout(cleanPage, 200);
  setTimeout(cleanPage, 500);

  // ---- Create observer ----
  const observer = new MutationObserver(() => {
    cleanPage();
  });

  observer.observe(document.body, {
    childList: true,
    subtree: true,
  });

  window.__ibMutationObserver = observer;

  // ---- Auto-disconnect after stabilization ----
  setTimeout(() => {
    if (window.__ibMutationObserver) {
      window.__ibMutationObserver.disconnect();
      window.__ibMutationObserver = null;
    }
  }, 2000); // adjust if needed
})();
''');
                },
                onPageFinished: (String url) async {
                  if (!mounted) return;

                  await _webViewController.runJavaScript('''
(function() {
  const style = document.createElement('style');
  style.textContent = `$_cssToHideElements`;
  document.head.insertBefore(style, document.head.firstChild);

  $_cleanPageJs

  cleanPage();
  setTimeout(cleanPage, 50);
  setTimeout(cleanPage, 200);
  setTimeout(cleanPage, 500);
})();
''');

                  setState(() {
                    _isLoading = false;
                  });
                },

                onWebResourceError: (WebResourceError error) {
                  debugPrint('WebView Error: ${error.description}');
                },
                onNavigationRequest: (NavigationRequest request) {
                  if (request.url.startsWith(EnvironmentConfig.IB_BASE_URL)) {
                    return NavigationDecision.navigate;
                  }
                  launchURL(request.url);
                  return NavigationDecision.prevent;
                },
              ),
            );
    }
  }

  @override
  void didChangeDependencies() {
    _showCaseWidgetState = ShowCaseWidget.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 10), () {
      _ibFloatingButtonState.makeInvisible();
    });
  }

  void _onUserInteraction() {
    _ibFloatingButtonState.makeVisible();
    _startHideTimer();
  }

  void _loadPageIfNeeded(IbPageViewModel model) {
    final newUrl = model.pageData?.pageUrl;
    if (newUrl == null || newUrl == _currentUrl) return;

    _currentUrl = newUrl;
    _webViewController.loadRequest(Uri.parse(newUrl));
  }

  Future _scrollToWidget(String slug) async {
    final jsCode = '''
      var element = document.getElementById('$slug');
      if (element) {
        element.scrollIntoView({behavior: "smooth", block: "start", inline: "nearest"});
      } else {
        console.log("Element with id $slug not found");
      }
    ''';
    await _webViewController.runJavaScript(jsCode);
  }

  Widget _buildTocListTile(
    String leading,
    String content, {
    bool root = true,
    bool padding = true,
    bool isEnabled = true,
  }) {
    final tile = ListTile(
      leading: root ? null : const Text(''),
      visualDensity: !padding ? const VisualDensity(vertical: -3) : null,
      contentPadding: EdgeInsets.symmetric(horizontal: padding ? 16.0 : 0.0),
      minLeadingWidth: 20,
      title: Text('$leading $content'),
      onTap:
          isEnabled
              ? () async {
                final slug = IbEngineService.getSlug(content);
                if (Navigator.canPop(context)) Navigator.pop(context);
                await _scrollToWidget(slug);
              }
              : null,
    );

    return root
        ? tile
        : Padding(padding: const EdgeInsets.only(left: 16.0), child: tile);
  }

  List<Widget> _buildTocItems(
    IbTocItem item, {
    bool root = false,
    bool padding = true,
    bool isEnabled = true,
  }) {
    final items = <Widget>[
      _buildTocListTile(
        item.leading,
        item.content,
        root: root,
        padding: padding,
        isEnabled: isEnabled,
      ),
    ];

    if (item.items != null) {
      for (final e in item.items!) {
        items.addAll(_buildTocItems(e, padding: padding, isEnabled: isEnabled));
      }
    }

    return items;
  }

  Widget _buildTOC(
    List<IbTocItem> toc, {
    bool padding = true,
    bool isEnabled = true,
  }) {
    final items = <Widget>[];
    for (final item in toc) {
      items.addAll(
        _buildTocItems(
          item,
          root: true,
          padding: padding,
          isEnabled: isEnabled,
        ),
      );
    }
    return Column(children: items);
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.ib_page_table_of_contents,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              tileColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _buildTOC(_model.pageData!.tableOfContents!),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButtons() {
    final buttons = <Widget>[];
    final alignment =
        widget.chapter.prev != null && widget.chapter.next != null
            ? MainAxisAlignment.spaceBetween
            : widget.chapter.prev != null
            ? MainAxisAlignment.start
            : MainAxisAlignment.end;

    if (widget.chapter.prev != null) {
      buttons.add(
        ChangeNotifierProvider.value(
          value: _ibFloatingButtonState,
          child: Consumer<IbFloatingButtonState>(
            builder: (context, _, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _ibFloatingButtonState.isVisible ? 1.0 : 0.0,
                child: FloatingActionButton(
                  heroTag: 'previousPage',
                  mini: true,
                  backgroundColor: Theme.of(context).primaryIconTheme.color,
                  onPressed:
                      _ibFloatingButtonState.isVisible
                          ? () => widget.setPage(widget.chapter.prev)
                          : null,
                  child: Showcase(
                    key: _model.prevPage,
                    description:
                        AppLocalizations.of(context)!.ib_page_navigate_previous,
                    targetPadding: const EdgeInsets.all(12.0),
                    targetShapeBorder: const CircleBorder(),
                    onTargetClick: () {
                      widget.setShowCase(
                        widget.showCase.copyWith(prevButton: true),
                      );
                      widget.setPage(widget.chapter.prev);
                    },
                    disposeOnTap: true,
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: IbTheme.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    if (widget.chapter.next != null) {
      buttons.add(
        ChangeNotifierProvider.value(
          value: _ibFloatingButtonState,
          child: Consumer<IbFloatingButtonState>(
            builder: (context, _, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _ibFloatingButtonState.isVisible ? 1.0 : 0.0,
                child: FloatingActionButton(
                  heroTag: 'nextPage',
                  mini: true,
                  backgroundColor: Theme.of(context).primaryIconTheme.color,
                  onPressed:
                      _ibFloatingButtonState.isVisible
                          ? () => widget.setPage(widget.chapter.next)
                          : null,
                  child: Showcase(
                    key: _model.nextPage,
                    description:
                        AppLocalizations.of(context)!.ib_page_navigate_next,
                    targetPadding: const EdgeInsets.all(12.0),
                    targetShapeBorder: const CircleBorder(),
                    onTargetClick: () {
                      widget.setShowCase(
                        widget.showCase.copyWith(nextButton: true),
                      );
                      widget.setPage(widget.chapter.next);
                    },
                    disposeOnTap: false,
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: IbTheme.primaryColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return Row(mainAxisAlignment: alignment, children: buttons);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<IbPageViewModel>(
      onModelReady: (model) {
        _model = model;

        model.fetchPageData(id: widget.chapter.id);

        model.addListener(() {
          if (!mounted) return;
          _loadPageIfNeeded(model);
        });

        model.showCase(
          _showCaseWidgetState,
          widget.showCase,
          widget.globalKeysMap,
        );
      },

      builder: (context, model, child) {
        if (_model.isSuccess(_model.IB_FETCH_PAGE_DATA) &&
            (model.pageData?.tableOfContents?.isNotEmpty ?? false)) {
          widget.tocCallback(_showBottomSheet);
        } else {
          widget.tocCallback(null);
        }

        return Listener(
          onPointerDown: (_) => _onUserInteraction(),
          onPointerMove: (_) => _onUserInteraction(),
          child: Stack(
            children: [
              if (model.pageData != null && !_isLoading)
                widget.enableWebView
                    ? WebViewWidget(controller: _webViewController)
                    : const SizedBox.shrink(),

              if (model.pageData == null || _isLoading)
                const Center(child: CircularProgressIndicator(strokeWidth: 3)),
              if (widget.chapter.prev != null || widget.chapter.next != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: _buildFloatingActionButtons(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
