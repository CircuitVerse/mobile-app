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

  @override
  bool operator ==(Object other) =>
      other is OpenProject && other.projectId == projectId;

  @override
  int get hashCode => projectId.hashCode;
}

/// Show a project on the app's own project screen.
class OpenProjectPage extends VueNavigation {
  const OpenProjectPage(this.projectId);

  final String projectId;

  @override
  bool operator ==(Object other) =>
      other is OpenProjectPage && other.projectId == projectId;

  @override
  int get hashCode => projectId.hashCode;
}

/// Open a screen the app already has.
class OpenAppScreen extends VueNavigation {
  const OpenAppScreen(this.screen, {this.argument});

  final VueAppScreen screen;
  final String? argument;

  @override
  bool operator ==(Object other) =>
      other is OpenAppScreen &&
      other.screen == screen &&
      other.argument == argument;

  @override
  int get hashCode => Object.hash(screen, argument);
}

enum VueAppScreen { profile, groups, login }

/// Leave the simulator and go back to the app.
class ReturnToApp extends VueNavigation {
  const ReturnToApp(this.path);

  final String path;

  @override
  bool operator ==(Object other) => other is ReturnToApp && other.path == path;

  @override
  int get hashCode => path.hashCode;
}

/// Classifies a navigation. [isLocal] is true for our own asset server.
VueNavigation resolveVueNavigation(Uri uri, {required bool isLocal}) {
  // Never hand the user off to a browser.
  if (!isLocal) return const StayOnCurrentPage();

  final path = uri.path;
  if (path.isEmpty || path == '/' || path == '/index.html') {
    return const LoadInWebView();
  }
  if (path.startsWith('/api/')) return const LoadInWebView();

  final segments = uri.pathSegments;

  if (segments.length >= 3 &&
      (segments[0] == 'simulator' || segments[0] == 'simulatorvue') &&
      segments[1] == 'edit') {
    // Project ids are numeric. Anything else is never injected as script.
    if (RegExp(r'^\d+$').hasMatch(segments[2])) return OpenProject(segments[2]);

    // After loading a project, setup.js redirects here using the project name.
    // The circuit is already on the canvas, so ignore it.
    final version = uri.queryParameters['simver'];
    if (segments[0] == 'simulatorvue' && (version == null || version == 'v1')) {
      return const StayOnCurrentPage();
    }
    return ReturnToApp(uri.path);
  }

  if (segments.isNotEmpty && segments[0] == 'users') {
    if (segments.length >= 2 && segments[1] == 'sign_in') {
      return const OpenAppScreen(VueAppScreen.login);
    }
    if (segments.length == 2) {
      return OpenAppScreen(VueAppScreen.profile, argument: segments[1]);
    }
    if (segments.length >= 3 && segments[2] == 'groups') {
      return const OpenAppScreen(VueAppScreen.groups);
    }
    // Where the app lands after saving or updating project details.
    if (segments.length >= 4 &&
        segments[2] == 'projects' &&
        RegExp(r'^\d+$').hasMatch(segments[3])) {
      return OpenProjectPage(segments[3]);
    }
  }

  return ReturnToApp(uri.path);
}
