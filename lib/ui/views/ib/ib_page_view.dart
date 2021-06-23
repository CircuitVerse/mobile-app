import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';

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

  Widget _buildH1(IbHeading data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        data.content,
        style: Theme.of(context).textTheme.headline4.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }

  Widget _buildH2(IbHeading data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        data.content,
        style: Theme.of(context).textTheme.headline5.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildH3(IbHeading data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        data.content,
        style: Theme.of(context).textTheme.headline6.copyWith(
              color: IbTheme.primaryHeadingColor(context),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildSubtitle(IbHeading data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        data.content,
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _buildHeadings(IbHeading content) {
    switch (content.type) {
      case IbHeadingType.h1:
        return _buildH1(content);
      case IbHeadingType.h2:
        return _buildH2(content);
      case IbHeadingType.h3:
        return _buildH3(content);
      case IbHeadingType.h4:
        return _buildH3(content);
      case IbHeadingType.h5:
        return _buildH3(content);
      case IbHeadingType.h6:
        return _buildH3(content);
      case IbHeadingType.subtitle:
        return _buildSubtitle(content);
    }

    return Container();
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        thickness: 1.5,
      ),
    );
  }

  Widget _buildParagraph(IbParagraph data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        data.content,
        textAlign: TextAlign.justify,
        style: TextStyle(
          height: 1.2,
        ),
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

  Widget _buildTocListTile(String content, {bool root = true}) {
    if (!root) {
      return ListTile(
        leading: Text(''),
        minLeadingWidth: 20,
        title: Text(content),
      );
    }

    return ListTile(
      title: Text(content),
    );
  }

  List<Widget> _buildTocItems(IbTocItem item, {bool root = false}) {
    var items = <Widget>[_buildTocListTile(item.content, root: root)];

    if (item.items != null) {
      for (var e in item.items) {
        items.addAll(_buildTocItems(e));
      }
    }

    return items;
  }

  Widget _buildTOC() {
    var items = <Widget>[];

    for (var item in _model.pageData.tableOfContents) {
      items.addAll(_buildTocItems(item, root: true));
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
                child: _buildTOC(),
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
        case IbHeading:
          contents.add(_buildHeadings(content as IbHeading));
          break;
        case IbParagraph:
          contents.add(_buildParagraph(content as IbParagraph));
          break;
        case IbDivider:
          contents.add(_buildDivider());
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
            SingleChildScrollView(
              controller: _hideButtonController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildPageContent(model.pageData),
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
