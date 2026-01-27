import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/ui/views/simulator/simulator_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';

class DeepLinkManager {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void init() {
    _checkInitialLink();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleLink(uri);
    });
  }

  Future<void> _checkInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handleLink(uri);
      }
    } catch (e) {
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  Future<void> _handleLink(Uri uri) async {
    if (uri.host != 'circuitverse.org' && uri.host != 'www.circuitverse.org') {
      return;
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    // /simulator/edit/:projectId OR /simulator/embed/:projectId
    if (pathSegments.length >= 3 && pathSegments[0] == 'simulator') {
      final mode = pathSegments[1]; // 'edit' or 'embed'
      final projectId = pathSegments[2];

      if (mode == 'edit' || mode == 'embed') {
        final dummyProject = Project.idOnly(projectId);
        final isEmbed = mode == 'embed';
        Get.toNamed(SimulatorView.id, arguments: {
          'project': dummyProject,
          'isEmbed': isEmbed,
        });
        return;
      }
    }

    // /users/:userId/projects/:projectId
    if (pathSegments.length >= 4 &&
        pathSegments[0] == 'users' &&
        pathSegments[2] == 'projects') {
      final projectId = pathSegments[3];
      _fetchAndNavigateToProject(projectId);
      return;
    }
  }

  Future<void> _fetchAndNavigateToProject(String projectId) async {

    try {
      final project = await locator<ProjectsApi>().getProjectDetails(projectId);

      if (project != null) {
        Get.offNamed(ProjectDetailsView.id, arguments: project);
      }
    } catch (e) {
      SnackBarUtils.showDark('Error', 'Could not load project details.');
    }
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final name = settings.name;
    if (name != null) {
      final uri = Uri.parse(name);
      final segments = uri.pathSegments;
      if (name.startsWith('/simulator/edit/') ||
          name.startsWith('/simulator/embed/')) {
        if (segments.length >= 3) {
          final mode = segments[1];
          final projectId = segments[2];
          final dummyProject = Project.idOnly(projectId);
          final isEmbed = mode == 'embed';

          return CVRouter.buildRoute(
            const SimulatorView(),
            settings: RouteSettings(
              name: SimulatorView.id,
              arguments: {'project': dummyProject, 'isEmbed': isEmbed},
            ),
          );
        }
      }

      // Pattern: /users/:userId/projects/:projectId
      if (segments.length >= 4 &&
          segments[0] == 'users' &&
          segments[2] == 'projects') {
        return CVRouter.buildRoute(
          const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          settings: settings,
        );
      }
    }
    return null;
  }
}
