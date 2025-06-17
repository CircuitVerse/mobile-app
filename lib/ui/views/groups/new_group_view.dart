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
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class NewGroupView extends StatefulWidget {
  const NewGroupView({super.key});

  static const String id = 'new_group_view';

  @override
  _NewGroupViewState createState() => _NewGroupViewState();
}

class _NewGroupViewState extends State<NewGroupView> {
  final DialogService _dialogService = locator<DialogService>();
  late NewGroupViewModel _model;
  final _formKey = GlobalKey<FormState>();
  late String _name;

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.creating,
      );

      await _model.addGroup(_name);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.ADD_GROUP)) {
        await Future.delayed(const Duration(seconds: 1));
        Get.back(result: _model.newGroup);
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.group_created,
          AppLocalizations.of(context)!.group_created_success,
        );
      } else if (_model.isError(_model.ADD_GROUP)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.error,
          _model.errorMessageFor(_model.ADD_GROUP),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NewGroupViewModel>(
      onModelReady: (model) => _model = model,
      builder:
          (context, model, child) => Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CVSubheader(
                      title:
                          AppLocalizations.of(context)!.new_group.toUpperCase(),
                      subtitle: AppLocalizations.of(context)!.group_description,
                    ),
                    const SizedBox(height: 16),
                    SvgPicture.asset(
                      'assets/images/group/new_group.svg',
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    CVTextField(
                      padding: const EdgeInsets.all(0),
                      label: AppLocalizations.of(context)!.group_name,
                      validator:
                          (value) =>
                              value?.isEmpty ?? true
                                  ? AppLocalizations.of(
                                    context,
                                  )!.group_name_validation_error
                                  : null,
                      onSaved: (value) => _name = value!.trim(),
                      action: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                    CVPrimaryButton(
                      title: AppLocalizations.of(context)!.save.toUpperCase(),
                      onPressed: _validateAndSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
