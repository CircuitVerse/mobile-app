import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class UserFavouritesViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_USER_FAVOURITES = 'fetch_user_favourites';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  final List<Project> _userFavourites = [];

  List<Project> get userFavourites => _userFavourites;

  Projects? _previousUserFavouritesBatch;

  Projects? get previousUserFavouritesBatch => _previousUserFavouritesBatch;

  set previousUserFavouritesBatch(Projects? previousUserFavouritesBatch) {
    _previousUserFavouritesBatch = previousUserFavouritesBatch;
    notifyListeners();
  }

  void _removeFromUserFavorites(String projectId) {
    _userFavourites.removeWhere((_project) => _project.id == projectId);
    notifyListeners();
  }

  void onProjectDeleted(String projectId) {
    _removeFromUserFavorites(projectId);
  }

  void _addToUserFavorites(Project project) {
    _userFavourites.add(project);
    notifyListeners();
  }

  void onProjectChanged(Project project) {
    if (project.attributes.isStarred) {
      _addToUserFavorites(project);
    } else {
      _removeFromUserFavorites(project.id);
    }
  }

  Future? fetchUserFavourites({String? userId}) async {
    try {
      if (previousUserFavouritesBatch?.links.next != null) {
        // fetch next batch of projects..
        String _nextPageLink = previousUserFavouritesBatch!.links.next;

        var _nextPageNumber =
            int.parse(_nextPageLink.substring(_nextPageLink.length - 1));

        // fetch projects corresponding to next page number..
        previousUserFavouritesBatch = await _projectsApi.getUserFavourites(
          userId ?? _localStorageService.currentUser!.data.id,
          page: _nextPageNumber,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(FETCH_USER_FAVOURITES, ViewState.Busy);
        // fetch projects for the very first time..
        previousUserFavouritesBatch = await _projectsApi.getUserFavourites(
            userId ?? _localStorageService.currentUser!.data.id);
      }

      userFavourites.addAll(previousUserFavouritesBatch!.data);

      setStateFor(FETCH_USER_FAVOURITES, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_USER_FAVOURITES, ViewState.Error);
      setErrorMessageFor(FETCH_USER_FAVOURITES, f.message);
    }
  }
}
