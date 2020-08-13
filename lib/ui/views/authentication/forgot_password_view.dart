import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/components/authentication_options_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/authentication/forgot_password_viewmodel.dart';

class ForgotPasswordView extends StatefulWidget {
  static const String id = 'forgot_password_view';

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  ForgotPasswordViewModel _forgotPasswordModel;
  final _formKey = GlobalKey<FormState>();
  String _email;

  Widget _buildForgotPasswordImage() {
    return Container(
      color: AppTheme.imageBackground,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Image.asset(
          'assets/images/login/cv_login.png',
          height: MediaQuery.of(context).size.height / 2.8,
          width: double.infinity,
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
    );
  }

  Widget _buildSendInstructionsButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title: _forgotPasswordModel.state == ViewState.Busy
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
                color: AppTheme.primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (Validators.validateAndSaveForm(_formKey) &&
        _forgotPasswordModel.state != ViewState.Busy) {
      FocusScope.of(context).requestFocus(FocusNode());
      _forgotPasswordModel.onForgotPassword(_email).then((_) {
        if (!_forgotPasswordModel.isResetPasswordInstructionsSent) {
          _formKey.currentState.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordViewModel>(
      onModelReady: (model) => _forgotPasswordModel = model,
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
                AuthenticationOptionsView(
                  isSignUpView: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
