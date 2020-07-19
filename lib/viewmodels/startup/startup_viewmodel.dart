import 'package:get/get.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class StartUpViewModel extends BaseModel {
  Future handleStartUpLogic() async {
    await Future.delayed(Duration(seconds: 1));
    await Get.offAllNamed(HomeView.id);
  }
}
