import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseModel {
  // ViewState Keys
  final String SEND_RESET_INSTRUCTIONS = 'send_reset_instructions';

  final UsersApi _usersApi = locator<UsersApi>();

  Future onForgotPassword(String email) async {
    setStateFor(SEND_RESET_INSTRUCTIONS, ViewState.Busy);
    try {
      var _areInstructionsSent =
          await _usersApi.sendResetPasswordInstructions(email);

      if (_areInstructionsSent ?? false) {
        setStateFor(SEND_RESET_INSTRUCTIONS, ViewState.Success);
      } else {
        setStateFor(SEND_RESET_INSTRUCTIONS, ViewState.Error);
        setErrorMessageFor(
            SEND_RESET_INSTRUCTIONS, "Instructions couldn't be sent!");
      }
    } on Failure catch (f) {
      setStateFor(SEND_RESET_INSTRUCTIONS, ViewState.Error);
      setErrorMessageFor(SEND_RESET_INSTRUCTIONS, f.message);
    }
  }
}
