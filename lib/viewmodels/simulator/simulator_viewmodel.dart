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

  String? get token => _service.token;

  String _cookies = "";

  String get cookies => _cookies;

  Future<String> get setCookies async {
    final _cookies = await cookieManager.getCookies(url: uri);

    String res = "";
    for (final cookie in _cookies) {
      res += "${cookie.name}=${cookie.value};";
    }

    return res;
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

    return false;
  }

  void onModelReady() async {
    // Set the orientation of the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    if (!_service.isLoggedIn) await cookieManager.deleteAllCookies();

    // Set the cookie
    final expiryDate = DateTime.now().add(const Duration(days: 15));
    cookieManager.setCookie(
      url: uri,
      name: 'remember_user_token',
      value: token ?? 'token',
      expiresDate: expiryDate.millisecondsSinceEpoch,
    );

    _cookies = await setCookies;
  }

  void onModelDestroy() {
    // Reset to the screen orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
