import 'package:get/get.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class StartUpViewModel extends BaseModel {
  Future handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 1));
    await Get.offAllNamed(CVLandingView.id);
  }
}
