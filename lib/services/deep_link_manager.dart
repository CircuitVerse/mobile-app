import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/ui/views/simulator/simulator_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';

class DeepLinkManager {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void init() {
    // Check initial link
    _checkInitialLink();

    // Listen to link changes
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
      // Ignore errors handling initial link
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }

  // Handle incoming links
  Future<void> _handleLink(Uri uri) async {
    // Basic validation for host
    if (uri.host != 'circuitverse.org' && uri.host != 'www.circuitverse.org') {
      return;
    }

    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;

    // Pattern: /simulator/edit/:projectId OR /simulator/embed/:projectId
    if (pathSegments.length >= 3 && pathSegments[0] == 'simulator') {
      final mode = pathSegments[1]; // 'edit' or 'embed'
      final projectId = pathSegments[2];

      if (mode == 'edit' || mode == 'embed') {
        final dummyProject = Project.idOnly(projectId);
        final isEmbed = mode == 'embed';

        // Navigate to SimulatorView with the project and isEmbed flag
        // We pass the flag via arguments map or just handling it in View
        // Since we are using Get.toNamed, let's pass it in arguments if possible, 
        // but SimulatorView expects `Project?` as arguments.
        // We will modify SimulatorView to check for this extra data or handle it differently.
        // For now, let's assume we update SimulatorView to handle a Map or a custom helper.
        // Or simpler: We pass the Project, and we can't easily pass the bool unless we change arguments type.
        // Let's pass a Map that contains 'project' and 'isEmbed'.
        
        Get.toNamed(SimulatorView.id, arguments: {
          'project': dummyProject,
          'isEmbed': isEmbed,
        });
        return;
      }
    }

    // Pattern: /users/:userId/projects/:projectId
    if (pathSegments.length >= 4 &&
        pathSegments[0] == 'users' &&
        pathSegments[2] == 'projects') {
      final projectId = pathSegments[3];
      _fetchAndNavigateToProject(projectId);
      return;
    }
  }

  Future<void> _fetchAndNavigateToProject(String projectId) async {
    // We need to wait a bit if the app is just starting up to ensure GetX context is ready
    // or use a slight delay.
    // However, since this might be called after init, it should be fine.
    
    final dialogService = locator<DialogService>();
    dialogService.showCustomProgressDialog(title: 'Loading Project...');

    try {
      final project = await locator<ProjectsApi>().getProjectDetails(projectId);
      dialogService.popDialog();

      if (project != null) {
        Get.toNamed(ProjectDetailsView.id, arguments: project);
      }
    } catch (e) {
      dialogService.popDialog();
      SnackBarUtils.showDark('Error', 'Could not load project details.');
    }
  }
}
