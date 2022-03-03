import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/collaborators_api.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ProjectDetailsViewModel extends BaseModel {
  // ViewState Keys
  String FETCH_PROJECT_DETAILS = 'fetch_project_details';
  String FORK_PROJECT = 'fork_project';
  String TOGGLE_STAR = 'toggle_star';
  String DELETE_PROJECT = 'delete_project';
  String ADD_COLLABORATORS = 'add_collaborators';
  String DELETE_COLLABORATORS = 'delete_collaborators';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();
  final CollaboratorsApi _collaboratorsApi = locator<CollaboratorsApi>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  bool get isLoggedIn => _localStorageService.isLoggedIn;

  Project? receivedProject;

  Project? _project;

  Project? get project => _project;

  set project(Project? project) {
    _project = project;
    notifyListeners();
  }

  List<Collaborator> _collaborators = [];

  List<Collaborator> get collaborators => _collaborators;

  set collaborators(List<Collaborator>? collaborators) {
    if (collaborators == null) return;
    _collaborators = collaborators;
    notifyListeners();
  }

  bool _isProjectStarred = false;

  bool get isProjectStarred => _isProjectStarred;

  set isProjectStarred(bool isProjectStarred) {
    _isProjectStarred = isProjectStarred;
    notifyListeners();
  }

  int _starCount = 0;

  int get starCount => _starCount;

  set starCount(int starCount) {
    _starCount = starCount;
    notifyListeners();
  }

  Project? _forkedProject;

  Project? get forkedProject => _forkedProject;

  set forkedProject(Project? forkedProject) {
    _forkedProject = forkedProject;
    notifyListeners();
  }

  late String _addedCollaboratorsSuccessMessage;

  String get addedCollaboratorsSuccessMessage =>
      _addedCollaboratorsSuccessMessage;

  set addedCollaboratorsSuccessMessage(
      String addedCollaboratorsSuccessMessage) {
    _addedCollaboratorsSuccessMessage = addedCollaboratorsSuccessMessage;
    notifyListeners();
  }

  Future? fetchProjectDetails(String projectId) async {
    setStateFor(FETCH_PROJECT_DETAILS, ViewState.Busy);
    try {
      project = await _projectsApi.getProjectDetails(projectId);
      collaborators = _project?.collaborators;

      setStateFor(FETCH_PROJECT_DETAILS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_PROJECT_DETAILS, ViewState.Error);
      setErrorMessageFor(FETCH_PROJECT_DETAILS, f.message);
    }
  }

  Future addCollaborators(String projectId, String emails) async {
    setStateFor(ADD_COLLABORATORS, ViewState.Busy);
    try {
      var addedCollaborators =
          await _collaboratorsApi.addCollaborators(projectId, emails);

      var _addedMembers = addedCollaborators?.added.join(', ');
      var _existingMembers = addedCollaborators?.existing.join(', ');
      var _invalidMembers = addedCollaborators?.invalid.join(', ');

      addedCollaboratorsSuccessMessage = (_addedMembers?.isNotEmpty ?? false
              ? '$_addedMembers was/were added '
              : '') +
          (_existingMembers?.isNotEmpty ?? false
              ? '$_existingMembers is/are existing '
              : '') +
          (_invalidMembers?.isNotEmpty ?? false
              ? '$_invalidMembers is/are invalid'
              : '');

      // Fetch & Update all collaborators..
      var _collaborators =
          await _collaboratorsApi.fetchProjectCollaborators(projectId);
      collaborators = _collaborators?.data;

      setStateFor(ADD_COLLABORATORS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(ADD_COLLABORATORS, ViewState.Error);
      setErrorMessageFor(ADD_COLLABORATORS, f.message);
    }
  }

  Future deleteCollaborator(String projectId, String collaboratorId) async {
    setStateFor(DELETE_COLLABORATORS, ViewState.Busy);
    try {
      var _isDeleted =
          await _collaboratorsApi.deleteCollaborator(projectId, collaboratorId);

      // Remove Collaborator from the list..
      collaborators
          .removeWhere((collaborator) => collaborator.id == collaboratorId);
      notifyListeners();

      if (_isDeleted ?? false) {
        setStateFor(DELETE_COLLABORATORS, ViewState.Success);
      } else {
        setStateFor(DELETE_COLLABORATORS, ViewState.Error);
        setErrorMessageFor(
            DELETE_COLLABORATORS, 'Collaborator can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(DELETE_COLLABORATORS, ViewState.Error);
      setErrorMessageFor(DELETE_COLLABORATORS, f.message);
    }
  }

  Future<void> forkProject(String toBeForkedProjectId) async {
    setStateFor(FORK_PROJECT, ViewState.Busy);
    try {
      forkedProject = await _projectsApi.forkProject(toBeForkedProjectId);

      setStateFor(FORK_PROJECT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FORK_PROJECT, ViewState.Error);
      setErrorMessageFor(FORK_PROJECT, f.message);
    }
  }

  Future toggleStarForProject(String projectId) async {
    setStateFor(TOGGLE_STAR, ViewState.Busy);
    try {
      var _toggleMessage = await _projectsApi.toggleStarProject(projectId);
      isProjectStarred = _toggleMessage!.contains('Starred') ? true : false;
      isProjectStarred ? starCount++ : starCount--;

      receivedProject = receivedProject!.copyWith(
        attributes: receivedProject!.attributes.copyWith(
          isStarred: isProjectStarred,
          starsCount: starCount,
        ),
      );

      setStateFor(TOGGLE_STAR, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(TOGGLE_STAR, ViewState.Error);
      setErrorMessageFor(TOGGLE_STAR, f.message);
    }
  }

  Future deleteProject(String projectId) async {
    setStateFor(DELETE_PROJECT, ViewState.Busy);
    try {
      var _isDeleted = await _projectsApi.deleteProject(projectId);

      if (_isDeleted ?? false) {
        setStateFor(DELETE_PROJECT, ViewState.Success);
      } else {
        setStateFor(DELETE_PROJECT, ViewState.Error);
        setErrorMessageFor(DELETE_PROJECT, 'Project cannot be deleted');
      }
    } on Failure catch (f) {
      setStateFor(DELETE_PROJECT, ViewState.Error);
      setErrorMessageFor(DELETE_PROJECT, f.message);
    }
  }
}
