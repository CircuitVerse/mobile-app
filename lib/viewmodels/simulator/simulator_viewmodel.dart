import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

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

  bool findMatchInString(String url) {
    if (url.contains('learn.circuitverse.org')) {
      Get.offNamed(IbLandingView.id);
    } else if (url.contains('sign_in')) {
      Get.offAndToNamed(LoginView.id);
    } else if (url.contains('sign_out')) {
      return true;
    }

    final components = url.split('/');
    final length = components.length;
    if (components[length - 1] == 'edit' &&
        components[length - 3] == 'projects') {
      return true;
    }

    return false;
  }

  void onModelReady() async {
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
