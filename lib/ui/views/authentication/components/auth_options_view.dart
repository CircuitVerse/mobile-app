import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/authentication/auth_options_viewmodel.dart';

class AuthOptionsView extends StatefulWidget {
  const AuthOptionsView({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  _AuthOptionsViewState createState() => _AuthOptionsViewState();
}

class _AuthOptionsViewState extends State<AuthOptionsView> {
  late AuthOptionsViewModel _model;

  Future<void> onGoogleAuthPressed() async {
    await _model.googleAuth(isSignUp: widget.isSignUp);

    if (_model.isSuccess(_model.GOOGLE_OAUTH)) {
      await Get.offAllNamed(CVLandingView.id);
    } else if (_model.isError(_model.GOOGLE_OAUTH)) {
      SnackBarUtils.showDark(
        'Google Authentication Error',
        _model.errorMessageFor(_model.GOOGLE_OAUTH),
      );
    }
  }

  Future<void> onFacebookAuthPressed() async {
    await _model.facebookAuth(isSignUp: widget.isSignUp);

    if (_model.isSuccess(_model.FB_OAUTH)) {
      await Get.offAllNamed(CVLandingView.id);
    } else if (_model.isError(_model.FB_OAUTH)) {
      SnackBarUtils.showDark(
        'Facebook Authentication Error',
        _model.errorMessageFor(_model.FB_OAUTH),
      );
    }
  }

  Future<void> onGithubAuthPressed() async {
    await _model.githubAuth(isSignUp: widget.isSignUp);

    if (_model.isSuccess(_model.GITHUB_OAUTH)) {
      await Get.offAllNamed(CVLandingView.id);
    } else if (_model.isError(_model.GITHUB_OAUTH)) {
      SnackBarUtils.showDark(
        'GitHub Authentication Error',
        _model.errorMessageFor(_model.GITHUB_OAUTH),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthOptionsViewModel>(
      onModelReady: (model) => _model = model,
      builder:
          (context, model, child) => Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 32),
                child: Row(
                  children: <Widget>[
                    const Expanded(child: Divider(thickness: 1)),
                    Text('  Or ${widget.isSignUp ? 'SignUp' : 'Login'} with  '),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: onGoogleAuthPressed,
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(8),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'assets/icons/google_icon.png',
                        height: 40,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onFacebookAuthPressed,
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(8),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'assets/icons/facebook_icon.png',
                        height: 40,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onGithubAuthPressed,
                    child: Container(
                      padding: const EdgeInsetsDirectional.all(8),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Icon(FontAwesome5.github, size: 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
