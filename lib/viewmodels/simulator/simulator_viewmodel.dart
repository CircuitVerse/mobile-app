import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
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
  final String url = '${EnvironmentConfig.CV_BASE_URL}/simulator';

  // Services
  final LocalStorageService _service = locator<LocalStorageService>();
  final cookieManager = CookieManager.instance();

  String? get token {
    if (!_service.isLoggedIn) return null;

    return _service.token;
  }

  Uri get uri => Uri.parse(EnvironmentConfig.CV_BASE_URL);

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) return true;

    final result = await permission.request();

    return result.isGranted;
  }

  Future<Directory> getAppDirectory() async {
    // This is only applicable to Android
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
      debugPrint('Error occured while downloading: ${e.toString()}');
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
      // clear all the cookies
      clearCookies();
      return true;
    }

    // save new project
    final components = url.split('/');
    final length = components.length;
    if (components[length - 1] == 'edit' &&
        components[length - 3] == 'projects') {
      return true;
    }

    // navigate to profile or groups
    if (url.contains('groups') || url.contains('users')) {
      return true;
    }

    return false;
  }

  void onModelReady() {
    // Set the orientation of the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void onModelDestroy() {
    // Reset to the screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
