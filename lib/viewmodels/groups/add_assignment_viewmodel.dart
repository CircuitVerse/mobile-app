import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class AddAssignmentViewModel extends BaseModel {
  // ViewState Keys
  final String ADD_ASSIGNMENT = 'add_assignment';

  final AssignmentsApi _assignmentsApi = locator<AssignmentsApi>();

  late Assignment _addedAssignment;

  Assignment get addedAssignment => _addedAssignment;

  set addedAssignment(Assignment? addedAssignment) {
    if (addedAssignment == null) return;
    _addedAssignment = addedAssignment;
    notifyListeners();
  }

  Future? addAssignment(
    String groupId,
    String name,
    DateTime deadline,
    String gradingScale,
    String description,
    List restrictionsList,
  ) async {
    setStateFor(ADD_ASSIGNMENT, ViewState.Busy);
    try {
      // deadline format..
      var deadlineFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

      // format grading_scale
      gradingScale = gradingScale.toLowerCase().split(' ').join('_');

      // Adds Assignment..
      addedAssignment = await _assignmentsApi.addAssignment(
        groupId,
        name,
        deadlineFormat.format(deadline.subtract(deadline.timeZoneOffset)),
        description,
        gradingScale,
        jsonEncode(restrictionsList),
      );

      setStateFor(ADD_ASSIGNMENT, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(ADD_ASSIGNMENT, ViewState.Error);
      setErrorMessageFor(ADD_ASSIGNMENT, f.message);
    }
  }
}
