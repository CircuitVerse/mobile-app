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
import 'package:mobile_app/gen_l10n/app_localizations.dart'; // Added import

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  static const String id = 'forgot_password_view';

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late ForgotPasswordViewModel _model;
  final _formKey = GlobalKey<FormState>();
  late String _email;

  Widget _buildForgotPasswordImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: CVTheme.imageBackground,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Image.asset('assets/images/login/cv_login.png', height: 300),
      ),
    );
  }

  Widget _buildEmailInput() {
    return CVTextField(
      label: AppLocalizations.of(context)!.forgot_password_email,
      type: TextInputType.emailAddress,
      validator:
          (value) =>
              Validators.isEmailValid(value)
                  ? null
                  : AppLocalizations.of(
                    context,
                  )!.forgot_password_email_validation_error,
      onSaved: (value) => _email = value!.trim(),
      action: TextInputAction.done,
    );
  }

  Widget _buildSendInstructionsButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title:
            _model.isBusy(_model.SEND_RESET_INSTRUCTIONS)
                ? AppLocalizations.of(context)!.forgot_password_sending
                : AppLocalizations.of(
                  context,
                )!.forgot_password_send_instructions,
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildNewUserSignUpComponent() {
    return GestureDetector(
      onTap: () => Get.offNamed(SignupView.id),
      child: RichText(
        text: TextSpan(
          text: '${AppLocalizations.of(context)!.forgot_password_new_user} ',
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: AppLocalizations.of(context)!.forgot_password_sign_up,
              style: const TextStyle(color: CVTheme.primaryColorDark),
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
        title:
            AppLocalizations.of(context)!.forgot_password_sending_instructions,
      );

      await _model.onForgotPassword(_email);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.SEND_RESET_INSTRUCTIONS)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.forgot_password_instructions_sent_title,
          AppLocalizations.of(
            context,
          )!.forgot_password_instructions_sent_message,
        );
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
      } else if (_model.isError(_model.SEND_RESET_INSTRUCTIONS)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.forgot_password_error,
          _model.errorMessageFor(_model.SEND_RESET_INSTRUCTIONS),
        );
        _formKey.currentState?.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      onModelReady: (model) => _model = model,
      builder:
          (context, model, child) => Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildForgotPasswordImage(),
                    const SizedBox(height: 8),
                    _buildEmailInput(),
                    const SizedBox(height: 8),
                    _buildSendInstructionsButton(),
                    const SizedBox(height: 8),
                    _buildNewUserSignUpComponent(),
                    const SizedBox(height: 32),
                    const AuthOptionsView(isSignUp: false),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
