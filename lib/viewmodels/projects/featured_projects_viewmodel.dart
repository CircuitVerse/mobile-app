import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class FeaturedProjectsViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_FEATURED_PROJECTS = 'fetch_featured_projects';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();

  final List<Project> _featuredProjects = [];

  List<Project> get featuredProjects => _featuredProjects;

  Projects _previousFeaturedProjectsBatch;

  Projects get previousFeaturedProjectsBatch => _previousFeaturedProjectsBatch;

  set previousFeaturedProjectsBatch(Projects previousFeaturedProjectsBatch) {
    _previousFeaturedProjectsBatch = previousFeaturedProjectsBatch;
    notifyListeners();
  }

  Future fetchFeaturedProjects({int size = 5}) async {
    try {
      if (previousFeaturedProjectsBatch?.links?.next != null) {
        // fetch next batch of projects..
        String _nextPageLink = previousFeaturedProjectsBatch.links.next;

        var _nextPageNumber =
            int.parse(_nextPageLink.substring(_nextPageLink.length - 1));

        // fetch projects corresponding to next page number..
        previousFeaturedProjectsBatch = await _projectsApi.getFeaturedProjects(
          page: _nextPageNumber,
          size: size,
        );
      } else {
        // Set State as busy only very first time..
        setStateFor(FETCH_FEATURED_PROJECTS, ViewState.Busy);
        // fetch projects for the very first time..
        previousFeaturedProjectsBatch = await _projectsApi.getFeaturedProjects(
          size: size,
        );
      }
      featuredProjects.addAll(previousFeaturedProjectsBatch.data);
      setStateFor(FETCH_FEATURED_PROJECTS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_FEATURED_PROJECTS, ViewState.Error);
      setErrorMessageFor(FETCH_FEATURED_PROJECTS, f.message);
    }
  }
}
