import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/views/authentication/forgot_password_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/groups/add_assignment_view.dart';
import 'package:mobile_app/ui/views/groups/assignment_details_view.dart';
import 'package:mobile_app/ui/views/groups/edit_group_view.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/groups/new_group_view.dart';
import 'package:mobile_app/ui/views/groups/update_assignment_view.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/ui/views/profile/edit_profile_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/edit_project_view.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
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
      case CVLandingView.id:
        return CupertinoPageRoute(builder: (_) => CVLandingView());
      case TeachersView.id:
        return CupertinoPageRoute(builder: (_) => TeachersView());
      case ContributorsView.id:
        return CupertinoPageRoute(builder: (_) => ContributorsView());
      case ProfileView.id:
        var _userId = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => ProfileView(
            userId: _userId,
          ),
        );
      case EditProfileView.id:
        return CupertinoPageRoute(builder: (_) => EditProfileView());
      case ProjectDetailsView.id:
        var _project = settings.arguments as Project;
        return CupertinoPageRoute(
          builder: (_) => ProjectDetailsView(
            project: _project,
          ),
        );
      case EditProjectView.id:
        var _project = settings.arguments as Project;
        return CupertinoPageRoute(
          builder: (_) => EditProjectView(
            project: _project,
          ),
        );
      case MyGroupsView.id:
        return CupertinoPageRoute(builder: (_) => MyGroupsView());
      case GroupDetailsView.id:
        var group = settings.arguments as Group;
        return CupertinoPageRoute(
          builder: (_) => GroupDetailsView(
            group: group,
          ),
        );
      case NewGroupView.id:
        return CupertinoPageRoute(builder: (_) => NewGroupView());
      case EditGroupView.id:
        var group = settings.arguments as Group;
        return CupertinoPageRoute(
          builder: (_) => EditGroupView(
            group: group,
          ),
        );
      case AssignmentDetailsView.id:
        var _assignment = settings.arguments as Assignment;
        return CupertinoPageRoute(
          builder: (_) => AssignmentDetailsView(
            assignment: _assignment,
          ),
        );
      case AddAssignmentView.id:
        var _groupId = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => AddAssignmentView(
            groupId: _groupId,
          ),
        );
      case UpdateAssignmentView.id:
        var _assignment = settings.arguments as Assignment;
        return CupertinoPageRoute(
          builder: (_) => UpdateAssignmentView(
            assignment: _assignment,
          ),
        );
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
