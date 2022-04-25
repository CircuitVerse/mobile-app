import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class CVLandingViewModel extends BaseModel {
  final LocalStorageService _storage = locator<LocalStorageService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  User? _currentUser;

  bool get isLoggedIn => _storage.isLoggedIn;

  User? get currentUser => _currentUser;

  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  void onLogout() async {
    _storage.isLoggedIn = false;
    _storage.currentUser = null;
    _storage.token = null;

    // Perform facebook logout if auth type is facebook..
    if (_storage.authType == AuthType.FACEBOOK) {
      await FacebookAuth.instance.logOut();
    }

    // Perform google signout if auth type is google..
    if (_storage.authType == AuthType.GOOGLE) {
      await _googleSignIn.signOut();
    }

    notifyListeners();
  }

  void setUser() {
    _currentUser = _storage.currentUser;
  }

  void onProfileUpdated() {
    final _updatedUser = _storage.currentUser;
    if (_currentUser?.data.attributes.name ==
        _updatedUser?.data.attributes.name) return;

    currentUser = _updatedUser;
  }
}
