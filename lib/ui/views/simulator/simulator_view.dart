import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/simulator/simulator_viewmodel.dart';

class SimulatorView extends StatelessWidget {
  static const String id = 'simulator_view';

  const SimulatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BaseView<SimulatorViewModel>(
          onModelReady: (model) => model.onModelReady(),
          onModelDestroy: (model) => model.onModelDestroy(),
          builder: (context, model, _) {
            return IndexedStack(
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
                  onLoadStop: (controller, uri) async {
                    model.setStateFor(
                        SimulatorViewModel.SIMULATOR, ViewState.Idle);
                  },
                  initialUrlRequest: URLRequest(
                    url: Uri.parse(model.url),
                    headers: {'Authorization': 'Token ${model.token}'},
                  ),
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      useShouldOverrideUrlLoading: true,
                      useOnDownloadStart: true,
                    ),
                  ),
                  shouldOverrideUrlLoading: (con, navigationAction) async {
                    final url = navigationAction.request.url.toString();

                    if (model.findMatchInString(url)) {
                      Get.back(result: url);
                    }

                    return NavigationActionPolicy.CANCEL;
                  },
                  onDownloadStartRequest: (controller, request) {
                    model.download(request);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
