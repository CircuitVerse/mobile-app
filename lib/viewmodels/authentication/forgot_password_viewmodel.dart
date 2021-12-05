import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseModel {
  // ViewState Keys
  final String sendResetInstructionsKey = 'send_reset_instructions';

  final UsersApi _usersApi = locator<UsersApi>();

  Future onForgotPassword(String email) async {
    setStateFor(sendResetInstructionsKey, ViewState.Busy);
    try {
      var _areInstructionsSent =
          await _usersApi.sendResetPasswordInstructions(email);

      if (_areInstructionsSent) {
        setStateFor(sendResetInstructionsKey, ViewState.Success);
      } else {
        setStateFor(sendResetInstructionsKey, ViewState.Error);
        setErrorMessageFor(
            sendResetInstructionsKey, "Instructions couldn't be sent!");
      }
    } on Failure catch (f) {
      setStateFor(sendResetInstructionsKey, ViewState.Error);
      setErrorMessageFor(sendResetInstructionsKey, f.message);
    }
  }
}
