import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/ui/views/home_view.dart';
import 'package:mobile_app/ui/views/login_view.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  Future handleStartUpLogic() async {
    bool isLoggedIn = _localStorageService.isLoggedIn;

    await Future.delayed(Duration(seconds: 1));

    if (isLoggedIn) {
      _navigationService.pushNamedAndRemoveUntil(HomeView.id);
    } else {
      _navigationService.pushNamedAndRemoveUntil(LoginView.id);
    }
  }
}
