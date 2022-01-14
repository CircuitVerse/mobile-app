import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_pop_quiz_question.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/API/ib_api.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mobile_app/utils/api_utils.dart';

/// Interactive Book Parser Engine
abstract class IbEngineService {
  /// Generates slug from given [text]
  static String getSlug(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]+'), '')
        .replaceAll(RegExp(r'\s+'), '-');
  }

  Future<List<IbChapter>>? getChapters();
  Future<IbPageData?>? getPageData({String id = 'index.md'});
  Future<String>? getHtmlInteraction(String id);
  List<IbPopQuizQuestion>? getPopQuiz(String rawPopQuizContent);
}

class IbEngineServiceImpl implements IbEngineService {
  /// Inject ApiService via locator
  final IbApi _ibApi = locator<IbApi>();

  /// Locally cache Chapters list for the session
  List<IbChapter> _ibChapters = [];

  /// module.js URL for interaction
  final _intModuleJsUrl =
      '${EnvironmentConfig.IB_BASE_URL}/assets/js/module.js';

  /// Base path for interactions
  final _intBaseUrl =
      'https://raw.githubusercontent.com/CircuitVerse/Interactive-Book/master/_includes';

  /// module.js contents
  String? _intModuleJs;

  /// Fetches Pages inside an API Page
  Future<List<IbChapter>> _fetchPagesInDir({
    String id = '',
    bool ignoreIndex = false,
  }) async {
    /// Fetch response from API for the given id
    List<Map<String, dynamic>>? _apiResponse;
    try {
      _apiResponse = await _ibApi.fetchApiPage(id: id);
    } catch (_) {
      throw Failure('IbApi: ${_.toString()}');
    }

    var parentPages = <IbChapter>[];
    var childPages = <IbChapter>[];

    // Iterate over the list of pages present inside this response
    for (var page in _apiResponse ?? []) {
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
        .expand((c) => c.items != null ? [c, ...c.items!] : [c])
        .toList();

    if (_flatten.length <= 1) {
      return chapters;
    }

    IbChapter? prev;

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
  Future<List<IbChapter>>? getChapters() async {
    // Load cached chapters if present
    if (_ibChapters.isNotEmpty) {
      return _ibChapters;
    }

    List<IbChapter> _chapters;
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

    return _ibChapters = _chapters;
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
            leading: '$eff_index.',
            content: li.firstChild!.text!,
            items: _parseToc(li.children[1], num: !num),
          ),
        );
      } else {
        toc.add(
          IbTocItem(
            leading: '$eff_index.',
            content: li.text,
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
          sublist.addAll(_parseChapterContents(
            node,
            num: !num,
          ));
          break;
        }
      }

      toc.add(
        IbTocItem(
          leading: '$eff_index.',
          content: root ? li.nodes[0].text!.trim() : li.text.trim(),
          items: sublist.isNotEmpty ? sublist : null,
        ),
      );

      index += 1;
    }

    return toc;
  }

  /// Fetches Table of Contents from HTML content
  List<IbTocItem> _getTableOfContents(String content) {
    var document = parse(content);
    var mdElement = document.getElementById('markdown-toc');

    return mdElement != null ? _parseToc(mdElement) : [];
  }

  /// Fetches Chapter of Contents from HTML Content
  List<IbTocItem> _getChapterOfContents(String content) {
    var document = parse(content);
    var mdElement = document.getElementById('chapter-contents-toc');

    return mdElement != null
        ? _parseChapterContents(mdElement, root: true)
        : [];
  }

  /// Fetches "Rich" Page Content
  @override
  Future<IbPageData?>? getPageData({String id = 'index.md'}) async {
    /// Fetch Raw Page Data from API
    IbRawPageData? _ibRawPageData;
    try {
      _ibRawPageData = await _ibApi.fetchRawPageData(id: id);
    } catch (_) {
      throw Failure(_.toString());
    }

    if (_ibRawPageData == null) return null;

    return IbPageData(
      id: _ibRawPageData.id,
      pageUrl: _ibRawPageData.httpUrl,
      title: _ibRawPageData.title,
      content: [
        IbMd(content: '${HtmlUnescape().convert(_ibRawPageData.rawContent)}\n'),
      ],
      tableOfContents: _ibRawPageData.hasToc
          ? _getTableOfContents(_ibRawPageData.content!)
          : [],
      chapterOfContents: _ibRawPageData.hasChildren
          ? _getChapterOfContents(_ibRawPageData.content!)
          : [],
    );
  }

  /// Fetches HTML Interaction from the given [id]
  /// id is basically the file-name of the HTML interaction
  /// Every Interaction uses module.js which also has to be used
  @override
  Future<String>? getHtmlInteraction(String id) async {
    // Fetch JS content if not already fetched
    _intModuleJs ??= await ApiUtils.get(_intModuleJsUrl, rawResponse: true);

    // Fetch Interaction HTML
    String html = await ApiUtils.get('$_intBaseUrl/$id', rawResponse: true);

    // concat JS + HTML
    var js = '<script type="text/javascript">\n$_intModuleJs\n</script>';
    var result = '$js\n$html';

    // Replace local URLs with absolute
    return result = result.replaceAll(
        RegExp(r'(\.\.(\/\.\.)?)?(?<!org)\/assets'),
        '${EnvironmentConfig.IB_BASE_URL}/assets');
  }

  @override
  List<IbPopQuizQuestion>? getPopQuiz(String popQuizContent) {
    var _pattern = RegExp(r'(\d\.|\*)\s(.+)');
    var _questions = <IbPopQuizQuestion>[];

    for (var line in popQuizContent.split('\n')) {
      var match = _pattern.firstMatch(line);

      if (match == null) {
        continue;
      }

      if (!line.startsWith(_pattern)) {
        // Answer Choices
        var _lastQuestion = _questions.last;

        // If is correct answer
        if (match[1] != '*') {
          _lastQuestion.answers.add(_lastQuestion.choices.length);
        }

        _lastQuestion.choices.add(match[2]!);
      } else {
        // Question
        _questions.add(IbPopQuizQuestion(
          question: match[2]!,
          answers: [],
          choices: [],
        ));
      }
    }

    return _questions;
  }
}
