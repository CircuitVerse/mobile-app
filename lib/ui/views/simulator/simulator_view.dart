import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/simulator/simulator_viewmodel.dart';
import 'package:mobile_app/viewmodels/simulator/vue_simulator_navigation.dart';

class SimulatorView extends StatefulWidget {
  static const String id = 'simulator_view';

  const SimulatorView({super.key});

  @override
  State<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends State<SimulatorView> {
  InAppWebViewController? webViewController;

  /// Pops first, so the landscape lock and full screen are undone before the
  /// next screen appears.
  Future<void> _openAppScreen(
    SimulatorViewModel model,
    OpenAppScreen destination,
  ) async {
    Object? arguments = destination.argument;
    if (destination.screen == VueAppScreen.project) {
      arguments = await model.fetchProject(destination.argument!);
      // Stay in the simulator if the lookup failed -- leaving it would close
      // the circuit with nowhere to go.
      if (arguments == null) return;
    }
    if (!mounted) return;

    Navigator.of(context).pop();
    await Get.toNamed(switch (destination.screen) {
      VueAppScreen.profile => ProfileView.id,
      VueAppScreen.groups => MyGroupsView.id,
      VueAppScreen.login => LoginView.id,
      VueAppScreen.project => ProjectDetailsView.id,
    }, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    // No SafeArea: the simulator runs edge to edge, cutout included.
    return Scaffold(
      body: BaseView<SimulatorViewModel>(
        onModelReady:
            (model) => model.onModelReady((Get.arguments as Project?)?.id),
        onModelDestroy: (model) => model.onModelDestroy(),
        builder: (context, model, child) {
          if (model.isError(SimulatorViewModel.SIMULATOR)) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Could not start the simulator.\n'
                    '${model.errorMessageFor(SimulatorViewModel.SIMULATOR)}',
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go back'),
                  ),
                ],
              ),
            );
          }

          // Wait for the server, or the first request races the bind.
          if (model.isBusy(SimulatorViewModel.SIMULATOR)) {
            return const Center(child: CircularProgressIndicator());
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              if (webViewController != null) {
                bool canGoBack = await webViewController!.canGoBack();
                if (canGoBack) {
                  await webViewController!.goBack();
                  return;
                }
              }
              if (context.mounted) Navigator.of(context).pop(result);
            },
            child: IndexedStack(
              index: model.isSuccess(SimulatorViewModel.SIMULATOR) ? 1 : 0,
              children: [
                const Center(child: CircularProgressIndicator()),
                InAppWebView(
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStop: (controller, uri) async {
                    model.setStateFor(
                      SimulatorViewModel.SIMULATOR,
                      ViewState.Success,
                    );
                  },
                  initialUrlRequest: URLRequest(url: WebUri(model.url)),
                  initialSettings: InAppWebViewSettings(
                    // The canvas handles its own gestures.
                    supportZoom: false,
                    useShouldOverrideUrlLoading: true,
                    useOnDownloadStart: true,
                  ),
                  shouldOverrideUrlLoading: (controller, action) async {
                    final uri = action.request.url;
                    if (uri == null) return NavigationActionPolicy.ALLOW;

                    final destination = resolveVueNavigation(
                      uri,
                      isLocal:
                          uri.host == 'localhost' && uri.port == model.port,
                    );

                    switch (destination) {
                      case LoadInWebView():
                        return NavigationActionPolicy.ALLOW;
                      case StayOnCurrentPage():
                        break;
                      case OpenProject(:final projectId):
                        // The page picks the id up from the globals the
                        // server inlines.
                        model.projectId = projectId;
                        await controller.loadUrl(
                          urlRequest: URLRequest(url: WebUri(model.url)),
                        );
                      case OpenAppScreen():
                        await _openAppScreen(model, destination);
                      case ReturnToApp():
                        if (context.mounted) Navigator.of(context).pop();
                    }
                    return NavigationActionPolicy.CANCEL;
                  },
                  onDownloadStartRequest: (controller, request) {
                    model.download(request);
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
