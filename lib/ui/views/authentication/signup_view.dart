import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/ui/components/cv_password_field.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/components/authentication_options_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/authentication/signup_viewmodel.dart';

class SignupView extends StatefulWidget {
  static const String id = 'signup_view';

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  SignupViewModel _signUpModel;
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;

  Widget _buildSignUpImage() {
    return Container(
      color: AppTheme.imageBackground,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Image.asset(
          'assets/images/signup/cv_signup.png',
          height: 300,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return CVTextField(
      label: 'Name',
      validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
      onSaved: (value) => _name = value.trim(),
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

  Widget _buildRegisterButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title: _signUpModel.state == ViewState.Busy
            ? 'Authenticating..'
            : 'REGISTER',
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildAlreadyRegisteredComponent() {
    return GestureDetector(
      onTap: () => Get.offAllNamed(LoginView.id),
      child: RichText(
        text: TextSpan(
          text: 'Already Registered? ',
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: AppTheme.primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey) && !_signUpModel.isBusy) {
      FocusScope.of(context).requestFocus(FocusNode());

      await _signUpModel.signup(_name, _email, _password);

      if (_signUpModel.isSuccess) {
        // show signup successful snackbar..
        SnackBarUtils.showDark('Signup Successful');

        // move to home view on successful signup..
        await Future.delayed(Duration(seconds: 1));
        await Get.offAllNamed(HomeView.id);
      } else if (_signUpModel.isError) {
        // show failure snackbar..
        SnackBarUtils.showDark(_signUpModel.errorMessage);
        _formKey.currentState.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SignupViewModel>(
      onModelReady: (model) => _signUpModel = model,
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildSignUpImage(),
                SizedBox(height: 8),
                _buildNameInput(),
                _buildEmailInput(),
                _buildPasswordInput(),
                SizedBox(height: 16),
                _buildRegisterButton(),
                SizedBox(height: 8),
                _buildAlreadyRegisteredComponent(),
                SizedBox(height: 32),
                AuthenticationOptionsView(
                  isSignUpView: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
