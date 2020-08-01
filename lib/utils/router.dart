import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/authentication/forgot_password_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/favourite_projects_view.dart';
import 'package:mobile_app/ui/views/projects/my_projects_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignupView.id:
        return CupertinoPageRoute(builder: (_) => SignupView());
      case LoginView.id:
        return CupertinoPageRoute(builder: (_) => LoginView());
      case ForgotPasswordView.id:
        return CupertinoPageRoute(builder: (_) => ForgotPasswordView());
      case HomeView.id:
        return CupertinoPageRoute(builder: (_) => HomeView());
      case TeachersView.id:
        return CupertinoPageRoute(builder: (_) => TeachersView());
      case ContributorsView.id:
        return CupertinoPageRoute(builder: (_) => ContributorsView());
      case AboutView.id:
        return CupertinoPageRoute(builder: (_) => AboutView());
      case ProfileView.id:
        return CupertinoPageRoute(builder: (_) => ProfileView());
      case MyProjectsView.id:
        return CupertinoPageRoute(builder: (_) => MyProjectsView());
      case FavouriteProjectsView.id:
        return CupertinoPageRoute(builder: (_) => FavouriteProjectsView());
      case MyGroupsView.id:
        return CupertinoPageRoute(builder: (_) => MyGroupsView());
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
