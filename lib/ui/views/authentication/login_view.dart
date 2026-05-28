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
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const String id = 'login_view';
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginViewModel _model;
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildLoginImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height > 800
              ? MediaQuery.of(context).size.height * 0.56
              : MediaQuery.of(context).size.height * 0.475,
      color: CVTheme.imageBackground,
      padding: const EdgeInsetsDirectional.all(16),
      child: SafeArea(
        child: Image.asset('assets/images/login/cv_login.png', height: 300),
      ),
    );
  }

  Widget _buildEmailInput() {
    return CVTextField(
      label: AppLocalizations.of(context)!.login_email,
      type: TextInputType.emailAddress,
      validator:
          (value) =>
              Validators.isEmailValid(value)
                  ? null
                  : AppLocalizations.of(context)!.login_email_validation_error,
      onSaved: (value) => _email = value!.trim(),
      onFieldSubmitted:
          (_) => FocusScope.of(context).requestFocus(_emailFocusNode),
    );
  }

  Widget _buildPasswordInput() {
    return CVPasswordField(
      focusNode: _emailFocusNode,
      validator:
          (value) =>
              value?.isEmpty ?? true
                  ? AppLocalizations.of(
                    context,
                  )!.login_password_validation_error
                  : null,
      onSaved: (value) => _password = value!.trim(),
    );
  }

  Widget _buildForgotPasswordComponent() {
    return GestureDetector(
      onTap: () => Get.toNamed(ForgotPasswordView.id),
      child: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        child: Text(
          AppLocalizations.of(context)!.login_forgot_password,
          style: TextStyle(color: CVTheme.highlightText(context)),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title:
            _model.isBusy(_model.LOGIN)
                ? AppLocalizations.of(context)!.login_authenticating
                : AppLocalizations.of(context)!.login_button.toUpperCase(),
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildNewUserSignUpComponent() {
    return GestureDetector(
      onTap: () => Get.toNamed(SignupView.id),
      child: RichText(
        text: TextSpan(
          text: '${AppLocalizations.of(context)!.login_new_user} ',
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: AppLocalizations.of(context)!.login_sign_up,
              style: TextStyle(
                color: CVTheme.highlightText(context),
                fontSize: 16,
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
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.login_success_title,
          AppLocalizations.of(context)!.login_success_message,
        );
        await Future.delayed(const Duration(seconds: 1));
        await Get.offAllNamed(CVLandingView.id);
      } else if (_model.isError(_model.LOGIN)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.login_error,
          _model.errorMessageFor(_model.LOGIN),
        );
        _formKey.currentState?.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      onModelReady: (model) => _model = model,
      builder:
          (context, model, child) => Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildLoginImage(),
                    const SizedBox(height: 8),
                    _buildEmailInput(),
                    _buildPasswordInput(),
                    _buildForgotPasswordComponent(),
                    const SizedBox(height: 16),
                    _buildLoginButton(),
                    const SizedBox(height: 8),
                    _buildNewUserSignUpComponent(),
                    const SizedBox(height: 30),
                    const AuthOptionsView(isSignUp: false),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
