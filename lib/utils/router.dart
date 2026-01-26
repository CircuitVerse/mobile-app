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
import 'package:mobile_app/services/deep_link_manager.dart';
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
    final deepLinkRoute = DeepLinkManager.generateRoute(settings);
    if (deepLinkRoute != null) {
      return deepLinkRoute;
    }

    switch (settings.name) {
      case SignupView.id:
        return buildRoute(const SignupView());
      case LoginView.id:
        return buildRoute(const LoginView());
      case ForgotPasswordView.id:
        return buildRoute(const ForgotPasswordView());
      case CVLandingView.id:
        return buildRoute(const CVLandingView());
      case SimulatorView.id:
        final args = settings.arguments;
        return buildRoute(
          const SimulatorView(),
          settings: RouteSettings(name: SimulatorView.id, arguments: args),
        );
      case TeachersView.id:
        return buildRoute(const TeachersView());
      case ContributorsView.id:
        return buildRoute(const ContributorsView());
      case AboutTosView.id:
        return buildRoute(const AboutTosView());
      case AboutPrivacyPolicyView.id:
        return buildRoute(const AboutPrivacyPolicyView());
      case FeaturedProjectsView.id:
        return buildRoute(const FeaturedProjectsView());
      case ProfileView.id:
        var _userId = settings.arguments as String;
        return buildRoute(ProfileView(userId: _userId));
      case EditProfileView.id:
        return buildRoute(const EditProfileView());
      case ProjectDetailsView.id:
        var _project = settings.arguments as Project;
        return buildRoute(ProjectDetailsView(project: _project));
      case EditProjectView.id:
        var _project = settings.arguments as Project;
        return buildRoute(EditProjectView(project: _project));
      case MyGroupsView.id:
        return buildRoute(const MyGroupsView());
      case GroupDetailsView.id:
        var group = settings.arguments as Group;
        return buildRoute(GroupDetailsView(group: group));
      case NewGroupView.id:
        return buildRoute(const NewGroupView());
      case EditGroupView.id:
        var group = settings.arguments as Group;
        return buildRoute(EditGroupView(group: group));
      case AssignmentDetailsView.id:
        var _assignment = settings.arguments as Assignment;
        return buildRoute(AssignmentDetailsView(assignment: _assignment));
      case AddAssignmentView.id:
        var _groupId = settings.arguments as String;
        return buildRoute(AddAssignmentView(groupId: _groupId));
      case UpdateAssignmentView.id:
        var _assignment = settings.arguments as Assignment;
        return buildRoute(UpdateAssignmentView(assignment: _assignment));
      case IbLandingView.id:
        return buildRoute(const IbLandingView());
      case ProjectPreviewFullScreen.id:
        var _project = settings.arguments as Project;
        return buildRoute(ProjectPreviewFullScreen(project: _project));
      default:
        return buildRoute(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  /// Premium fade + scale transition for optimal user experience
  static PageRouteBuilder buildRoute(Widget page, {RouteSettings? settings}) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Combine fade and subtle scale for a premium, minimal feel
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
        );

        final scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutQuart),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
    );
  }
}
