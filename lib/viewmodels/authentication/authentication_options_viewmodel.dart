import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class AuthenticationOptionsViewModel extends BaseModel {
  Future facebookAuth({bool isSignUp = false}) async {}

  Future googleAuth({bool isSignUp = false}) async {}

  Future githubAuth({bool isSignUp = false}) async {}
}
