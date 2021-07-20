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
      label: 'Email',
      type: TextInputType.emailAddress,
      validator: (value) =>
          Validators.isEmailValid(value) ? null : 'Please enter a valid email',
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
            ? 'Sending..'
            : 'SEND INSTRUCTIONS',
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildNewUserSignUpComponent() {
    return GestureDetector(
      onTap: () => Get.offNamed(SignupView.id),
      child: RichText(
        text: TextSpan(
          text: 'New User? ',
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: 'Sign Up',
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

      _dialogService.showCustomProgressDialog(title: 'Sending Instructions');

      await _model.onForgotPassword(_email);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.SEND_RESET_INSTRUCTIONS)) {
        // show instructions sent snackbar
        SnackBarUtils.showDark(
          'Instructions Sent to $_email',
          'Please check your mail for password reset link.',
        );

        // route back to previous screen
        await Future.delayed(Duration(seconds: 1));
        Get.back();
      } else if (_model.isError(_model.SEND_RESET_INSTRUCTIONS)) {
        // show failure snackbar
        SnackBarUtils.showDark(
          'Error',
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
