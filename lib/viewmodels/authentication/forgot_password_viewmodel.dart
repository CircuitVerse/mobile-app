import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseModel {
  final UsersApi _usersApi = locator<UsersApi>();
  final DialogService _dialogService = locator<DialogService>();

  bool _isResetPasswordInstructionsSent = false;

  bool get isResetPasswordInstructionsSent => _isResetPasswordInstructionsSent;

  set isResetPasswordInstructionsSent(bool isResetPasswordInstructionsSent) {
    _isResetPasswordInstructionsSent = isResetPasswordInstructionsSent;
    notifyListeners();
  }

  Future onForgotPassword(String email) async {
    setState(ViewState.Busy);
    try {
      _dialogService.showCustomProgressDialog(title: 'Sending Instructions');
      isResetPasswordInstructionsSent =
          await _usersApi.sendResetPasswordInstructions(email);
      _dialogService.popDialog();
      setState(ViewState.Idle);

      // on success, show success snackbar and route to previous screen
      SnackBarUtils.showDark('Instructions Sent to $email');
      await Future.delayed(Duration(seconds: 1));
      await Get.back();
    } on Failure catch (f) {
      // on failure show snackbar with failure
      setState(ViewState.Error);
      _dialogService.popDialog();
      SnackBarUtils.showDark(f.message);
    }
  }
}
