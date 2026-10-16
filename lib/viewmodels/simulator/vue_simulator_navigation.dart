/// Where a navigation inside the bundled simulator should go.
///
/// The Vue app assumes it runs on circuitverse.org, so it navigates to absolute
/// paths the asset server cannot serve.
sealed class VueNavigation {
  const VueNavigation();
}

/// Served by the bundle; let the webview load it.
class LoadInWebView extends VueNavigation {
  const LoadInWebView();
}

/// Cancel the navigation and stay put.
class StayOnCurrentPage extends VueNavigation {
  const StayOnCurrentPage();
}

/// Reopen a saved project in the simulator.
class OpenProject extends VueNavigation {
  const OpenProject(this.projectId);

  final String projectId;
}

/// Open a screen the app already has.
class OpenAppScreen extends VueNavigation {
  const OpenAppScreen(this.screen, [this.argument]);

  final VueAppScreen screen;
  final String? argument;
}

enum VueAppScreen { profile, groups, login, project }

/// Leave the simulator and go back to the app.
class ReturnToApp extends VueNavigation {
  const ReturnToApp();
}

/// Project ids are numeric. Anything else is never handed to the page.
bool _isId(String segment) => RegExp(r'^\d+$').hasMatch(segment);

/// Classifies a navigation. [isLocal] is true for our own asset server.
VueNavigation resolveVueNavigation(Uri uri, {required bool isLocal}) {
  // Never hand the user off to a browser.
  if (!isLocal) return const StayOnCurrentPage();

  final path = uri.path;
  if (path.isEmpty ||
      path == '/' ||
      path == '/index.html' ||
      path.startsWith('/api/')) {
    return const LoadInWebView();
  }

  final segments = uri.pathSegments;

  // /simulatorvue/edit/<id> after a save, /simulator/edit/<id> on cancel.
  if (segments.length == 3 &&
      (segments[0] == 'simulator' || segments[0] == 'simulatorvue') &&
      segments[1] == 'edit' &&
      _isId(segments[2])) {
    return OpenProject(segments[2]);
  }

  if (segments.length >= 2 && segments[0] == 'users') {
    if (segments.length == 2) {
      return segments[1] == 'sign_in' || segments[1] == 'sign_up'
          ? const OpenAppScreen(VueAppScreen.login)
          : OpenAppScreen(VueAppScreen.profile, segments[1]);
    }
    if (segments[2] == 'groups') {
      return const OpenAppScreen(VueAppScreen.groups);
    }
    // Where the simulator lands after saving or updating project details.
    if (segments.length >= 4 &&
        segments[2] == 'projects' &&
        _isId(segments[3])) {
      return OpenAppScreen(VueAppScreen.project, segments[3]);
    }
  }

  return const ReturnToApp();
}
