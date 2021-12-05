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
  String fetchProjectDetailsKey = 'fetch_project_details';
  String forkProjectKey = 'fork_project';
  String toggleStarKey = 'toggle_star';
  String deleteProjectKey = 'delete_project';
  String addCollaboratorsKey = 'add_collaborators';
  String deleteCollaboartorsKey = 'delete_collaborators';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();
  final CollaboratorsApi _collaboratorsApi = locator<CollaboratorsApi>();

  Project _project;

  Project get project => _project;

  set project(Project project) {
    _project = project;
    notifyListeners();
  }

  List<Collaborator> _collaborators = [];

  List<Collaborator> get collaborators => _collaborators;

  set collaborators(List<Collaborator> collaborators) {
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

  Project _forkedProject;

  Project get forkedProject => _forkedProject;

  set forkedProject(Project forkedProject) {
    _forkedProject = forkedProject;
    notifyListeners();
  }

  String _addedCollaboratorsSuccessMessage;

  String get addedCollaboratorsSuccessMessage =>
      _addedCollaboratorsSuccessMessage;

  set addedCollaboratorsSuccessMessage(
      String addedCollaboratorsSuccessMessage) {
    _addedCollaboratorsSuccessMessage = addedCollaboratorsSuccessMessage;
    notifyListeners();
  }

  Future fetchProjectDetails(String projectId) async {
    setStateFor(fetchProjectDetailsKey, ViewState.Busy);
    try {
      project = await _projectsApi.getProjectDetails(projectId);
      collaborators = _project.collaborators;

      setStateFor(fetchProjectDetailsKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchProjectDetailsKey, ViewState.Error);
      setErrorMessageFor(fetchProjectDetailsKey, f.message);
    }
  }

  Future addCollaborators(String projectId, String emails) async {
    setStateFor(addCollaboratorsKey, ViewState.Busy);
    try {
      var addedCollaborators =
          await _collaboratorsApi.addCollaborators(projectId, emails);

      var _addedMembers = addedCollaborators.added.join(', ');
      var _existingMembers = addedCollaborators.existing.join(', ');
      var _invalidMembers = addedCollaborators.invalid.join(', ');

      addedCollaboratorsSuccessMessage = (_addedMembers.isNotEmpty
              ? '$_addedMembers was/were added '
              : '') +
          (_existingMembers.isNotEmpty
              ? '$_existingMembers is/are existing '
              : '') +
          (_invalidMembers.isNotEmpty ? '$_invalidMembers is/are invalid' : '');

      // Fetch & Update all collaborators..
      var _collaborators =
          await _collaboratorsApi.fetchProjectCollaborators(projectId);
      collaborators = _collaborators.data;

      setStateFor(addCollaboratorsKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(addCollaboratorsKey, ViewState.Error);
      setErrorMessageFor(addCollaboratorsKey, f.message);
    }
  }

  Future deleteCollaborator(String projectId, String collaboratorId) async {
    setStateFor(deleteCollaboartorsKey, ViewState.Busy);
    try {
      var _isDeleted =
          await _collaboratorsApi.deleteCollaborator(projectId, collaboratorId);

      // Remove Collaborator from the list..
      collaborators
          .removeWhere((collaborator) => collaborator.id == collaboratorId);
      notifyListeners();

      if (_isDeleted) {
        setStateFor(deleteCollaboartorsKey, ViewState.Success);
      } else {
        setStateFor(deleteCollaboartorsKey, ViewState.Error);
        setErrorMessageFor(
            deleteCollaboartorsKey, 'Collaborator can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteCollaboartorsKey, ViewState.Error);
      setErrorMessageFor(deleteCollaboartorsKey, f.message);
    }
  }

  Future<void> forkProject(String toBeForkedProjectId) async {
    setStateFor(forkProjectKey, ViewState.Busy);
    try {
      forkedProject = await _projectsApi.forkProject(toBeForkedProjectId);

      setStateFor(forkProjectKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(forkProjectKey, ViewState.Error);
      setErrorMessageFor(forkProjectKey, f.message);
    }
  }

  Future toggleStarForProject(String projectId) async {
    setStateFor(toggleStarKey, ViewState.Busy);
    try {
      var _toggleMessage = await _projectsApi.toggleStarProject(projectId);
      isProjectStarred = _toggleMessage.contains('Starred') ? true : false;
      isProjectStarred ? starCount++ : starCount--;

      setStateFor(toggleStarKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(toggleStarKey, ViewState.Error);
      setErrorMessageFor(toggleStarKey, f.message);
    }
  }

  Future deleteProject(String projectId) async {
    setStateFor(deleteProjectKey, ViewState.Busy);
    try {
      var _isDeleted = await _projectsApi.deleteProject(projectId);

      if (_isDeleted) {
        setStateFor(deleteProjectKey, ViewState.Success);
      } else {
        setStateFor(deleteProjectKey, ViewState.Error);
        setErrorMessageFor(deleteProjectKey, 'Project cannot be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteProjectKey, ViewState.Error);
      setErrorMessageFor(deleteProjectKey, f.message);
    }
  }
}
