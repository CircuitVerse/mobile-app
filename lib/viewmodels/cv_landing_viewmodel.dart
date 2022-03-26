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
  String? _name;

  bool get isLoggedIn => _storage.isLoggedIn;

  User? get currentUser => _storage.currentUser;

  String? get name => _name;

  set userName(String? val) {
    _name = val;
    notifyListeners();
  }

  void listenToUserStream() {
    _storage.userStream().listen((user) {
      final updatedName = user?.data.attributes.name;

      if (updatedName == null) return;
      userName = updatedName;
    });
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
}
