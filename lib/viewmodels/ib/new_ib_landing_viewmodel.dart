import 'package:flutter/material.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/models/ib/new_ib_home_data.dart';
import 'package:mobile_app/models/ib/new_ib_chapter_index_data.dart';
import 'package:mobile_app/models/ib/new_ib_topic_data.dart';
import 'package:mobile_app/services/API/new_ib_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class NewIbLandingViewModel extends BaseModel {
  // ViewState Keys
  final String NEW_IB_FETCH_DRAWER = 'new_ib_fetch_drawer';
  final String NEW_IB_FETCH_HOME = 'new_ib_fetch_home';
  final String NEW_IB_FETCH_CHAPTER_INDEX = 'new_ib_fetch_chapter_index';
  final String NEW_IB_FETCH_TOPIC = 'new_ib_fetch_topic';

  final NewIbApi _newIbApi = locator<NewIbApi>();

  NewIbDrawerData? _drawerData;
  NewIbDrawerData? get drawerData => _drawerData;

  NewIbHomeData? _homeData;
  NewIbHomeData? get homeData => _homeData;

  NewIbChapterIndexData? _chapterIndexData;
  NewIbChapterIndexData? get chapterIndexData => _chapterIndexData;

  NewIbTopicData? _topicData;
  NewIbTopicData? get topicData => _topicData;

  List<NewIbChapter> get chapters => _drawerData?.chapters ?? [];
  
  NewIbDrawerMetadata? get metadata => _drawerData?.metadata;
  
  List<NewIbFooterLink> get footerLinks => _drawerData?.footerLinks ?? [];

  // Selected chapter
  NewIbChapter? _selectedChapter;
  NewIbChapter? get selectedChapter => _selectedChapter;
  
  // Selected sub-chapter
  NewIbSubChapter? _selectedSubChapter;
  NewIbSubChapter? get selectedSubChapter => _selectedSubChapter;
  
  void selectChapter(NewIbChapter? chapter) {
    _selectedChapter = chapter;
    _selectedSubChapter = null; // Clear sub-chapter when selecting parent
    _chapterIndexData = null; // Clear chapter index data
    _topicData = null; // Clear topic data
    
    // Fetch chapter index data if chapter has children
    if (chapter != null && chapter.children != null && chapter.children!.isNotEmpty) {
      fetchChapterIndexData(chapter.path);
    }
    
    notifyListeners();
  }
  
  void selectSubChapter(NewIbChapter parentChapter, NewIbSubChapter subChapter) {
    _selectedChapter = parentChapter;
    _selectedSubChapter = subChapter;
    notifyListeners();
  }

  // Home state
  bool _isHome = true;
  bool get isHome => _isHome;
  
  void setHome(bool value) {
    _isHome = value;
    notifyListeners();
  }

  Future<void> init() async {
    await Future.wait([
      fetchDrawerData(),
      fetchHomeData(),
    ]);
  }

  Future<void> fetchDrawerData() async {
    try {
      setStateFor(NEW_IB_FETCH_DRAWER, ViewState.Busy);
      _drawerData = await _newIbApi.fetchDrawerData();
      setStateFor(NEW_IB_FETCH_DRAWER, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(NEW_IB_FETCH_DRAWER, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_DRAWER, f.message);
    } catch (e) {
      setStateFor(NEW_IB_FETCH_DRAWER, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_DRAWER, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<void> fetchHomeData() async {
    try {
      setStateFor(NEW_IB_FETCH_HOME, ViewState.Busy);
      _homeData = await _newIbApi.fetchHomeData();
      setStateFor(NEW_IB_FETCH_HOME, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(NEW_IB_FETCH_HOME, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_HOME, f.message);
    } catch (e) {
      setStateFor(NEW_IB_FETCH_HOME, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_HOME, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<void> fetchChapterIndexData(String path) async {
    try {
      setStateFor(NEW_IB_FETCH_CHAPTER_INDEX, ViewState.Busy);
      _chapterIndexData = await _newIbApi.fetchChapterIndexData(path);
      setStateFor(NEW_IB_FETCH_CHAPTER_INDEX, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(NEW_IB_FETCH_CHAPTER_INDEX, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_CHAPTER_INDEX, f.message);
    } catch (e) {
      setStateFor(NEW_IB_FETCH_CHAPTER_INDEX, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_CHAPTER_INDEX, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<void> fetchTopicData(String path) async {
    try {
      setStateFor(NEW_IB_FETCH_TOPIC, ViewState.Busy);
      _topicData = await _newIbApi.fetchTopicData(path);
      setStateFor(NEW_IB_FETCH_TOPIC, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(NEW_IB_FETCH_TOPIC, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_TOPIC, f.message);
    } catch (e) {
      setStateFor(NEW_IB_FETCH_TOPIC, ViewState.Error);
      setErrorMessageFor(NEW_IB_FETCH_TOPIC, 'Unexpected error: ${e.toString()}');
    }
  }
}
