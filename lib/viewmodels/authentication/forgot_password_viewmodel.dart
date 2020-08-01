import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseModel {
  bool _isResetPasswordInstructionsSent = false;

  bool get isResetPasswordInstructionsSent => _isResetPasswordInstructionsSent;

  set isResetPasswordInstructionsSent(bool isResetPasswordInstructionsSent) {
    _isResetPasswordInstructionsSent = isResetPasswordInstructionsSent;
    notifyListeners();
  }

  Future onForgotPassword(String email) async {}
}
