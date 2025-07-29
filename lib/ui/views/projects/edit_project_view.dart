import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_html_editor.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/simulator/simulator_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/projects/edit_project_viewmodel.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class EditProjectView extends StatefulWidget {
  const EditProjectView({super.key, required this.project});

  static const String id = 'edit_project_view';
  final Project project;

  @override
  _EditProjectViewState createState() => _EditProjectViewState();
}

class _EditProjectViewState extends State<EditProjectView> {
  final DialogService _dialogService = locator<DialogService>();
  late EditProjectViewModel _model;
  final _formKey = GlobalKey<FormState>();
  late String _name, _projectAccessType;
  late List<String> _tags;
  final QuillController _controller = QuillController.basic();

  final _nameFocusNode = FocusNode();
  final _tagsListFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _tagsListFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _name = widget.project.attributes.name;
    _tags = widget.project.attributes.tags.map((tag) => tag.name).toList();
    _projectAccessType = widget.project.attributes.projectAccessType;
  }

  Widget _buildNameInput() {
    return CVTextField(
      label: AppLocalizations.of(context)!.edit_project_name,
      initialValue: _name,
      validator:
          (value) =>
              value?.isEmpty ?? true
                  ? AppLocalizations.of(
                    context,
                  )!.edit_project_name_validation_error
                  : null,
      onSaved: (value) => _name = value!.trim(),
      onFieldSubmitted:
          (_) => FocusScope.of(context).requestFocus(_nameFocusNode),
    );
  }

  Widget _buildTagsInput() {
    return CVTextField(
      label: AppLocalizations.of(context)!.edit_project_tags_list,
      focusNode: _nameFocusNode,
      initialValue: _tags.join(' , '),
      onSaved:
          (value) =>
              _tags = value!.split(',').map((tag) => tag.trim()).toList(),
      onFieldSubmitted: (_) {
        _nameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_tagsListFocusNode);
      },
    );
  }

  Widget _buildProjectAccessTypeInput() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: DropdownButtonFormField<String>(
        focusNode: _tagsListFocusNode,
        decoration: CVTheme.textFieldDecoration.copyWith(
          labelText: AppLocalizations.of(context)!.edit_project_access_type,
        ),
        value: _projectAccessType,
        onChanged: (String? value) {
          if (value == null) return;
          setState(() {
            _projectAccessType = value;
          });
        },
        validator:
            (category) =>
                category == null
                    ? AppLocalizations.of(
                      context,
                    )!.edit_project_access_type_validation_error
                    : null,
        items:
            [
              AppLocalizations.of(context)!.edit_project_public,
              AppLocalizations.of(context)!.edit_project_private,
              AppLocalizations.of(context)!.edit_project_limited_access,
            ].map<DropdownMenuItem<String>>((type) {
              return DropdownMenuItem<String>(value: type, child: Text(type));
            }).toList(),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: CVHtmlEditor(controller: _controller),
    );
  }

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.edit_project_updating,
      );

      await _model.updateProject(
        widget.project.id,
        name: _name,
        projectAccessType: _projectAccessType,
        description: _controller.document.toPlainText(),
        tagsList: _tags,
      );

      _dialogService.popDialog();

      if (_model.isSuccess(_model.UPDATE_PROJECT)) {
        await Future.delayed(const Duration(seconds: 1));
        Get.back(result: _model.updatedProject);
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.edit_project_updated,
          AppLocalizations.of(context)!.edit_project_update_success,
        );
      } else if (_model.isError(_model.UPDATE_PROJECT)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.edit_project_error,
          _model.errorMessageFor(_model.UPDATE_PROJECT),
        );
      }
    }
  }

  Future<void> _openInSimulator() async {
    try {
      // Navigate to simulator with the project for editing
      final result = await Get.toNamed(
        SimulatorView.id,
        arguments: widget.project,
      );

      if (result != null) {
        SnackBarUtils.showDark('Simulator', 'Returned from simulator');
      }
    } catch (e) {
      SnackBarUtils.showDark('Error', 'Failed to open project in simulator');
    }
  }

  Widget _buildUpdateProjectButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: CVPrimaryButton(
        title: AppLocalizations.of(context)!.edit_project_title,
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildOpenInSimulatorButton(BuildContext Context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: CVPrimaryButton(
        title: AppLocalizations.of(context)!.edit_open_in_simulator,
        onPressed: _openInSimulator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProjectViewModel>(
      onModelReady: (model) => _model = model,
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                '${AppLocalizations.of(context)!.edit_project_edit} ${widget.project.attributes.name}',
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildNameInput(),
                    _buildTagsInput(),
                    _buildProjectAccessTypeInput(),
                    _buildDescriptionInput(),
                    const SizedBox(height: 16),
                    _buildOpenInSimulatorButton(context),
                    const SizedBox(height: 12),
                    _buildUpdateProjectButton(),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
