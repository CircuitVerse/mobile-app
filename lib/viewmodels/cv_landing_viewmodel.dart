import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class CVLandingViewModel extends BaseModel {
  final LocalStorageService _storage = locator<LocalStorageService>();

  bool get isLoggedIn => _storage.isLoggedIn;

  User get currentUser => _storage.currentUser;

  void onLogout() async {
    _storage.isLoggedIn = false;
    _storage.currentUser = null;
    _storage.token = null;

    notifyListeners();
  }
}
