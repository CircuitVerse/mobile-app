import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/groups/new_group_viewmodel.dart';

class NewGroupView extends StatefulWidget {
  static const String id = 'new_group_view';

  @override
  _NewGroupViewState createState() => _NewGroupViewState();
}

class _NewGroupViewState extends State<NewGroupView> {
  final DialogService _dialogService = locator<DialogService>();
  NewGroupViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String _name;

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _dialogService.showCustomProgressDialog(title: 'Creating..');

      await _model.addGroup(_name);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.ADD_GROUP)) {
        await Future.delayed(Duration(seconds: 1));
        Get.back(result: _model.newGroup);
        SnackBarUtils.showDark(
          'Group Created',
          'New group was created successfuly.',
        );
      } else if (_model.isError(_model.ADD_GROUP)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.ADD_GROUP),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NewGroupViewModel>(
      onModelReady: (model) => _model = model,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CVSubheader(
                  title: 'NEW GROUP',
                  subtitle:
                      'Groups an be used by mentors to set projects for and give grades to students.',
                ),
                SizedBox(height: 16),
                SvgPicture.asset(
                  'assets/images/group/new_group.svg',
                  height: 200,
                ),
                SizedBox(height: 16),
                CVTextField(
                  padding: const EdgeInsets.all(0),
                  label: 'Group Name',
                  validator: (value) =>
                      value.isEmpty ? 'Please enter a Group Name' : null,
                  onSaved: (value) => _name = value.trim(),
                  action: TextInputAction.done,
                ),
                SizedBox(height: 16),
                CVPrimaryButton(
                  title: 'SAVE',
                  onPressed: _validateAndSubmit,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
