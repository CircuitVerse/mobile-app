import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/data/restriction_elements.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_html_editor.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/groups/update_assignment_viewmodel.dart';

class UpdateAssignmentView extends StatefulWidget {
  static const String id = 'update_assignment_view';
  final Assignment assignment;

  const UpdateAssignmentView({Key key, this.assignment}) : super(key: key);

  @override
  _UpdateAssignmentViewState createState() => _UpdateAssignmentViewState();
}

class _UpdateAssignmentViewState extends State<UpdateAssignmentView> {
  final DialogService _dialogService = locator<DialogService>();
  UpdateAssignmentViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String _name;
  final GlobalKey<FlutterSummernoteState> _descriptionEditor = GlobalKey();
  DateTime _deadline;
  List _restrictions = [];
  bool _isRestrictionEnabled = false;

  @override
  void initState() {
    super.initState();
    _restrictions = json.decode(widget.assignment.attributes.restrictions);
    _isRestrictionEnabled = _restrictions.isNotEmpty;
  }

  Widget _buildNameInput() {
    return CVTextField(
      initialValue: widget.assignment.attributes.name,
      label: 'Name',
      validator: (name) => name.isEmpty ? 'Please enter a valid name' : null,
      onSaved: (name) => _name = name.trim(),
    );
  }

  Widget _buildDescriptionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: CVHtmlEditor(editorKey: _descriptionEditor),
    );
  }

  Widget _buildDeadlineInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DateTimeField(
        key: Key('cv_assignment_deadline_field'),
        format: DateFormat('yyyy-MM-dd HH:mm:ss'),
        initialValue: widget.assignment.attributes.deadline,
        decoration: CVTheme.textFieldDecoration.copyWith(
          labelText: 'Deadline',
        ),
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 5),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 5),
          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        onSaved: (deadline) => _deadline = deadline,
      ),
    );
  }

  Widget _buildRestrictionsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: CheckboxListTile(
        value: _isRestrictionEnabled,
        title: Text(
          'Elements restriction',
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text('Enable elements restriction'),
        onChanged: (value) {
          setState(() {
            _isRestrictionEnabled = value;
          });
        },
      ),
    );
  }

  Widget _buildCheckBox(String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
            value: _restrictions.contains(name),
            onChanged: (value) {
              if (value) {
                _restrictions.add((name));
              } else {
                _restrictions.remove(name);
              }
              setState(() {});
            }),
        Text(name),
      ],
    );
  }

  Widget _buildRestrictionComponent(String title, List<String> components) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Divider(),
          Wrap(children: components.map((e) => _buildCheckBox(e)).toList()),
        ],
      ),
    );
  }

  Widget _buildRestrictions() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: restrictionElements.entries
            .toList()
            .map<Widget>((e) => _buildRestrictionComponent(e.key, e.value))
            .toList(),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CVPrimaryButton(
        title: 'Update Assignment',
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());

      // Shows progress dialog..
      _dialogService.showCustomProgressDialog(title: 'Updating..');

      // [ISSUE] [html_editor] Throws error in Tests
      var _descriptionEditorText;
      try {
        _descriptionEditorText =
            await _descriptionEditor.currentState.getText();
      } on NoSuchMethodError {
        print(
            'Handled html_editor error. NOTE: This should only throw during tests.');
        _descriptionEditorText = '';
      }

      await _model.updateAssignment(
        widget.assignment.id,
        _name,
        _deadline,
        _descriptionEditorText,
        _restrictions,
      );

      _dialogService.popDialog();

      if (_model.isSuccess(_model.UPDATE_ASSIGNMENT)) {
        await Future.delayed(Duration(seconds: 1));
        Get.back(result: _model.updatedAssignment);
        SnackBarUtils.showDark(
          'Assignment Updated',
          'Assignment was updated successfully',
        );
      } else if (_model.isError(_model.UPDATE_ASSIGNMENT)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.UPDATE_ASSIGNMENT),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<UpdateAssignmentViewModel>(
      onModelReady: (model) => _model = model,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Update Assignment')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildNameInput(),
                _buildDescriptionInput(),
                _buildDeadlineInput(),
                _buildRestrictionsHeader(),
                _isRestrictionEnabled ? _buildRestrictions() : Container(),
                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
