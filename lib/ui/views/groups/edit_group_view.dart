import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/groups/edit_group_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditGroupView extends StatefulWidget {
  static const String id = 'edit_group_view';
  final Group group;

  const EditGroupView({Key key, this.group}) : super(key: key);

  @override
  _EditGroupViewState createState() => _EditGroupViewState();
}

class _EditGroupViewState extends State<EditGroupView> {
  final DialogService _dialogService = locator<DialogService>();
  EditGroupViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String _name;

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _dialogService.showCustomProgressDialog(title: AppLocalizations.of(context).updating);

      await _model.updateGroup(widget.group.id, _name);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.UPDATE_GROUP)) {
        await Future.delayed(Duration(seconds: 1));
        Get.back(result: _model.updatedGroup);
        SnackBarUtils.showDark(
          AppLocalizations.of(context).group_updated,
          AppLocalizations.of(context).group_updated_acknowledgement,
        );
      } else if (_model.isError(_model.UPDATE_GROUP)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.UPDATE_GROUP),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditGroupViewModel>(
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
                  title: AppLocalizations.of(context).edit_group,
                  subtitle:
                      AppLocalizations.of(context).edit_group_description,
                ),
                SizedBox(height: 16),
                SvgPicture.asset(
                  'assets/images/group/edit_group.svg',
                  height: 200,
                ),
                SizedBox(height: 16),
                CVTextField(
                  padding: const EdgeInsets.all(0),
                  label: AppLocalizations.of(context).group_name,
                  initialValue: widget.group.attributes.name,
                  validator: (value) =>
                      value.isEmpty ? AppLocalizations.of(context).enter_group_name : null,
                  onSaved: (value) => _name = value.trim(),
                  action: TextInputAction.done,
                ),
                SizedBox(height: 16),
                CVPrimaryButton(
                  title: AppLocalizations.of(context).save,
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
