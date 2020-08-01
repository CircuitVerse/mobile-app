import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/authentication/authentication_options_viewmodel.dart';

class AuthenticationOptionsView extends StatelessWidget {
  final bool isSignUpView;

  const AuthenticationOptionsView({Key key, this.isSignUpView = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthenticationOptionsViewModel>(
      builder: (context, model, child) => Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Row(children: <Widget>[
              Expanded(child: Divider(thickness: 1)),
              Text('  Or ${isSignUpView ? 'SignUp' : 'Login'} with  '),
              Expanded(child: Divider(thickness: 1)),
            ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => model.googleAuth(isSignUp: isSignUpView),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child:
                      Image.asset('assets/icons/google_icon.png', height: 40),
                ),
              ),
              GestureDetector(
                onTap: () => model.facebookAuth(isSignUp: isSignUpView),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child:
                      Image.asset('assets/icons/facebook_icon.png', height: 40),
                ),
              ),
              GestureDetector(
                onTap: () => model.githubAuth(isSignUp: isSignUpView),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Icon(FontAwesome.github, size: 40),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
