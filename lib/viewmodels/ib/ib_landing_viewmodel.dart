import 'package:flutter/material.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class IbLandingViewModel extends BaseModel {
  // ViewState Keys
  String IB_FETCH_CHAPTERS = 'ib_fetch_chapters';

  final IbEngineService _ibEngineService = locator<IbEngineService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  // Global Keys
  final GlobalKey _toc = GlobalKey(debugLabel: 'toc');
  final GlobalKey _drawer = GlobalKey(debugLabel: 'drawer');

  // Getter for Global Keys
  GlobalKey get toc => _toc;
  GlobalKey get drawer => _drawer;

  // Getter for Global Keys Map
  Map<String, dynamic> get keyMap => <String, dynamic>{
        'toc': _toc,
        'drawer': _drawer,
      };

  List<IbChapter> _chapters = [];

  List<IbChapter> get chapters => _chapters;

  // ShowCaseState stores the information of whether the button which is to be
  // showcased are clicked or not
  IBShowCase _showCaseState;

  IBShowCase get showCaseState => _showCaseState;

  set showCaseState(IBShowCase updatedState) {
    _showCaseState = updatedState;
    notifyListeners();
  }

  void onShowCased(String key) {
    switch (key) {
      case 'next':
        if (!_showCaseState.nextButton) {
          _showCaseState = _showCaseState.copyWith(nextButton: true);
        }
        break;
      case 'prev':
        if (!_showCaseState.prevButton) {
          _showCaseState = _showCaseState.copyWith(prevButton: true);
        }
        break;
      case 'toc':
        if (!_showCaseState.tocButton) {
          _showCaseState = _showCaseState.copyWith(tocButton: true);
        }
        break;
      case 'drawer':
        if (!_showCaseState.drawerButton) {
          _showCaseState = _showCaseState.copyWith(drawerButton: true);
        }
        break;
    }
    notifyListeners();
  }

  void saveShowcaseState() {
    _localStorageService.setShowcaseState = _showCaseState.toString();
  }

  void init() {
    _showCaseState = IBShowCase.fromJson(_localStorageService.getShowcaseState);
    fetchChapters();
  }

  Future fetchChapters() async {
    try {
      _chapters = await _ibEngineService.getChapters();
      setStateFor(IB_FETCH_CHAPTERS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(IB_FETCH_CHAPTERS, ViewState.Error);
      setErrorMessageFor(IB_FETCH_CHAPTERS, f.message);
    }
  }
}
