import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/API/ib_api.dart';
import 'package:html_unescape/html_unescape.dart';

/// Interactive Book Parser Engine
abstract class IbEngineService {
  Future<List<IbChapter>> getChapters();
  Future<IbPageData> getPageData({String id = 'index.md'});
}

class IbEngineServiceImpl implements IbEngineService {
  /// Inject ApiService via locator
  final IbApi _ibApi = locator<IbApi>();

  /// Locally cache Chapters list for the session
  List<IbChapter> _ibChapters = [];

  /// Fetches Pages inside an API Page
  Future<List<IbChapter>> _fetchPagesInDir({
    String id = '',
    bool ignoreIndex = false,
  }) async {
    /// Fetch response from API for the given id
    var _apiResponse;
    try {
      _apiResponse = await _ibApi.fetchApiPage(id: id);
    } catch (_) {
      throw Failure('IbApi: ${_.toString()}');
    }

    var parentPages = <IbChapter>[];
    var childPages = <IbChapter>[];

    // Iterate over the list of pages present inside this response
    for (var page in _apiResponse) {
      // Recursive scan if the page is directory
      if (page['type'] == 'directory') {
        childPages.addAll(await _fetchPagesInDir(id: page['path']));
      } else if (page['has_children'] != null && page['has_children']) {
        // If the page has children inside a directory, it's a parent page
        // All child pages must be present inside parent one
        // refer an example: https://learn.circuitverse.org/_api/pages/docs/binary-representation.json
        parentPages.add(IbChapter(
          id: page['path'],
          value: page['title'],
          navOrder: page['nav_order'].toString(),
          items: childPages,
        ));
      } else {
        // Ignore Index page if flag enabled or page has no title (like 404 page)
        if ((page['title'] == null) ||
            (page['path'] == 'index.md' && ignoreIndex)) {
          continue;
        }

        // Add child page to the list
        childPages.add(IbChapter(
          id: page['path'],
          value: page['title'],
          navOrder: page['nav_order'].toString(),
        ));
      }
    }

    // Sort child pages
    if (parentPages.isNotEmpty) {
      childPages.sort((a, b) => a.navOrder.compareTo(b.navOrder));
    }

    return parentPages.isEmpty ? childPages : parentPages;
  }

  /// Builds Navigation from IbChapters by
  /// Assigning prev and next ids
  List<IbChapter> _buildNav(List<IbChapter> chapters) {
    // We have to flatten the nested chapters and assign prev and next to the objects
    // but return original list of chapters to keep the order intact

    var _flatten = chapters
        .expand((c) => c.items != null ? [c, ...c.items] : [c])
        .toList();

    if (_flatten.length <= 1) {
      return chapters;
    }

    IbChapter prev;

    for (var i = 0; i < _flatten.length; i++) {
      _flatten[i].prevPage = prev;
      if (i + 1 < _flatten.length) {
        _flatten[i].nextPage = _flatten[i + 1];
      }

      prev = _flatten[i];
    }

    return chapters;
  }

  /// Get Chapters and Build Navigation for Interactive Book
  @override
  Future<List<IbChapter>> getChapters() async {
    // Load cached chapters if present
    if (_ibChapters.isNotEmpty) {
      return _ibChapters;
    }

    var _chapters;
    try {
      _chapters = await _fetchPagesInDir(ignoreIndex: true);
    } on Failure catch (e) {
      throw Failure(e.toString());
    }

    // Sort root pages
    _chapters
        .sort((a, b) => int.parse(a.navOrder).compareTo(int.parse(b.navOrder)));

    // Build Navigation
    _chapters = _buildNav(_chapters);

    _ibChapters = _chapters;
    return _ibChapters;
  }

  /// Recursively parses list of table of contents
  List<IbTocItem> _parseToc(Element element, {bool num = true}) {
    var index = num ? 1 : 'a'.codeUnitAt(0);
    var toc = <IbTocItem>[];

    for (var li in element.children) {
      var eff_index = num ? index.toString() : String.fromCharCode(index);
      if (li.getElementsByTagName('ol').isNotEmpty) {
        toc.add(
          IbTocItem(
            content: '$eff_index. ${li.firstChild.text}',
            items: _parseToc(li.children[1], num: !num),
          ),
        );
      } else {
        toc.add(
          IbTocItem(
            content: '$eff_index. ${li.text}',
          ),
        );
      }
      index += 1;
    }

    return toc;
  }

  /// Recursively parses list of chapter contents
  List<IbTocItem> _parseChapterContents(Element element,
      {bool num = true, bool root = false}) {
    var index = num ? 1 : 'a'.codeUnitAt(0);
    var toc = <IbTocItem>[];

    for (var li in element.children) {
      var eff_index = num ? index.toString() : String.fromCharCode(index);
      var sublist = <IbTocItem>[];

      for (var node in li.nodes) {
        if (node is Element && node.localName == 'ul') {
          sublist.addAll(_parseChapterContents(node, num: !num));
          break;
        }
      }

      toc.add(IbTocItem(
        content: root
            ? '$eff_index. ${li.nodes[0].text.trim()}'
            : '$eff_index. ${li.text.trim()}',
        items: sublist.isNotEmpty ? sublist : null,
      ));

      index += 1;
    }

    return toc;
  }

  /// Fetches Table of Contents from HTML content
  List<IbTocItem> _getTableOfContents(String content) {
    var document = parse(content);
    var mdElement = document.getElementById('markdown-toc');

    if (mdElement != null) {
      return _parseToc(mdElement);
    } else {
      return [];
    }
  }

  /// Fetches Chapter of Contents from HTML Content
  List<IbTocItem> _getChapterOfContents(String content) {
    var document = parse(content);
    var mdElement = document.getElementById('chapter-contents-toc');

    if (mdElement != null) {
      return _parseChapterContents(mdElement, root: true);
    } else {
      return [];
    }
  }

  /// Fetches "Rich" Page Content
  @override
  Future<IbPageData> getPageData({String id = 'index.md'}) async {
    /// Fetch Raw Page Data from API
    IbRawPageData _ibRawPageData;
    try {
      _ibRawPageData = await _ibApi.fetchRawPageData(id: id);
    } catch (_) {
      throw Failure(_.toString());
    }

    return IbPageData(
      id: _ibRawPageData.id,
      pageUrl: _ibRawPageData.httpUrl,
      title: _ibRawPageData.title,
      content: [
        IbMd(content: HtmlUnescape().convert(_ibRawPageData.rawContent)),
      ],
      tableOfContents: _ibRawPageData.hasToc
          ? _getTableOfContents(_ibRawPageData.content)
          : [],
      chapterOfContents: _ibRawPageData.hasChildren
          ? _getChapterOfContents(_ibRawPageData.content)
          : [],
    );
  }
}
