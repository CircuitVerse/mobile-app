import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile_app/config/environment_config.dart';

class SimulatorView extends StatefulWidget {
  static const String id = 'simulator_view';

  const SimulatorView({Key? key}) : super(key: key);

  @override
  State<SimulatorView> createState() => _SimulatorViewState();
}

class _SimulatorViewState extends State<SimulatorView> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadingState = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadingState.dispose();
    super.dispose();
  }

  late final ValueNotifier<int> _loadingState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: _loadingState,
          builder: (context, value, _) {
            return IndexedStack(
              index: value,
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
                  onLoadStop: (_, uri) {
                    _loadingState.value = 1;
                  },
                  initialUrlRequest: URLRequest(
                    url:
                        Uri.parse('${EnvironmentConfig.CV_BASE_URL}/simulator'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
