import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_chapter_contents_builder.dart';
import 'package:mobile_app/ui/views/ib/builders/ib_webview_builder.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_embed_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_filter_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_liquid_syntax.dart';
import 'package:mobile_app/ui/views/ib/syntaxes/ib_md_tag_syntax.dart';
import 'package:mobile_app/utils/url_launcher.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

typedef TocCallback = void Function(Function);
typedef SetPageCallback = void Function(IbChapter);

class IbPageView extends StatefulWidget {
  static const String id = 'ib_page_view';
  final TocCallback tocCallback;
  final SetPageCallback setPage;
  final IbChapter chapter;

  IbPageView({
    @required Key key,
    @required this.tocCallback,
    @required this.chapter,
    @required this.setPage,
  }) : super(key: key);

  @override
  _IbPageViewState createState() => _IbPageViewState();
}

class _IbPageViewState extends State<IbPageView> {
  IbPageViewModel _model;
  ScrollController _hideButtonController;
  bool _isFabsVisible = true;

  @override
  void initState() {
    super.initState();
    _isFabsVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => _isFabsVisible = false);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() => _isFabsVisible = true);
      }
    });
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  void _onTapLink(String text, String href, String title) async {
    // Confirm if it's a valid URL
    if (!(await canLaunch(href))) {
      print('[IB]: $href is not a valid link');
      return;
    }

    // If Interactive Book link
    if (href.startsWith(EnvironmentConfig.IB_BASE_URL)) {
      // If URI is same as the current page
      if (_model.pageData.pageUrl.startsWith(href)) {
        // It's local link
        // (TODO) Scroll to that local widget
        return;
      } else {
        // Try to navigate to another page using url
        // (TODO) We need [IbLandingViewModel] to be able to get Chapter using [httpUrl]
        return;
      }
    }

    launchURL(href);
  }

  Widget _buildMarkdown(IbMd data) {
    return MarkdownBody(
      data: data.content,
      selectable: true,
      imageDirectory: EnvironmentConfig.IB_BASE_URL,
      onTapLink: _onTapLink,
      blockBuilders: {
        'iframe': IbWebViewBuilder(context: context),
        'chapter_contents': IbChapterContentsBuilder(
            chapterContents: _model.pageData?.chapterOfContents?.isNotEmpty ??
                    false
                ? _buildTOC(_model.pageData.chapterOfContents, padding: false)
                : Container()),
      },
      extensionSet: md.ExtensionSet(
        [
          IbEmbedSyntax(),
          IbFilterSyntax(),
          IbMdTagSyntax(),
          IbLiquidSyntax(),
          ...md.ExtensionSet.gitHubFlavored.blockSyntaxes
        ],
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      styleSheet: MarkdownStyleSheet(
        h1: Theme.of(context).textTheme.headline4.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w300,
            ),
        h2: Theme.of(context).textTheme.headline5.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
        h3: Theme.of(context).textTheme.headline6.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
        h4: Theme.of(context).textTheme.subtitle1.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
        h5: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        'Copyright © 2021 Contributors to CircuitVerse. Distributed under a [CC-by-sa] license.',
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildTocListTile(String content,
      {bool root = true, bool padding = true}) {
    if (!root) {
      return ListTile(
        leading: Text(''),
        visualDensity: !padding ? VisualDensity(vertical: -3) : null,
        contentPadding: EdgeInsets.symmetric(horizontal: padding ? 16.0 : 0.0),
        minLeadingWidth: 20,
        title: Text(content),
      );
    }

    return ListTile(
      visualDensity: !padding ? VisualDensity(vertical: -3) : null,
      contentPadding: EdgeInsets.symmetric(horizontal: padding ? 16.0 : 0.0),
      title: Text(content),
    );
  }

  List<Widget> _buildTocItems(IbTocItem item,
      {bool root = false, bool padding = true}) {
    var items = <Widget>[
      _buildTocListTile(
        item.content,
        root: root,
        padding: padding,
      ),
    ];

    if (item.items != null) {
      for (var e in item.items) {
        items.addAll(
          _buildTocItems(
            e,
            padding: padding,
          ),
        );
      }
    }

    return items;
  }

  Widget _buildTOC(List<IbTocItem> toc, {bool padding = true}) {
    var items = <Widget>[];

    for (var item in toc) {
      items.addAll(
        _buildTocItems(
          item,
          root: true,
          padding: padding,
        ),
      );
    }

    return Column(
      children: items,
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ListTile(
              title: Text(
                'Table of Contents',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
              tileColor: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: _buildTOC(_model.pageData.tableOfContents),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButtons() {
    var alignment = MainAxisAlignment.spaceBetween;
    var buttons = <Widget>[];

    if (widget.chapter.prev != null) {
      if (widget.chapter.next == null) {
        alignment = MainAxisAlignment.start;
      }

      buttons.add(
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _isFabsVisible ? 1.0 : 0.0,
          child: FloatingActionButton(
            heroTag: 'previousPage',
            mini: true,
            child: Icon(
              Icons.arrow_back_rounded,
              color: IbTheme.primaryColor,
            ),
            backgroundColor: Theme.of(context).primaryIconTheme.color,
            onPressed: () => widget.setPage(widget.chapter.prev),
          ),
        ),
      );
    }

    if (widget.chapter.next != null) {
      if (widget.chapter.prev == null) {
        alignment = MainAxisAlignment.end;
      }

      buttons.add(
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _isFabsVisible ? 1.0 : 0.0,
          child: FloatingActionButton(
            heroTag: 'nextPage',
            mini: true,
            child: Icon(
              Icons.arrow_forward_rounded,
              color: IbTheme.primaryColor,
            ),
            backgroundColor: Theme.of(context).primaryIconTheme.color,
            onPressed: () => widget.setPage(widget.chapter.next),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: alignment,
      children: buttons,
    );
  }

  List<Widget> _buildPageContent(IbPageData pageData) {
    if (pageData == null) {
      return [
        Text(
          'Loading ...',
          style: Theme.of(context).textTheme.headline6.copyWith(
                color: IbTheme.primaryHeadingColor(context),
                fontWeight: FontWeight.w600,
              ),
        ),
      ];
    }

    var contents = <Widget>[];

    for (var content in pageData.content) {
      switch (content.runtimeType) {
        case IbMd:
          contents.add(_buildMarkdown(content as IbMd));
          break;
      }
    }

    contents.addAll([
      _buildDivider(),
      _buildFooter(),
    ]);

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
      },
      builder: (context, model, child) {
        // Set the callback to show bottom sheet for Table of Contents
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
            widget.chapter.prev != null || widget.chapter.next != null
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildFloatingActionButtons(),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
