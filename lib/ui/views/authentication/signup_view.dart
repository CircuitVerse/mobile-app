import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/ui/components/cv_password_field.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/components/auth_options_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/authentication/signup_viewmodel.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  static const String id = 'signup_view';

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  late SignupViewModel _signUpModel;
  final _formKey = GlobalKey<FormState>();
  late String _name, _email, _password;

  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _buildSignUpImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:
          MediaQuery.of(context).size.height > 800
              ? MediaQuery.of(context).size.height * 0.52
              : MediaQuery.of(context).size.height * 0.43,
      color: CVTheme.imageBackground,
      padding: const EdgeInsetsDirectional.all(16),
      child: SafeArea(
        child: Image.asset('assets/images/signup/cv_signup.png', height: 300),
      ),
    );
  }

  Widget _buildNameInput() {
    return CVTextField(
      label: AppLocalizations.of(context)!.signup_name,
      validator:
          (value) =>
              value?.isEmpty ?? true
                  ? AppLocalizations.of(context)!.signup_name_validation_error
                  : null,
      onSaved: (value) => _name = value!.trim(),
      onFieldSubmitted:
          (_) => FocusScope.of(context).requestFocus(_nameFocusNode),
    );
  }

  Widget _buildEmailInput() {
    return CVTextField(
      focusNode: _nameFocusNode,
      label: AppLocalizations.of(context)!.signup_email,
      type: TextInputType.emailAddress,
      validator:
          (value) =>
              Validators.isEmailValid(value)
                  ? null
                  : AppLocalizations.of(context)!.signup_email_validation_error,
      onSaved: (value) => _email = value!.trim(),
      onFieldSubmitted: (_) {
        _nameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
    );
  }

  Widget _buildPasswordInput() {
    return CVPasswordField(
      focusNode: _emailFocusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return AppLocalizations.of(context)!.signup_password_validation_error;
        } else if (value.length < 6) {
          return AppLocalizations.of(context)!.signup_password_length_error;
        }
        return null;
      },
      onSaved: (value) => _password = value!.trim(),
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      width: double.infinity,
      child: CVPrimaryButton(
        title:
            _signUpModel.isBusy(_signUpModel.SIGNUP)
                ? AppLocalizations.of(context)!.signup_authenticating
                : AppLocalizations.of(context)!.signup_register.toUpperCase(),
        onPressed: _validateAndSubmit,
      ),
    );
  }

  Widget _buildAlreadyRegisteredComponent() {
    return GestureDetector(
      onTap: () => Get.offAllNamed(LoginView.id),
      child: RichText(
        text: TextSpan(
          text: '${AppLocalizations.of(context)!.signup_already_registered} ',
          style: Theme.of(context).textTheme.bodyLarge,
          children: <TextSpan>[
            TextSpan(
              text: AppLocalizations.of(context)!.signup_login,
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
        !_signUpModel.isBusy(_signUpModel.SIGNUP)) {
      FocusScope.of(context).requestFocus(FocusNode());

      await _signUpModel.signup(_name, _email, _password);

      if (_signUpModel.isSuccess(_signUpModel.SIGNUP)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.signup_success_title,
          AppLocalizations.of(context)!.signup_success_message,
        );

        await Future.delayed(const Duration(seconds: 1));
        await Get.offAllNamed(CVLandingView.id);
      } else if (_signUpModel.isError(_signUpModel.SIGNUP)) {
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.signup_error,
          _signUpModel.errorMessageFor(_signUpModel.SIGNUP),
        );
        _formKey.currentState?.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SignupViewModel>(
      onModelReady: (model) => _signUpModel = model,
      builder:
          (context, model, child) => Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildSignUpImage(),
                    const SizedBox(height: 8),
                    _buildNameInput(),
                    _buildEmailInput(),
                    _buildPasswordInput(),
                    const SizedBox(height: 14),
                    _buildRegisterButton(),
                    const SizedBox(height: 8),
                    _buildAlreadyRegisteredComponent(),
                    const SizedBox(height: 20),
                    const AuthOptionsView(isSignUp: true),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
