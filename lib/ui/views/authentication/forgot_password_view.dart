import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/components/auth_options_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/authentication/forgot_password_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends StatefulWidget {
  static const String id = 'forgot_password_view';
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  ForgotPasswordViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String _email;

  Widget _buildForgotPasswordImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: CVTheme.imageBackground,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Image.asset(
          'assets/images/login/cv_login.png',
          height: 300,
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return CVTextField(
      label: AppLocalizations.of(context).email,
      type: TextInputType.emailAddress,
      validator: (value) => Validators.isEmailValid(value)
          ? null
          : AppLocalizations.of(context).enter_valid_email,
      onSaved: (value) => _email = value.trim(),
      action: TextInputAction.done,
    );
  }

  Widget _buildSendInstructionsButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title: _model.isBusy(_model.SEND_RESET_INSTRUCTIONS)
            ? AppLocalizations.of(context).sending_status
            : AppLocalizations.of(context).send_instructions_btn,
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildNewUserSignUpComponent() {
    return GestureDetector(
      onTap: () => Get.offNamed(SignupView.id),
      child: RichText(
        text: TextSpan(
          text: AppLocalizations.of(context).if_new_user,
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: AppLocalizations.of(context).signup,
              style: TextStyle(
                color: CVTheme.primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    var _dialogService = locator<DialogService>();

    if (Validators.validateAndSaveForm(_formKey) &&
        !_model.isBusy(_model.SEND_RESET_INSTRUCTIONS)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _dialogService.showCustomProgressDialog(
          title: AppLocalizations.of(context).sending_instructions_status);

      await _model.onForgotPassword(_email);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.SEND_RESET_INSTRUCTIONS)) {
        // show instructions sent snackbar
        SnackBarUtils.showDark(
          AppLocalizations.of(context).instructions_sent_confirmation(_email),
          AppLocalizations.of(context).instructions_sent_acknowledgement,
        );

        // route back to previous screen
        await Future.delayed(Duration(seconds: 1));
        Get.back();
      } else if (_model.isError(_model.SEND_RESET_INSTRUCTIONS)) {
        // show failure snackbar
        SnackBarUtils.showDark(
          AppLocalizations.of(context).error,
          _model.errorMessageFor(_model.SEND_RESET_INSTRUCTIONS),
        );
        _formKey.currentState.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      onModelReady: (model) => _model = model,
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildForgotPasswordImage(),
                SizedBox(height: 8),
                _buildEmailInput(),
                SizedBox(height: 8),
                _buildSendInstructionsButton(),
                SizedBox(height: 8),
                _buildNewUserSignUpComponent(),
                SizedBox(height: 32),
                AuthOptionsView(
                  isSignUp: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
