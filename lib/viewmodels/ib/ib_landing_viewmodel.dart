import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class IbLandingViewModel extends BaseModel {
  // ViewState Keys
  final String IB_FETCH_CHAPTERS = 'ib_fetch_chapters';

  final IbEngineService _ibEngineService = locator<IbEngineService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  // Isolate variables
  late ReceivePort receivePort, otherResponseReceivePort;
  late SendPort otherSendPort;
  Isolate? _isolate;

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

  // Search Bar State
  bool _showSearchBar = false;
  bool get showSearchBar => _showSearchBar;
  set showSearchBar(bool val) {
    _showSearchBar = val;
    ibChapters = [];
    currentIndex = 0;
    notifyListeners();
  }

  // Query
  String _query = '';
  String get query => _query;
  set query(String val) {
    _query = val.trim();
    ibChapters = [];
    _updateSearch();
    // Search in the interactive book only
    // when query is non empty
    if (_query.isNotEmpty) {
      otherSendPort.send([val, otherResponseReceivePort.sendPort]);
    }
    notifyListeners();
  }

  // Search Controller
  final AutoScrollController searchController = AutoScrollController();

  // Reset state
  void reset() {
    _showSearchBar = false;
    _query = '';
    notifyListeners();
  }

  // Chapters containing query in it
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    _currentIndex = value;
    _setChapter();
    _updateSearch();
  }

  List<IbChapter> ibChapters = [];
  ValueNotifier<String> searchNotifier = ValueNotifier('0/0');

  void _updateSearch() {
    _setChapter();
    searchNotifier.value =
        ibChapters.isEmpty ? '0/0' : '${currentIndex + 1}/${ibChapters.length}';
  }

  void setUpIsolate() async {
    receivePort = ReceivePort();

    _isolate = await Isolate.spawn<List<dynamic>>(
      fetchCallback,
      [
        receivePort.sendPort,
        [
          IbChapter(
            id: 'index.md',
            navOrder: '1',
            value: 'Interactive Book Home',
            next: chapters[0],
          ),
          ...chapters
        ],
        _ibEngineService
      ],
    );

    otherSendPort = await receivePort.first;

    otherResponseReceivePort = ReceivePort();

    otherResponseReceivePort.listen((chapter) {
      if (chapter is IbChapter) {
        ibChapters.add(chapter);
        _setChapter();
        _updateSearch();
      }
    });
  }

  static void fetchCallback(List<dynamic> values) async {
    final otherReceivePort = ReceivePort();

    final SendPort port = values[0];
    port.send(otherReceivePort.sendPort);

    final _service = values[2] as IbEngineService;

    otherReceivePort.listen((message) async {
      final query = message[0];

      final SendPort otherResponseSendPort = message[1];

      for (final chapter in (values[1] as List<IbChapter>)) {
        List<IbChapter> subChapters = [chapter, ...(chapter.items ?? [])];
        for (final subChapter in subChapters) {
          final pageData = await _service.getPageData(id: subChapter.id);
          final contents = pageData?.content ?? [];
          for (final con in contents) {
            if (con.content.contains(RegExp(query, caseSensitive: false))) {
              otherResponseSendPort.send(subChapter);
            }
          }
        }
      }
    });
  }

  void close() {
    _isolate?.kill(priority: Isolate.immediate);
  }

  // ShowCaseState stores the information of whether the button which is to be
  // showcased are clicked or not
  late IBShowCase _showCaseState;

  IBShowCase get showCaseState => _showCaseState;

  set showCaseState(IBShowCase updatedState) {
    _showCaseState = updatedState;
    notifyListeners();
  }

  // Interactive Book Chapters
  final IbChapter homeChapter = IbChapter(
    id: 'index.md',
    navOrder: '1',
    value: 'Interactive Book Home',
  );
  IbChapter? _selectedChapter;
  IbChapter get selectedChapter => _selectedChapter!;
  set selectedChapter(IbChapter chapter) {
    _selectedChapter = chapter;
    notifyListeners();
  }

  void _setChapter() {
    if (ibChapters.isEmpty) return;

    if (_selectedChapter!.id != ibChapters[currentIndex].id) {
      selectedChapter = ibChapters[currentIndex];
    }
  }

  void onShowCased(String key) {
    switch (key) {
      case 'next':
        if (!_showCaseState.nextButton) {
          _showCaseState = _showCaseState.copyWith(nextButton: true);
          saveShowcaseState();
        }
        break;
      case 'prev':
        if (!_showCaseState.prevButton) {
          _showCaseState = _showCaseState.copyWith(prevButton: true);
          saveShowcaseState();
        }
        break;
      case 'toc':
        if (!_showCaseState.tocButton) {
          _showCaseState = _showCaseState.copyWith(tocButton: true);
          saveShowcaseState();
        }
        break;
      case 'drawer':
        if (!_showCaseState.drawerButton) {
          _showCaseState = _showCaseState.copyWith(drawerButton: true);
          saveShowcaseState();
        }
        break;
    }
    notifyListeners();
  }

  void saveShowcaseState() {
    _localStorageService.setShowcaseState = _showCaseState.toString();
  }

  void init() async {
    _showCaseState = IBShowCase.fromJson(_localStorageService.getShowcaseState);
    _selectedChapter = homeChapter;
    await fetchChapters();
    setUpIsolate();
  }

  Future? fetchChapters() async {
    try {
      _chapters = await _ibEngineService.getChapters()!;
      setStateFor(IB_FETCH_CHAPTERS, ViewState.Success);
      homeChapter.nextPage = chapters[0];
      chapters[0].prev = homeChapter;
    } on Failure catch (f) {
      setStateFor(IB_FETCH_CHAPTERS, ViewState.Error);
      setErrorMessageFor(IB_FETCH_CHAPTERS, f.message);
    }
  }
}
