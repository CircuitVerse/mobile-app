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
  String FETCH_ASSIGNMENT_DETAILS = 'fetch_assignment_details';
  String ADD_GRADE = 'add_grade';
  String UPDATE_GRADE = 'update_grade';
  String DELETE_GRADE = 'delete_grade';

  final AssignmentsApi _assignmentsApi = locator<AssignmentsApi>();
  final GradesApi _gradesApi = locator<GradesApi>();

  Assignment? _assignment;

  Assignment? get assignment => _assignment;

  set assignment(Assignment? assignment) {
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

  Project? _focussedProject;

  Project? get focussedProject => _focussedProject;

  set focussedProject(Project? focussedProject) {
    _focussedProject = focussedProject;
    notifyListeners();
  }

  Future? fetchAssignmentDetails(String? assignmentId) async {
    if (assignmentId == null) return;
    setStateFor(FETCH_ASSIGNMENT_DETAILS, ViewState.Busy);
    try {
      assignment = await _assignmentsApi.fetchAssignmentDetails(assignmentId);
      projects = _assignment?.projects ?? [];
      grades = _assignment?.grades ?? [];

      setStateFor(FETCH_ASSIGNMENT_DETAILS, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(FETCH_ASSIGNMENT_DETAILS, ViewState.Error);
      setErrorMessageFor(FETCH_ASSIGNMENT_DETAILS, f.message);
    }
  }

  Future addGrade(String assignmentId, dynamic grade, String remarks) async {
    setStateFor(ADD_GRADE, ViewState.Busy);
    try {
      var _addedGrade = await _gradesApi.addGrade(
        assignmentId,
        _focussedProject!.id,
        grade,
        remarks,
      );

      if (_addedGrade != null) _grades.add(_addedGrade);
      notifyListeners();

      setStateFor(ADD_GRADE, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(ADD_GRADE, ViewState.Error);
      setErrorMessageFor(ADD_GRADE, f.message);
    }
  }

  Future updateGrade(String gradeId, dynamic grade, String remarks) async {
    setStateFor(UPDATE_GRADE, ViewState.Busy);
    try {
      var _updatedGrade = await _gradesApi.updateGrade(gradeId, grade, remarks);

      _grades.removeWhere((grade) => grade.id == gradeId);
      _grades.add(_updatedGrade!);
      notifyListeners();

      setStateFor(UPDATE_GRADE, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(UPDATE_GRADE, ViewState.Error);
      setErrorMessageFor(UPDATE_GRADE, f.message);
    }
  }

  Future deleteGrade(String gradeId) async {
    setStateFor(DELETE_GRADE, ViewState.Busy);

    try {
      var _isDeleted = await _gradesApi.deleteGrade(gradeId)!;

      if (_isDeleted) {
        // Remove Grade from the list..
        _grades.removeWhere((grade) => grade.id == gradeId);
        setStateFor(DELETE_GRADE, ViewState.Success);
      } else {
        setStateFor(DELETE_GRADE, ViewState.Error);
        setErrorMessageFor(DELETE_GRADE, 'Grade can\'t be deleted');
      }
    } on Failure catch (f) {
      setStateFor(DELETE_GRADE, ViewState.Error);
      setErrorMessageFor(DELETE_GRADE, f.message);
    }
  }
}
