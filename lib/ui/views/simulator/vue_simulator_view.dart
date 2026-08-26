import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/simulator/vue_simulator_navigation.dart';
import 'package:mobile_app/viewmodels/simulator/vue_simulator_viewmodel.dart';

/// Runs the bundled Vue simulator, unlike [SimulatorView] which loads the
/// hosted one over the network.
class VueSimulatorView extends StatefulWidget {
  static const String id = 'vue_simulator_view';

  const VueSimulatorView({super.key, this.projectId});

  /// Project to open. A blank circuit when null.
  final String? projectId;

  @override
  State<VueSimulatorView> createState() => _VueSimulatorViewState();
}

class _VueSimulatorViewState extends State<VueSimulatorView> {
  InAppWebViewController? _webViewController;

  /// Script that puts a project id where the bundle looks for it.
  ///
  /// It has to run at document start, and has to be an accessor: the bundle
  /// sets `logixProjectId = undefined` while booting, which would wipe a plain
  /// assignment. Making it read-only instead would throw, as the bundle is an
  /// ES module.
  static UserScript _projectIdScript(String projectId) => UserScript(
    source: '''
(function () {
  var id = "$projectId";
  Object.defineProperty(window, 'logixProjectId', {
    configurable: true,
    get: function () { return id; },
    set: function (value) { if (value !== undefined && value !== null) id = value; }
  });
})();
''',
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
  );

  /// Reopens a project by reloading the bundle with its id in place.
  Future<void> _openProject(
    InAppWebViewController controller,
    String projectId,
    String url,
  ) async {
    await controller.removeAllUserScripts();
    await controller.addUserScript(userScript: _projectIdScript(projectId));
    debugPrint('[vue-sim] reopening project $projectId');
    await controller.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  /// Shows a project on the app's own screen instead of the website.
  Future<void> _openProjectPage(
    VueSimulatorViewModel model,
    String projectId,
  ) async {
    final project = await model.fetchProject(projectId);
    if (!mounted) return;

    Navigator.of(context).pop();
    if (project != null) {
      await Get.toNamed(ProjectDetailsView.id, arguments: project);
    }
  }

  /// Pops first, so the landscape lock and full screen are undone before the
  /// next screen appears.
  Future<void> _openAppScreen(OpenAppScreen destination) async {
    Navigator.of(context).pop();

    switch (destination.screen) {
      case VueAppScreen.profile:
        await Get.toNamed(ProfileView.id, arguments: destination.argument);
      case VueAppScreen.groups:
        await Get.toNamed(MyGroupsView.id);
      case VueAppScreen.login:
        await Get.toNamed(LoginView.id);
    }
  }

  /// Goes back through the simulator's own history before leaving the view.
  Future<void> _handleBack([Object? result]) async {
    if (_webViewController != null && await _webViewController!.canGoBack()) {
      await _webViewController!.goBack();
      return;
    }
    if (mounted) Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    // No SafeArea: the simulator runs edge to edge, cutout included.
    return Scaffold(
      body: BaseView<VueSimulatorViewModel>(
        onModelReady: (model) => model.onModelReady(),
        onModelDestroy: (model) => model.onModelDestroy(),
        builder: (context, model, child) {
          if (model.isError(VueSimulatorViewModel.SIMULATOR)) {
            return _ErrorState(
              message: model.errorMessageFor(VueSimulatorViewModel.SIMULATOR),
              onBack: () => Navigator.of(context).pop(),
            );
          }

          // Wait for the server, or the first request races the bind.
          if (model.isBusy(VueSimulatorViewModel.SIMULATOR)) {
            return const Center(child: CircularProgressIndicator());
          }

          final loaded = model.isSuccess(VueSimulatorViewModel.SIMULATOR);

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              await _handleBack(result);
            },
            child: IndexedStack(
              index: loaded ? 1 : 0,
              children: [
                const Center(child: CircularProgressIndicator()),
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(model.url)),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    // The canvas handles its own gestures.
                    supportZoom: false,
                    useShouldOverrideUrlLoading: true,
                    useOnDownloadStart: true,
                    useHybridComposition: true,
                    allowsInlineMediaPlayback: true,
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                  // Registered up front: the bundle reads the id before mount.
                  initialUserScripts:
                      widget.projectId == null
                          ? null
                          : UnmodifiableListView([
                            _projectIdScript(widget.projectId!),
                          ]),
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onDownloadStartRequest: (controller, request) {
                    model.download(request);
                  },
                  // Failures in the bundle are silent otherwise -- the page
                  // just stays white.
                  onConsoleMessage: (controller, message) {
                    if (kDebugMode) {
                      debugPrint(
                        '[vue-sim] ${message.messageLevel}: ${message.message}',
                      );
                    }
                  },
                  onReceivedError: (controller, request, error) {
                    debugPrint(
                      '[vue-sim] load error ${request.url}: '
                      '${error.type} ${error.description}',
                    );
                  },
                  onReceivedHttpError: (controller, request, response) {
                    debugPrint(
                      '[vue-sim] http ${response.statusCode} for ${request.url}',
                    );
                  },
                  onLoadStop: (controller, uri) async {
                    model.setStateFor(
                      VueSimulatorViewModel.SIMULATOR,
                      ViewState.Success,
                    );
                  },
                  shouldOverrideUrlLoading: (controller, action) async {
                    final uri = action.request.url;
                    if (uri == null) return NavigationActionPolicy.ALLOW;

                    final destination = resolveVueNavigation(
                      uri,
                      isLocal:
                          uri.host == 'localhost' &&
                          uri.port == VueSimulatorViewModel.port,
                    );

                    switch (destination) {
                      case LoadInWebView():
                        return NavigationActionPolicy.ALLOW;
                      case StayOnCurrentPage():
                        debugPrint('[vue-sim] absorbed redirect ${uri.path}');
                      case OpenProject(:final projectId):
                        await _openProject(controller, projectId, model.url);
                      case OpenAppScreen():
                        await _openAppScreen(destination);
                      case OpenProjectPage(:final projectId):
                        await _openProjectPage(model, projectId);
                      case ReturnToApp(:final path):
                        debugPrint('[vue-sim] leaving simulator: $path');
                        if (context.mounted) Navigator.of(context).pop();
                    }
                    return NavigationActionPolicy.CANCEL;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 12),
            Text(
              'Could not start the offline simulator.\n$message',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onBack, child: const Text('Go back')),
          ],
        ),
      ),
    );
  }
}
