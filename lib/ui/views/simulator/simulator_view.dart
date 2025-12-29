import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/simulator/simulator_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class SimulatorView extends StatefulWidget {
  static const String id = 'simulator_view';

  const SimulatorView({super.key});

  @override
  State<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends State<SimulatorView> {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    // Get the project argument if passed
    final Project? project = Get.arguments as Project?;

    return Scaffold(
      body: SafeArea(
        child: BaseView<SimulatorViewModel>(
          onModelReady: (model) => model.onModelReady(project),
          onModelDestroy: (model) => model.onModelDestroy(),
          builder: (context, model, child) {
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
                Navigator.of(context).pop(result);
              },
              child: IndexedStack(
                index: model.isIdle(SimulatorViewModel.SIMULATOR) ? 1 : 0,
                children: [
                  Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[300],
                        color: Colors.grey[500],
                        strokeWidth: 3.0,
                      ),
                    ),
                  ),
                  InAppWebView(
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStop: (controller, uri) async {
                      model.setStateFor(
                        SimulatorViewModel.SIMULATOR,
                        ViewState.Idle,
                      );
                    },
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.parse(model.url)),
                      headers: {'Authorization': 'Token ${model.token}'},
                    ),
                    initialSettings: InAppWebViewSettings(
                      useShouldOverrideUrlLoading: true,
                      useOnDownloadStart: true,
                    ),
                    shouldOverrideUrlLoading: (controller, action) async {
                      final uri = action.request.url;
                      if (uri == null) {
                        return NavigationActionPolicy.ALLOW;
                      }

                      final urlStr = uri.toString();

                      if (urlStr.contains('sign_out')) {
                        model.clearCookies();
                        Navigator.of(context).pop();
                        return NavigationActionPolicy.CANCEL;
                      }

                      final host = uri.host.toLowerCase();
                      final path = uri.path.toLowerCase();
                      final isLearn = host == 'learn.circuitverse.org';
                      final isPdf = path.endsWith('.pdf');

                      if (isLearn || isPdf) {
                        final ok = await launchUrl(
                          Uri.parse(urlStr),
                          mode: LaunchMode.externalApplication,
                        );
                        if (ok) {
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
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
      ),
    );
  }
}
