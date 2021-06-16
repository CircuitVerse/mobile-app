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
    var _apiResponse;
    try {
      _apiResponse = await _ibApi.fetchApiPage(id: id);
    } catch (_) {
      throw Failure('IbApi: ${_.toString()}');
    }

    var result = <IbChapter>[];
    var childPages = <IbChapter>[];

    for (var page in _apiResponse) {
      if (page['type'] == 'directory') {
        childPages.addAll(await _fetchPagesInDir(id: page['path']));
      } else if (page['has_children'] != null && page['has_children']) {
        result.add(IbChapter(
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

        childPages.add(IbChapter(
          id: page['path'],
          value: page['title'],
          navOrder: page['nav_order'].toString(),
        ));
      }
    }

    // Sort child pages
    if (result.isNotEmpty) {
      childPages.sort((a, b) => a.navOrder.compareTo(b.navOrder));
    } else if (id == '') {
      // Sort root pages
      childPages.sort(
          (a, b) => int.parse(a.navOrder).compareTo(int.parse(b.navOrder)));
    }

    return result.isEmpty ? childPages : result;
  }

  /// Get Chapters and Build Navigation for Interactive Book
  @override
  Future<List<IbChapter>> getChapters() async {
    // Load cached chapters if present
    if (_ibChapters.isNotEmpty) {
      return _ibChapters;
    }

    try {
      _ibChapters = await _fetchPagesInDir(ignoreIndex: true);
    } on Failure catch (e) {
      throw Failure(e.toString());
    }

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
    );
  }
}
