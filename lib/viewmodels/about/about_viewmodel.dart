import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class AboutViewModel extends BaseModel {
  final _contributorsApi = locator<ContributorsApi>();

  List<CircuitVerseContributors> _cvContributors;

  List<CircuitVerseContributors> get cvContributors => _cvContributors;

  set cvContributors(List<CircuitVerseContributors> cvContributors) {
    _cvContributors = cvContributors;
    notifyListeners();
  }

  Future fetchContributors() async {
    setState(ViewState.Busy);
    try {
      cvContributors = await _contributorsApi.fetchContributors();
      setState(ViewState.Success);
    } on Failure catch (f) {
      setErrorMessage(f.message);
      setState(ViewState.Error);
    }
  }
}
