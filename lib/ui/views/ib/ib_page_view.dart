import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_chapter_contents_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_headings_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_highlight_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_interaction_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_mathjax_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_pop_quiz_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_subscript_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_superscript_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_webview_builder.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_embed_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_filter_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_highlight_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_inline_html_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_liquid_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_mathjax_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_md_tag_syntax.dart';
import 'package:mobile_app/utils/url_launcher.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

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
  }) : super(key: key);

  static const String id = 'ib_page_view';
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
  late IbLandingViewModel _landingModel;
  late AutoScrollController _hideButtonController;
  late IbFloatingButtonState _ibFloatingButtonState;
  late ShowCaseWidgetState _showCaseWidgetState;

  final Map<String, int> _slugMap = {};

  @override
  void initState() {
    _ibFloatingButtonState = IbFloatingButtonState();
    super.initState();
    _showCaseWidgetState = ShowCaseWidget.of(context);
    _landingModel = context.read<IbLandingViewModel>();
    _hideButtonController = AutoScrollController(axis: Axis.vertical);
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _ibFloatingButtonState.makeInvisible();
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        _ibFloatingButtonState.makeVisible();
      }
    });
  }

  @override
  void didChangeDependencies() {
    _showCaseWidgetState = ShowCaseWidget.of(context);
    super.didChangeDependencies();
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(thickness: 1.5),
    );
  }

  Future _scrollToWidget(String slug) async {
    if (_slugMap.containsKey(slug)) {
      await _hideButtonController.scrollToIndex(
        _slugMap[slug]!,
        preferPosition: AutoScrollPosition.begin,
      );
    } else {
      debugPrint('[IB]: $slug not present in map');
    }
  }

  void _onTapLink(String text, String? href, String title) async {
    if (href == null) return;
    if (href.startsWith(EnvironmentConfig.IB_BASE_URL)) {
      if (_model.pageData!.pageUrl.startsWith(href)) {
        return _scrollToWidget(href.substring(1));
      } else {
        launchURL(href);
      }
    }

    if (href.startsWith('#')) {
      return _scrollToWidget(href.substring(1));
    }

    if (await canLaunchUrlString(href)) {
      await launchUrlString(href);
    }
  }

  Widget _buildMarkdown(IbMd data) {
    const _selectable = false;
    final _headingsBuilder = IbHeadingsBuilder(
      slugMap: _slugMap,
      controller: _hideButtonController,
      selectable: _selectable,
    );

    final _inlineBuilders = {
      'sup': IbSuperscriptBuilder(selectable: _selectable),
      'sub': IbSubscriptBuilder(selectable: _selectable),
      'mathjax': IbMathjaxBuilder(),
      'mark': HighlightBuilder(selectable: _selectable),
    };

    return MarkdownBody(
      key: UniqueKey(),
      shrinkWrap: false,
      data: data.content,
      selectable: _selectable,
      imageDirectory: EnvironmentConfig.IB_BASE_URL,
      onTapLink: _onTapLink,
      builders: {
        'img': CustomImageBuilder(
          onTapImage: (src) => debugPrint('Image tapped: $src'),
          wrapImages: true,
          noImageSourceText: AppLocalizations.of(context)!.no_image_source,
          imageLoadErrorText: AppLocalizations.of(context)!.image_load_error,
          loadingImageText: AppLocalizations.of(context)!.loading_image,
        ),
        'h1': _headingsBuilder,
        'h2': _headingsBuilder,
        'h3': _headingsBuilder,
        'h4': _headingsBuilder,
        'h5': _headingsBuilder,
        'h6': _headingsBuilder,
        'chapter_contents': IbChapterContentsBuilder(
          chapterContents:
              _model.pageData?.chapterOfContents?.isNotEmpty ?? false
                  ? _buildTOC(
                    _model.pageData!.chapterOfContents!,
                    padding: false,
                    isEnabled: false,
                  )
                  : Container(),
        ),
        'iframe': IbWebViewBuilder(),
        'interaction': IbInteractionBuilder(model: _model),
        'quiz': IbPopQuizBuilder(context: context, model: _model),
      },
      extensionSet: md.ExtensionSet(
        [
          IbEmbedSyntax(),
          IbFilterSyntax(),
          IbMdTagSyntax(),
          IbLiquidSyntax(),
          ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        ],
        [
          IbInlineHtmlSyntax(builders: _inlineBuilders),
          IbMathjaxSyntax(),
          if (_landingModel.query.isNotEmpty)
            HighlightSyntax(_landingModel.query),
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        ],
      ),
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w300,
        ),
        h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w600,
        ),
        h3: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w600,
        ),
        h4: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: IbTheme.primaryHeadingColor(context),
          fontWeight: FontWeight.w600,
        ),
        h5: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w300),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.5, color: Theme.of(context).dividerColor),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        AppLocalizations.of(context)!.copyright_notice,
        style: const TextStyle(fontSize: 10),
      ),
    );
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
                AppLocalizations.of(context)!.table_of_contents,
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
                        AppLocalizations.of(context)!.navigate_previous_page,
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
                        AppLocalizations.of(context)!.navigate_next_page,
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

  List<Widget> _buildPageContent(IbPageData? pageData) {
    if (pageData == null) {
      return [
        const Column(
          children: [
            SizedBox(height: 120),
            Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          ],
        ),
      ];
    }

    final contents = <Widget>[];
    for (final content in pageData.content ?? []) {
      if (content is IbMd) {
        contents.add(_buildMarkdown(content));
      }
    }
    contents.addAll([_buildDivider(), _buildFooter()]);
    return contents;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<IbPageViewModel>(
      onModelReady: (model) {
        _model = model;
        model.fetchPageData(id: widget.chapter.id);
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

        return Stack(
          children: [
            Scrollbar(
              controller: _hideButtonController,
              child: SingleChildScrollView(
                controller: _hideButtonController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildPageContent(model.pageData),
                ),
              ),
            ),
            if (widget.chapter.prev != null || widget.chapter.next != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFloatingActionButtons(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CustomImageBuilder extends MarkdownElementBuilder {
  final void Function(String)? onTapImage;
  final bool wrapImages;
  final String noImageSourceText;
  final String imageLoadErrorText;
  final String loadingImageText;

  CustomImageBuilder({
    this.onTapImage,
    this.wrapImages = true,
    this.noImageSourceText = 'No image source provided',
    this.imageLoadErrorText = 'Failed to load image',
    this.loadingImageText = 'Loading image...',
  });

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final src = element.attributes['src'] ?? '';
    final alt = element.textContent;

    if (src.isEmpty) {
      return _buildErrorWidget(noImageSourceText);
    }

    Widget image;
    try {
      if (src.toLowerCase().endsWith('.svg')) {
        image = SvgPicture.network(
          src,
          semanticsLabel: alt,
          placeholderBuilder: (_) => _buildLoadingIndicator(),
          height: 200,
          fit: BoxFit.contain,
        );
      } else {
        image = Image.network(
          src,
          semanticLabel: alt,
          loadingBuilder:
              (_, child, progress) =>
                  progress == null ? child : _buildLoadingIndicator(),
          errorBuilder: (_, __, ___) => _buildErrorWidget(imageLoadErrorText),
          fit: BoxFit.contain,
        );
      }
    } catch (e) {
      image = _buildErrorWidget('$imageLoadErrorText: $e');
    }

    if (wrapImages) {
      image = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: image,
      );
    }

    return onTapImage != null
        ? GestureDetector(onTap: () => onTapImage!(src), child: image)
        : image;
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(loadingImageText),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
