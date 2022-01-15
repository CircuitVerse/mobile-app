import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class AboutViewModel extends BaseModel {
  // ViewState Keys
  final String fetchCONTRIBUTORS = 'fetch_contributors';

  final _contributorsApi = locator<ContributorsApi>();

  List<CircuitVerseContributor> _cvContributors;

  List<CircuitVerseContributor> get cvContributors => _cvContributors;

  set cvContributors(List<CircuitVerseContributor> cvContributors) {
    _cvContributors = cvContributors;
    notifyListeners();
  }

  Future fetchContributors() async {
    setStateFor(fetchCONTRIBUTORS, ViewState.Busy);
    try {
      cvContributors = await _contributorsApi.fetchContributors();

      setStateFor(fetchCONTRIBUTORS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchCONTRIBUTORS, ViewState.Error);
      setErrorMessageFor(fetchCONTRIBUTORS, f.message);
    }
  }
}
