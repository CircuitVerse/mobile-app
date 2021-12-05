import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/grade.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/services/API/grades_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class AssignmentDetailsViewModel extends BaseModel {
  // ViewState Keys
  String fetchAssignmentDetailsKey = 'fetch_assignment_details';
  String addGradeKey = 'add_grade';
  String updateGradeKey = 'update_grade';
  String deleteGradeKey = 'delete_grade';

  final AssignmentsApi _assignmentsApi = locator<AssignmentsApi>();
  final GradesApi _gradesApi = locator<GradesApi>();

  Assignment _assignment;

  Assignment get assignment => _assignment;

  set assignment(Assignment assignment) {
    _assignment = assignment;
    notifyListeners();
  }

  List<Project> _projects = [];

  List<Project> get projects => _projects;

  set projects(List<Project> projects) {
    _projects = projects;
    notifyListeners();
  }

  List<Grade> _grades = [];

  List<Grade> get grades => _grades;

  set grades(List<Grade> grades) {
    _grades = grades;
    notifyListeners();
  }

  Project _focussedProject;

  Project get focussedProject => _focussedProject;

  set focussedProject(Project focussedProject) {
    _focussedProject = focussedProject;
    notifyListeners();
  }

  Future fetchAssignmentDetails(String assignmentId) async {
    setStateFor(fetchAssignmentDetailsKey, ViewState.Busy);
    try {
      assignment = await _assignmentsApi.fetchAssignmentDetails(assignmentId);
      projects = _assignment.projects ?? [];
      grades = _assignment.grades ?? [];

      setStateFor(fetchAssignmentDetailsKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(fetchAssignmentDetailsKey, ViewState.Error);
      setErrorMessageFor(fetchAssignmentDetailsKey, f.message);
    }
  }

  Future addGrade(String assignmentId, dynamic grade, String remarks) async {
    setStateFor(addGradeKey, ViewState.Busy);
    try {
      var _addedGrade = await _gradesApi.addGrade(
          assignmentId, _focussedProject.id, grade, remarks);

      _grades.add(_addedGrade);
      notifyListeners();

      setStateFor(addGradeKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(addGradeKey, ViewState.Error);
      setErrorMessageFor(addGradeKey, f.message);
    }
  }

  Future updateGrade(String gradeId, dynamic grade, String remarks) async {
    setStateFor(updateGradeKey, ViewState.Busy);
    try {
      var _updatedGrade = await _gradesApi.updateGrade(gradeId, grade, remarks);

      _grades.removeWhere((grade) => grade.id == gradeId);
      _grades.add(_updatedGrade);
      notifyListeners();

      setStateFor(updateGradeKey, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(updateGradeKey, ViewState.Error);
      setErrorMessageFor(updateGradeKey, f.message);
    }
  }

  Future deleteGrade(String gradeId) async {
    setStateFor(deleteGradeKey, ViewState.Busy);

    try {
      var _isDeleted = await _gradesApi.deleteGrade(gradeId);

      if (_isDeleted) {
        // Remove Grade from the list..
        _grades.removeWhere((grade) => grade.id == gradeId);
        setStateFor(deleteGradeKey, ViewState.Success);
      } else {
        setStateFor(deleteGradeKey, ViewState.Error);
        setErrorMessageFor(deleteGradeKey, 'Grade can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(deleteGradeKey, ViewState.Error);
      setErrorMessageFor(deleteGradeKey, f.message);
    }
  }
}
