import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/groups/update_assignment_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/groups/assignment_details_viewmodel.dart';
import 'package:transparent_image/transparent_image.dart';

class AssignmentDetailsView extends StatefulWidget {
  static const String id = 'assignment_details_view';
  final Assignment assignment;

  const AssignmentDetailsView({Key key, this.assignment}) : super(key: key);

  @override
  _AssignmentDetailsViewState createState() => _AssignmentDetailsViewState();
}

class _AssignmentDetailsViewState extends State<AssignmentDetailsView> {
  final DialogService _dialogService = locator<DialogService>();
  AssignmentDetailsViewModel _model;
  Assignment _recievedAssignment;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gradesController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final _gradeFocusNode = FocusNode();

  @override
  void dispose() {
    _gradeFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _recievedAssignment = widget.assignment;
  }

  Widget _buildEditAssignmentButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        primary: CVTheme.primaryColor,
      ),
      onPressed: () async {
        var _updatedAssignment = await Get.toNamed(
          UpdateAssignmentView.id,
          arguments: _recievedAssignment,
        );
        if (_updatedAssignment is Assignment) {
          setState(() {
            _recievedAssignment = _updatedAssignment;
          });
        }
      },
      child: Row(
        children: [
          Icon(Icons.edit, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Edit',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white,
                ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            _recievedAssignment.attributes.name,
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: CVTheme.textColor(context),
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        if (_recievedAssignment.attributes.hasMentorAccess) ...[
          SizedBox(width: 12),
          _buildEditAssignmentButton(),
        ]
      ],
    );
  }

  Widget _buildDetailComponent(String title, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 18),
          children: <TextSpan>[
            TextSpan(
              text: '$title : ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: description.isEmpty || description == null
                  ? 'N.A'
                  : description,
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          Html(
            data: """${_recievedAssignment.attributes.description ?? ''}""",
            style: {
              'body': Style(
                fontSize: FontSize(18),
              )
            },
          )
        ],
      ),
    );
  }

  Widget _buildSubmissionAuthors() {
    return Column(
      children: _model.projects
          .map(
            (submission) => InkWell(
              onTap: () {
                _model.focussedProject = submission;
                _gradesController.clear();
                _remarksController.clear();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _model.focussedProject == submission
                      ? CVTheme.primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: CVTheme.grey.withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    submission.attributes.authorName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: _model.focussedProject == submission
                              ? Colors.white
                              : CVTheme.textColor(context),
                        ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubmissions() {
    if (_recievedAssignment.attributes.hasMentorAccess) {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Submissions : ',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: CVTheme.primaryColorDark),
            ),
            child: _model.projects.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No Submissions yet!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  )
                : _buildSubmissionAuthors(),
          ),
          SizedBox(height: 4),
          if (_model.focussedProject != null)
            AspectRatio(
              aspectRatio: 1.6,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CVTheme.primaryColorDark),
                ),
                child: FadeInImage.memoryNetwork(
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  image:
                      '${EnvironmentConfig.CV_API_BASE_URL.substring(0, EnvironmentConfig.CV_API_BASE_URL.length - 7) + _model.focussedProject.attributes.imagePreview.url}',
                ),
              ),
            )
        ],
      );
    }

    return Container();
  }

  Future<void> addGrade() async {
    _dialogService.showCustomProgressDialog(title: 'Adding Grades');

    await _model.addGrade(
      _recievedAssignment.id,
      _gradesController.text.trim(),
      _remarksController.text.trim(),
    );

    _dialogService.popDialog();

    if (_model.isSuccess(_model.ADD_GRADE)) {
      SnackBarUtils.showDark(
        'Project Graded Successfully',
        'You have graded the project.',
      );
    } else if (_model.isError(_model.ADD_GRADE)) {
      SnackBarUtils.showDark(
        'Error',
        _model.errorMessageFor(_model.ADD_GRADE),
      );
    }
  }

  Future<void> updateGrade(String gradeId) async {
    _dialogService.showCustomProgressDialog(title: 'Updating Grade');

    await _model.updateGrade(
      gradeId,
      _gradesController.text.trim(),
      _remarksController.text.trim(),
    );

    _dialogService.popDialog();

    if (_model.isSuccess(_model.UPDATE_GRADE)) {
      SnackBarUtils.showDark(
        'Grade updated Successfully',
        'Grade has been updated successfully.',
      );
    } else if (_model.isError(_model.UPDATE_GRADE)) {
      SnackBarUtils.showDark(
        'Error',
        _model.errorMessageFor(_model.UPDATE_GRADE),
      );
    }
  }

  Future<void> deleteGrade(String gradeId) async {
    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Delete Grade',
      description: 'Are you sure you want to delete the grade?',
      confirmationTitle: 'DELETE',
    );

    if (_dialogResponse.confirmed) {
      _dialogService.showCustomProgressDialog(title: 'Deleting Grade');

      await _model.deleteGrade(gradeId);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.DELETE_GRADE)) {
        SnackBarUtils.showDark(
          'Grade Deleted',
          'Grade has been removed successfully.',
        );
        _gradesController.clear();
        _remarksController.clear();
      } else if (_model.isError(_model.DELETE_GRADE)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.DELETE_GRADE),
        );
      }
    }
  }

  Widget _buildGrades() {
    if (_model.focussedProject != null && _recievedAssignment.canBeGraded) {
      var _submittedGrade = _model.grades.firstWhere(
        (grade) =>
            grade.relationships.project.data.id == _model.focussedProject.id,
        orElse: () => null,
      );

      if (_submittedGrade != null) {
        _gradesController.text = _submittedGrade.attributes.grade;
        _remarksController.text = _submittedGrade.attributes.remarks;
      }

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: CVTheme.primaryColorDark),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Grades & Remarks',
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              CVTextField(
                label: 'Grade',
                controller: _gradesController,
                padding: const EdgeInsets.all(0),
                type: _recievedAssignment.attributes.gradingScale == 'percent'
                    ? TextInputType.number
                    : TextInputType.text,
                validator: (value) =>
                    value.isEmpty ? "Grade can't be empty" : null,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_gradeFocusNode),
              ),
              SizedBox(height: 4),
              CVTextField(
                label: 'Remarks',
                focusNode: _gradeFocusNode,
                controller: _remarksController,
                padding: const EdgeInsets.all(0),
              ),
              SizedBox(height: 16),
              Row(
                children: <Widget>[
                  CVPrimaryButton(
                    title: _submittedGrade != null ? 'Update' : 'Submit',
                    onPressed: () {
                      if (Validators.validateAndSaveForm(_formKey)) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_submittedGrade != null) {
                          updateGrade(_submittedGrade.id);
                        } else {
                          addGrade();
                        }
                      }
                    },
                  ),
                  SizedBox(width: 16),
                  if (_submittedGrade != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        primary: CVTheme.red,
                      ),
                      onPressed: () => deleteGrade(_submittedGrade.id),
                      child: Text(
                        'Delete',
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    )
                ],
              ),
              SizedBox(height: 16),
              Text(_recievedAssignment.gradingScaleHint),
            ],
          ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AssignmentDetailsViewModel>(
      onModelReady: (model) {
        _model = model;
        if (_recievedAssignment.attributes.hasMentorAccess) {
          _model.fetchAssignmentDetails(_recievedAssignment.id);
        }
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Assignment Details')),
        body: Builder(builder: (context) {
          var _attrs = _recievedAssignment.attributes;
          var _remainingTime = _attrs.deadline.difference(DateTime.now());

          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _buildHeader(),
              SizedBox(height: 16),
              _buildDetailComponent('Name', _attrs.name),
              _buildDetailComponent(
                'Deadline',
                DateFormat.yMEd().add_jms().format(_attrs.deadline),
              ),
              if (!_remainingTime.isNegative)
                _buildDetailComponent(
                  'Time Remaining',
                  '${_remainingTime.inDays} days ${_remainingTime.inHours.remainder(24)} hours ${_remainingTime.inMinutes.remainder(60)} minutes',
                ),
              _buildAssignmentDescription(),
              _buildDetailComponent(
                'Restricted Elements',
                json.decode(_attrs.restrictions).join(' , '),
              ),
              Divider(height: 32),
              if (_model.isSuccess(_model.FETCH_ASSIGNMENT_DETAILS))
                Column(
                  children: <Widget>[
                    _buildSubmissions(),
                    SizedBox(height: 16),
                    _buildGrades(),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }
}
