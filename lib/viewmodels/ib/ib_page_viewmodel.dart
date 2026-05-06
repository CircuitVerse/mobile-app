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

class IbPageViewModel extends BaseModel {
  // ViewState Keys
  final String IB_FETCH_PAGE_DATA = 'ib_fetch_page_data';
  final String IB_FETCH_INTERACTION_DATA = 'ib_fetch_interaction_data';
  final String IB_FETCH_POP_QUIZ = 'ib_fetch_pop_quiz';

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

  Future? fetchPageData({String id = 'index.md'}) async {
    try {
      _pageData = await _ibEngineService.getPageData(id: id);

      setStateFor(IB_FETCH_PAGE_DATA, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(IB_FETCH_PAGE_DATA, ViewState.Error);
      setErrorMessageFor(IB_FETCH_PAGE_DATA, f.message);
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

    if (_list.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 800), () {
          showCaseWidgetState.startShowCase(_list);
        });
      });
    }
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
