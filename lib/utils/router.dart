import 'package:flutter/material.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/views/about/about_privacy_policy_view.dart';
import 'package:mobile_app/ui/views/about/about_tos_view.dart';
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
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/ui/views/profile/edit_profile_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/edit_project_view.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/ui/views/projects/project_preview_fullscreen_view.dart';
import 'package:mobile_app/ui/views/simulator/simulator_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';

class CVRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignupView.id:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case LoginView.id:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case ForgotPasswordView.id:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case CVLandingView.id:
        return MaterialPageRoute(builder: (_) => const CVLandingView());
      case SimulatorView.id:
        return MaterialPageRoute(builder: (_) => const SimulatorView());
      case TeachersView.id:
        return MaterialPageRoute(builder: (_) => const TeachersView());
      case ContributorsView.id:
        return MaterialPageRoute(builder: (_) => const ContributorsView());
      case AboutTosView.id:
        return MaterialPageRoute(builder: (_) => const AboutTosView());
      case AboutPrivacyPolicyView.id:
        return MaterialPageRoute(
          builder: (_) => const AboutPrivacyPolicyView(),
        );
      case FeaturedProjectsView.id:
        return MaterialPageRoute(builder: (_) => const FeaturedProjectsView());
      case ProfileView.id:
        var _userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ProfileView(
            userId: _userId,
          ),
        );
      case EditProfileView.id:
        return MaterialPageRoute(builder: (_) => const EditProfileView());
      case ProjectDetailsView.id:
        var _project = settings.arguments as Project;
        return MaterialPageRoute(
          builder: (_) => ProjectDetailsView(
            project: _project,
          ),
        );
      case EditProjectView.id:
        var _project = settings.arguments as Project;
        return MaterialPageRoute(
          builder: (_) => EditProjectView(
            project: _project,
          ),
        );
      case MyGroupsView.id:
        return MaterialPageRoute(builder: (_) => const MyGroupsView());
      case GroupDetailsView.id:
        var group = settings.arguments as Group;
        return MaterialPageRoute(
          builder: (_) => GroupDetailsView(
            group: group,
          ),
        );
      case NewGroupView.id:
        return MaterialPageRoute(builder: (_) => const NewGroupView());
      case EditGroupView.id:
        var group = settings.arguments as Group;
        return MaterialPageRoute(
          builder: (_) => EditGroupView(
            group: group,
          ),
        );
      case AssignmentDetailsView.id:
        var _assignment = settings.arguments as Assignment;
        return MaterialPageRoute(
          builder: (_) => AssignmentDetailsView(
            assignment: _assignment,
          ),
        );
      case AddAssignmentView.id:
        var _groupId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AddAssignmentView(
            groupId: _groupId,
          ),
        );
      case UpdateAssignmentView.id:
        var _assignment = settings.arguments as Assignment;
        return MaterialPageRoute(
          builder: (_) => UpdateAssignmentView(
            assignment: _assignment,
          ),
        );
      case IbLandingView.id:
        return MaterialPageRoute(
          builder: (_) => const IbLandingView(),
        );
      case ProjectPreviewFullScreen.id:
        var _project = settings.arguments as Project;
        return MaterialPageRoute(
          builder: (_) => ProjectPreviewFullScreen(
            project: _project,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
