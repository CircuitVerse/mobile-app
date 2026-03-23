import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/ui/views/onboarding/onboarding_view.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class StartUpViewModel extends BaseModel {
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  Future handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if it's the first time the user is opening the app
    if (_localStorageService.isFirstTimeLaunch) {
      await Get.offAllNamed(OnboardingView.id);
    } else {
      await Get.offAllNamed(CVLandingView.id);
    }
  }
}
