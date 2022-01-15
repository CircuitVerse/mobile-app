import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class UserProjectsViewModel extends BaseModel {
  // ViewState Keys
  String fetchUSERPROJECTS = 'fetch_user_projects';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  final List<Project> _userProjects = [];

  List<Project> get userProjects => _userProjects;

  Projects _previousUserProjectsBatch;

  Projects get previousUserProjectsBatch => _previousUserProjectsBatch;

  set previousUserProjectsBatch(Projects previousUserProjectsBatch) {
    _previousUserProjectsBatch = previousUserProjectsBatch;
    notifyListeners();
  }

  void onProjectDeleted(String projectId) {
    _userProjects.removeWhere((_project) => _project.id == projectId);
    notifyListeners();
  }

  Future fetchUserProjects({String userId}) async {
    try {
      if (previousUserProjectsBatch?.links?.next != null) {
        // fetch next batch of projects..
        String _nextPageLink = previousUserProjectsBatch.links.next;

        var _nextPageNumber =
            int.parse(_nextPageLink.substring(_nextPageLink.length - 1));

        // fetch projects corresponding to next page number..
        previousUserProjectsBatch = await _projectsApi.getUserProjects(
          userId ?? _localStorageService.currentUser.data.id,
          page: _nextPageNumber,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(fetchUSERPROJECTS, ViewState.Busy);
        // fetch projects for the very first time..
        previousUserProjectsBatch = await _projectsApi.getUserProjects(
            userId ?? _localStorageService.currentUser.data.id);
      }
      userProjects.addAll(previousUserProjectsBatch.data);
      setStateFor(fetchUSERPROJECTS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchUSERPROJECTS, ViewState.Error);
      setErrorMessageFor(fetchUSERPROJECTS, f.message);
    }
  }
}
