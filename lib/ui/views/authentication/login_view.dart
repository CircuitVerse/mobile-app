import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_password_field.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/components/authentication_options_view.dart';
import 'package:mobile_app/ui/views/authentication/forgot_password_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/authentication/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  static const String id = 'login_view';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _loginModel;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  Widget _buildLoginImage() {
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

  Widget _buildPasswordInput() {
    return CVPasswordField(
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value.trim(),
    );
  }

  Widget _buildForgotPasswordComponent() {
    return GestureDetector(
      onTap: () => Get.toNamed(ForgotPasswordView.id),
      child: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: AppTheme.primaryColorDark),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: (_loginModel.state == ViewState.Busy)
          ? CVPrimaryButton(
              title: 'Authenticating..',
              isPrimaryDark: true,
            )
          : CVOutlineButton(
              title: 'LOGIN',
              isPrimaryDark: true,
              onPressed: _validateAndSubmit,
            ),
    );
  }

  Widget _buildNewUserSignUpComponent() {
    return GestureDetector(
      onTap: () => Get.toNamed(SignupView.id),
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
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());
      _loginModel.login(_email, _password).then((_) {
        if (!_loginModel.isLoginSuccessful) _formKey.currentState.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) => _loginModel = model,
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildLoginImage(),
                SizedBox(height: 8),
                _buildEmailInput(),
                _buildPasswordInput(),
                _buildForgotPasswordComponent(),
                SizedBox(height: 16),
                _buildLoginButton(),
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
