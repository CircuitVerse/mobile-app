import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_pop_quiz_question.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class IbPageViewModel extends BaseModel {
  // ViewState Keys
  String ibFetchPageDataKey = 'ib_fetch_page_data';
  String ibFetchInteractionDataKey = 'ib_fetch_interaction_data';
  String ibFetchPopQuizKey = 'ib_fetch_pop_quiz';

  final IbEngineService _ibEngineService = locator<IbEngineService>();

  IbPageData _pageData;
  IbPageData get pageData => _pageData;

  Future fetchPageData({String id = 'index.md'}) async {
    try {
      _pageData = await _ibEngineService.getPageData(id: id);

      setStateFor(ibFetchPageDataKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(ibFetchPageDataKey, ViewState.Error);
      setErrorMessageFor(ibFetchPageDataKey, f.message);
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

  List<IbPopQuizQuestion> fetchPopQuiz(String rawContent) {
    try {
      var result = _ibEngineService.getPopQuiz(rawContent);
      return result;
    } on Failure {
      return [];
    }
  }
}
