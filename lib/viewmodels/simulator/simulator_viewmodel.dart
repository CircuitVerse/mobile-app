import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SimulatorViewModel extends BaseModel {
  // ViewState Keys
  static const String SIMULATOR = 'simulator';

  // Services
  final LocalStorageService _service = locator<LocalStorageService>();
  final cookieManager = CookieManager.instance();

  // Project to edit
  Project? _projectToEdit;

  String get url {
    if (_projectToEdit != null) {
      return '${EnvironmentConfig.CV_BASE_URL}/simulator/edit/${_projectToEdit!.id}';
    }
    return '${EnvironmentConfig.CV_BASE_URL}/simulator';
  }

  String? get token {
    if (!_service.isLoggedIn) return null;
    return _service.token;
  }

  Uri get uri => Uri.parse(EnvironmentConfig.CV_BASE_URL);

  void setProjectToEdit(Project? project) {
    _projectToEdit = project;
    notifyListeners();
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) return true;
    final result = await permission.request();
    return result.isGranted;
  }

  Future<Directory> getAppDirectory() async {
    final directory = await getExternalStorageDirectory();
    final folders = directory!.path.split('/');

    String newPath = '';
    for (final folder in folders) {
      if (folder.isEmpty) continue;

      if (folder == 'Android') {
        newPath += '/CircuitVerse';
        break;
      }

      newPath += '/$folder';
    }

    return Directory(newPath);
  }

  void download(DownloadStartRequest request) async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          final directory = await getAppDirectory();

          if (!await directory.exists()) {
            directory.create(recursive: true);
          }

          final type = request.url.data?.mimeType.split('/');

          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          if (type?[0] == 'text') {
            fileName = 'verilog-$fileName.v';
          } else if (type?[0] == 'image') {
            fileName = 'image-$fileName.${type?[1]}';
          }

          if (await directory.exists()) {
            final file = File('${directory.path}/$fileName');
            file.writeAsBytesSync(
              List.from(request.url.data!.contentAsBytes()),
            );

            SnackBarUtils.showDark(
              'Downloaded!!',
              '$fileName downloaded at ${directory.path}',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error occurred while downloading: ${e.toString()}');
      rethrow;
    }
  }

  void clearCookies() async {
    await cookieManager.deleteAllCookies();
  }

  bool findMatchInString(String url) {
    if (url.contains('learn.circuitverse.org')) {
      Get.offNamed(IbLandingView.id);
    } else if (url.contains('sign_in')) {
      Get.offAndToNamed(LoginView.id);
    } else if (url.contains('sign_out')) {
      clearCookies();
      return true;
    }

    final components = url.split('/');
    final length = components.length;
    if (components[length - 1] == 'edit' &&
        components[length - 3] == 'projects') {
      return true;
    }

    if (url.contains('projects') &&
        (url.contains('saved') || url.contains('updated'))) {
      return true;
    }

    if (url.contains('groups') || url.contains('users')) {
      return true;
    }

    return false;
  }

  void onModelReady([Project? project]) {
    if (project != null) {
      setProjectToEdit(project);
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void onModelDestroy() {
    _projectToEdit = null;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
