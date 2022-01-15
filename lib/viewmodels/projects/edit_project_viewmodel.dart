import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class EditProjectViewModel extends BaseModel {
  // ViewState Keys
  String updatePROJECT = 'update_project';

  final ProjectsApi _projectsApi = locator<ProjectsApi>();

  Project _updatedProject;

  Project get updatedProject => _updatedProject;

  set updatedProject(Project updatedProject) {
    _updatedProject = updatedProject;
    notifyListeners();
  }

  Future updateProject(
    String id, {
    String name,
    String projectAccessType,
    String description,
    List<String> tagsList,
  }) async {
    setStateFor(updatePROJECT, ViewState.Busy);
    try {
      updatedProject = await _projectsApi.updateProject(
        id,
        name: name,
        projectAccessType: projectAccessType,
        description: description,
        tagsList: tagsList,
      );

      setStateFor(updatePROJECT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(updatePROJECT, ViewState.Error);
      setErrorMessageFor(updatePROJECT, f.message);
    }
  }
}
