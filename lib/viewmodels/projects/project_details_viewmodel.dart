import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/collaborators_api.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ProjectDetailsViewModel extends BaseModel {
  // ViewState Keys
  String fetchPROJECTDETAILS = 'fetch_project_details';
  String forkPROJECT = 'fork_project';
  String toggleSTAR = 'toggle_star';
  String deletePROJECT = 'delete_project';
  String addCOLLABORATORS = 'add_collaborators';
  String deleteCOLLABORATORS = 'delete_collaborators';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();
  final CollaboratorsApi _collaboratorsApi = locator<CollaboratorsApi>();

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
    setStateFor(fetchPROJECTDETAILS, ViewState.Busy);
    try {
      project = await _projectsApi.getProjectDetails(projectId);
      collaborators = _project?.collaborators;

      setStateFor(fetchPROJECTDETAILS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchPROJECTDETAILS, ViewState.Error);
      setErrorMessageFor(fetchPROJECTDETAILS, f.message);
    }
  }

  Future addCollaborators(String projectId, String emails) async {
    setStateFor(addCOLLABORATORS, ViewState.Busy);
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

      setStateFor(addCOLLABORATORS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(addCOLLABORATORS, ViewState.Error);
      setErrorMessageFor(addCOLLABORATORS, f.message);
    }
  }

  Future deleteCollaborator(String projectId, String collaboratorId) async {
    setStateFor(deleteCOLLABORATORS, ViewState.Busy);
    try {
      var _isDeleted =
          await _collaboratorsApi.deleteCollaborator(projectId, collaboratorId);

      // Remove Collaborator from the list..
      collaborators
          .removeWhere((collaborator) => collaborator.id == collaboratorId);
      notifyListeners();

      if (_isDeleted ?? false) {
        setStateFor(deleteCOLLABORATORS, ViewState.Success);
      } else {
        setStateFor(deleteCOLLABORATORS, ViewState.Error);
        setErrorMessageFor(
            deleteCOLLABORATORS, 'Collaborator can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteCOLLABORATORS, ViewState.Error);
      setErrorMessageFor(deleteCOLLABORATORS, f.message);
    }
  }

  Future<void> forkProject(String toBeForkedProjectId) async {
    setStateFor(forkPROJECT, ViewState.Busy);
    try {
      forkedProject = await _projectsApi.forkProject(toBeForkedProjectId);

      setStateFor(forkPROJECT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(forkPROJECT, ViewState.Error);
      setErrorMessageFor(forkPROJECT, f.message);
    }
  }

  Future toggleStarForProject(String projectId) async {
    setStateFor(toggleSTAR, ViewState.Busy);
    try {
      var _toggleMessage = await _projectsApi.toggleStarProject(projectId);
      isProjectStarred = _toggleMessage!.contains('Starred') ? true : false;
      isProjectStarred ? starCount++ : starCount--;

      setStateFor(toggleSTAR, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(toggleSTAR, ViewState.Error);
      setErrorMessageFor(toggleSTAR, f.message);
    }
  }

  Future deleteProject(String projectId) async {
    setStateFor(deletePROJECT, ViewState.Busy);
    try {
      var _isDeleted = await _projectsApi.deleteProject(projectId);

      if (_isDeleted ?? false) {
        setStateFor(deletePROJECT, ViewState.Success);
      } else {
        setStateFor(deletePROJECT, ViewState.Error);
        setErrorMessageFor(deletePROJECT, 'Project cannot be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deletePROJECT, ViewState.Error);
      setErrorMessageFor(deletePROJECT, f.message);
    }
  }
}
