import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/ui/components/cv_password_field.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/components/auth_options_view.dart';
import 'package:mobile_app/ui/views/authentication/forgot_password_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/authentication/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  static const String id = 'login_view';

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel _model;
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildLoginImage() {
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
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_emailFocusNode),
    );
  }

  Widget _buildPasswordInput() {
    return CVPasswordField(
      focusNode: _emailFocusNode,
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
          style: TextStyle(
            color: CVTheme.highlightText(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title: _model.isBusy(_model.LOGIN) ? 'Authenticating..' : 'LOGIN',
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
                color: CVTheme.highlightText(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey) &&
        !_model.isBusy(_model.LOGIN)) {
      FocusScope.of(context).requestFocus(FocusNode());

      await _model.login(_email, _password);

      if (_model.isSuccess(_model.LOGIN)) {
        // show login successful snackbar..
        SnackBarUtils.showDark(
          'Login Successful',
          'Welcome back!',
        );

        // move to home view on successful login..
        await Future.delayed(Duration(seconds: 1));
        await Get.offAllNamed(CVLandingView.id);
      } else if (_model.isError(_model.LOGIN)) {
        // show failure snackbar..
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.LOGIN),
        );
        _formKey.currentState.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) => _model = model,
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
                SizedBox(height: 8),
                _buildNewUserSignUpComponent(),
                SizedBox(height: 32),
                AuthOptionsView(isSignUp: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
