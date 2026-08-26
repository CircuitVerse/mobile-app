import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, DeviceOrientation, rootBundle;
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/vue_simulator_server.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:mobile_app/viewmodels/simulator/simulator_viewmodel.dart';

/// Runs the bundled Vue simulator (cv-frontend-vue v1) on a local server.
///
/// The bundle cannot be loaded from `file://`: it is an ES module build that
/// also spawns a worker and calls fetch, all blocked without a real origin.
class VueSimulatorViewModel extends BaseModel {
  // ViewState Keys
  static const String SIMULATOR = 'vue_simulator';

  static const int port = 8123;

  /// Built by tool/build_vue_simulator.dart, bundled via pubspec.yaml.
  static const String _documentRoot = 'vue/dist/simulatorvue/v1';

  final LocalStorageService _storage = locator<LocalStorageService>();

  /// Static so re-entering the view reuses the server instead of racing a new
  /// one against the port the old one is still releasing.
  static VueSimulatorServer? _server;

  VueSimulatorServer get _serverInstance =>
      _server ??= VueSimulatorServer(
        port: port,
        documentRoot: _documentRoot,
        tokenProvider: () => _storage.isLoggedIn ? _storage.token : null,
      );

  String get url => _serverInstance.url;

  /// Downloads (circuit JSON, image exports) reuse the hosted simulator's flow.
  final SimulatorViewModel _downloads = locator<SimulatorViewModel>();

  Future<void> download(DownloadStartRequest request) =>
      _downloads.download(request);

  /// Looks up a project so a website link can open the app's project screen.
  Future<Project?> fetchProject(String projectId) async {
    try {
      return await locator<ProjectsApi>().getProjectDetails(projectId);
    } catch (e) {
      debugPrint('[vue-sim] could not fetch project $projectId: $e');
      return null;
    }
  }

  Future<void> onModelReady() async {
    setStateFor(SIMULATOR, ViewState.Busy);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    try {
      // The bundle is not committed, and a build without it still succeeds, so
      // check before starting or the user just gets a blank webview.
      await rootBundle.load('$_documentRoot/index.html');

      if (!_serverInstance.isRunning) {
        await _serverInstance.start();
      }
      setStateFor(SIMULATOR, ViewState.Idle);
    } on FlutterError catch (_) {
      const message =
          'Simulator bundle not found. Run '
          'dart run tool/build_vue_simulator.dart, then reinstall the app.';
      debugPrint('[vue-sim] $message');
      setErrorMessageFor(SIMULATOR, message);
      setStateFor(SIMULATOR, ViewState.Error);
    } catch (e) {
      debugPrint('[vue-sim] could not start the server: $e');
      setErrorMessageFor(SIMULATOR, e.toString());
      setStateFor(SIMULATOR, ViewState.Error);
    }
  }

  Future<void> onModelDestroy() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (_server?.isRunning ?? false) {
      await _server!.close();
    }
  }
}
