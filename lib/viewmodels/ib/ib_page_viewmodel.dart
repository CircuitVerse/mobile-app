import 'package:flutter/material.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_pop_quiz_question.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:mobile_app/services/ib_offline_service.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/services/ib_progress_service.dart';
class IbPageViewModel extends BaseModel {
  // ViewState Keys
  final String IB_FETCH_PAGE_DATA = 'ib_fetch_page_data';
  final String IB_FETCH_INTERACTION_DATA = 'ib_fetch_interaction_data';
  final String IB_FETCH_POP_QUIZ = 'ib_fetch_pop_quiz';
  final IbProgressService _progressService = locator<IbProgressService>();
  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }  
  final IbOfflineService _offlineService = locator<IbOfflineService>();
  bool isOfflineAvailable = false;

  // List of Global Keys to be Showcase
  late List<GlobalKey> _list;

  // Global Keys
  final GlobalKey _nextPage = GlobalKey(debugLabel: 'next');
  final GlobalKey _prevPage = GlobalKey(debugLabel: 'prev');

  // Getter for Global Keys
  GlobalKey get nextPage => _nextPage;
  GlobalKey get prevPage => _prevPage;

  final IbEngineService _ibEngineService = locator<IbEngineService>();

  IbPageData? _pageData;
  IbPageData? get pageData => _pageData;

  // Future? fetchPageData({String id = 'index.md'}) async {
  //   try {
  //     _pageData = await _ibEngineService.getPageData(id: id);

  //     setStateFor(IB_FETCH_PAGE_DATA, ViewState.Success);
  //   } on Failure catch (f) {
  //     setStateFor(IB_FETCH_PAGE_DATA, ViewState.Error);
  //     setErrorMessageFor(IB_FETCH_PAGE_DATA, f.message);
  //   }
  // }

  Future saveReadingProgress({
    required String bookId,
    required String chapterId,
    required double scrollPosition,
    required double maxScroll,
  }) async {

    double progress = 0;

    if (maxScroll > 0) {
      progress = (scrollPosition / maxScroll) * 100;
    }

    await _progressService.saveProgress(
      bookId: bookId,
      chapterId: chapterId,
      progress: progress,
      scrollPosition: scrollPosition,
    );
  }

  Future fetchPageData({String id = 'index.md'}) async {
    isOfflineAvailable=false;
    if (!disposed) {
      setStateFor(IB_FETCH_PAGE_DATA, ViewState.Busy);
    }
    try {

      _pageData = await _ibEngineService.getPageData(id: id);

      String markdown = "";
      for (var c in _pageData!.content ?? []) {
        if (c is IbMd) {
          markdown += c.content;
        }
      }

      
      if (markdown.isNotEmpty) {
        try {
          await _offlineService.saveChapter(id, markdown);
          isOfflineAvailable = true;
        } catch (_) {
          isOfflineAvailable = false;
        }
      }
    

    // setStateFor(IB_FETCH_PAGE_DATA, ViewState.Success);
    if (!disposed) {
      setStateFor(IB_FETCH_PAGE_DATA, ViewState.Success);
    }

    } on Failure catch (_) {

      final cachedMarkdown = await _offlineService.loadChapter(id);

      if (cachedMarkdown != null) {
        _pageData = IbPageData(
          id: id,
          pageUrl: "",
          title: "Offline Chapter",
          content: [IbMd(content: cachedMarkdown)],
          tableOfContents: null,
          chapterOfContents: null,
          
        );

        isOfflineAvailable = true;
        // setStateFor(IB_FETCH_PAGE_DATA, ViewState.Success);
        if (!disposed) {
          setStateFor(IB_FETCH_PAGE_DATA, ViewState.Success);
        }
      } else {
        // setStateFor(IB_FETCH_PAGE_DATA, ViewState.Error);
        if (!disposed) {
          setStateFor(IB_FETCH_PAGE_DATA, ViewState.Error);
        }
      }
    }
  }
  Future fetchHtmlInteraction(String id) async {
    try {
      var result = await _ibEngineService.getHtmlInteraction(id);
      return result;
    } on Failure catch (f) {
      return f;
    }
  }  


  void showCase(
    ShowCaseWidgetState showCaseWidgetState,
    IBShowCase state,
    Map<String, dynamic> keysMap,
  ) {
    _list = <GlobalKey>[];

    if (!state.nextButton) _list.add(_nextPage);
    if (!state.prevButton) _list.add(_prevPage);
    if (!state.drawerButton) _list.add(keysMap['drawer']);
    if (!state.tocButton) _list.add(keysMap['toc']);
    if (_list.isEmpty) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!showCaseWidgetState.mounted) return;
          final validKeys = _list.where((key) {
            final ctx = key.currentContext;
            if (ctx == null) return false;

            final renderObject = ctx.findRenderObject();
            if (renderObject == null) return false;
            if (!renderObject.attached) return false;

            return true;
          }).toList();
          if (validKeys.isEmpty) return;
          try {
            showCaseWidgetState.startShowCase(validKeys);
          }
          catch (e) {
            debugPrint("Showcase skipped: $e");
        }
      });
    });
  }

  List<IbPopQuizQuestion>? fetchPopQuiz(String rawContent) {
    try {
      var result = _ibEngineService.getPopQuiz(rawContent);
      return result;
    } on Failure {
      return [];
    }
  }
}
