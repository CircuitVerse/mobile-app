import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class FeaturedProjectsViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_FEATURED_PROJECTS = 'fetch_featured_projects';
  String SEARCH_PROJECTS = 'fetch_searched_projects';

  String query = '';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();

  final List<Project> _featuredProjects = [], _searchedProjects = [];

  List<Project> get projects =>
      _showSearchedResult ? _searchedProjects : _featuredProjects;

  Projects? _previousSearchedProjectsBatch;

  Projects? get previousSearchedProjectsBatch => _previousSearchedProjectsBatch;

  Projects? _previousFeaturedProjectsBatch;

  Projects? get previousFeaturedProjectsBatch => _previousFeaturedProjectsBatch;

  set previousFeaturedProjectsBatch(Projects? project) {
    _previousFeaturedProjectsBatch = project;
    notifyListeners();
  }

  Projects? get previousProjectsBatch => _showSearchedResult
      ? _previousSearchedProjectsBatch
      : _previousFeaturedProjectsBatch;

  bool _showSearchBar = false;

  bool get showSearchBar => _showSearchBar;

  bool _showSearchedResult = false;

  bool get showSearchedResult => _showSearchedResult;

  set showSearchBar(bool val) {
    _showSearchBar = val;
    notifyListeners();
  }

  void clear() {
    query = '';
    _previousSearchedProjectsBatch = null;
  }

  void reset() {
    clear();
    _showSearchBar = false;
    _showSearchedResult = false;
    notifyListeners();
  }

  void loadMore() {
    if (_showSearchBar) {
      searchProjects(query, load: true);
    } else {
      fetchFeaturedProjects();
    }
  }

  void updateFeaturedProject(Project project) {
    final int index = _featuredProjects.indexWhere(
      (element) => element.id == project.id,
    );
    _featuredProjects[index] = project;
    notifyListeners();
  }

  int _getNextPageNumber(String link) {
    String pageNumber = '';

    for (int idx = link.length - 1; idx >= 0; idx--) {
      if (link[idx] == '=') break;

      pageNumber = link[idx] + pageNumber;
    }

    return int.parse(pageNumber);
  }

  Future searchProjects(String query, {int size = 5, bool load = false}) async {
    try {
      setStateFor(SEARCH_PROJECTS, ViewState.Busy);
      if (!load) _searchedProjects.clear();
      if (previousSearchedProjectsBatch?.links.next != null) {
        // fetch next batch of projects..
        String _nextPageLink = previousSearchedProjectsBatch?.links.next;

        var _nextPageNumber = _getNextPageNumber(_nextPageLink);

        // fetch projects corresponding to next page number..
        _previousSearchedProjectsBatch = await _projectsApi
            .searchProjects(query, page: _nextPageNumber, size: size);
      } else {
        // fetch projects for the very first time..
        _previousSearchedProjectsBatch =
            await _projectsApi.searchProjects(query, size: size);
      }
      _searchedProjects.addAll(previousSearchedProjectsBatch!.data);
      _showSearchedResult = true;
      setStateFor(SEARCH_PROJECTS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(SEARCH_PROJECTS, ViewState.Error);
      setErrorMessageFor(SEARCH_PROJECTS, f.message);
    }
  }

  Future? fetchFeaturedProjects({int size = 5}) async {
    try {
      if (previousFeaturedProjectsBatch?.links.next != null) {
        // fetch next batch of projects..
        String _nextPageLink = previousFeaturedProjectsBatch?.links.next;

        var _nextPageNumber = _getNextPageNumber(_nextPageLink);

        // fetch projects corresponding to next page number..
        _previousFeaturedProjectsBatch = await _projectsApi.getFeaturedProjects(
          page: _nextPageNumber,
          size: size,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(FETCH_FEATURED_PROJECTS, ViewState.Busy);
        // fetch projects for the very first time..
        _previousFeaturedProjectsBatch = await _projectsApi.getFeaturedProjects(
          size: size,
        );
      }
      _featuredProjects.addAll(previousFeaturedProjectsBatch!.data);
      setStateFor(FETCH_FEATURED_PROJECTS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_FEATURED_PROJECTS, ViewState.Error);
      setErrorMessageFor(FETCH_FEATURED_PROJECTS, f.message);
    }
  }
}
