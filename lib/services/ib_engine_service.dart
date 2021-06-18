import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/API/ib_api.dart';

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

  /// Regex Grammers
  final Map<String, RegExp> grammers = {
    'headings_md': RegExp(r'([#]+)\s(.+)'),
    'p_md': RegExp(r'(\n|^)[^{}](.*?)[^{}](?=\n|$)'),
    'hr_md': RegExp(r'-{3}'),
    'md_tags': RegExp(r'^{:\s?(.+)\s?}$'),
  };

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
    // but return chapters to keep the list intact

    var _flatten = chapters.expand((c) => [c, ...c.items]).toList();

    if (_flatten.length <= 1) {
      return chapters;
    }

    String prev;

    for (var i = 0; i < _flatten.length; i++) {
      _flatten[i].prevPage = prev;
      if (i + 1 < _flatten.length) {
        _flatten[i].nextPage = _flatten[i + 1].id;
      }

      prev = _flatten[i].id;
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

  /// Interactive Book Page Parser
  List<IbContent> _pageParser(IbRawPageData data) {
    // Markdown Parsing
    var _mdParser = <IbContent>[];

    // Md flags
    var _mdFlags = [];

    for (final block in data.rawContent.split(RegExp(r'\n+'))) {
      if (grammers['headings_md'].hasMatch(block)) {
        // Headings Markdown
        var headingsWeight =
            grammers['headings_md'].firstMatch(block)?.group(1)?.length ?? 1;

        var headingsContent =
            grammers['headings_md'].firstMatch(block)?.group(2);

        var headingType;
        switch (headingsWeight) {
          case 1:
            headingType = IbHeadingType.h1;
            break;
          case 2:
            headingType = IbHeadingType.h2;
            break;
          case 3:
            headingType = IbHeadingType.h3;
            break;
          case 4:
            headingType = IbHeadingType.h4;
            break;
          case 5:
            headingType = IbHeadingType.h5;
            break;
          case 6:
            headingType = IbHeadingType.h6;
            break;
          default:
            headingType = IbHeadingType.h1;
            break;
        }

        _mdParser.add(IbHeading(content: headingsContent, type: headingType));
      } else if (grammers['hr_md'].hasMatch(block)) {
        // Dividers
        _mdParser.add(IbDivider());
      } else if (grammers['p_md'].hasMatch(block)) {
        // Subtitle
        if (_mdFlags.contains('.fs-9 ')) {
          _mdFlags.remove('.fs-9 ');

          _mdParser
              .add(IbHeading(content: block, type: IbHeadingType.subtitle));
          continue;
        }

        // Paragraphs
        // If Paragraph repeated then append content
        if (_mdParser.last is IbParagraph) {
          (_mdParser.last as IbParagraph).content += ' ${block}';
        } else {
          _mdParser.add(IbParagraph(content: block));
        }
      } else if (grammers['md_tags'].hasMatch(block)) {
        // Markdown tags
        var mdFlag = grammers['md_tags'].firstMatch(block)?.group(1);
        _mdFlags.add(mdFlag);
      } else {
        // Unknown tags

      }
    }

    return _mdParser;
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

  /// Fetches Table of Contents from HTML content
  List<IbTocItem> _getTableOfContents(String content) {
    var document = parse(content);
    var mdElement = document.getElementById('markdown-toc');

    if (mdElement != null) {
      return _parseToc(mdElement);
    }

    throw Failure('Failed to find id "markdown-toc" in DOM');
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
      title: _ibRawPageData.title,
      content: _pageParser(_ibRawPageData),
      tableOfContents: _ibRawPageData.hasToc
          ? _getTableOfContents(_ibRawPageData.content)
          : [],
    );
  }
}
