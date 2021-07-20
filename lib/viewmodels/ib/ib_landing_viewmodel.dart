import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class IbLandingViewModel extends BaseModel {
  // ViewState Keys
  String IB_FETCH_CHAPTERS = 'ib_fetch_chapters';

  final IbEngineService _ibEngineService = locator<IbEngineService>();

  List<IbChapter> _chapters = [];

  List<IbChapter> get chapters => _chapters;

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
