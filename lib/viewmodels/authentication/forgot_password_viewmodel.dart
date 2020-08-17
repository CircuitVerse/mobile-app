import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class ForgotPasswordViewModel extends BaseModel {
  final UsersApi _usersApi = locator<UsersApi>();

  Future onForgotPassword(String email) async {
    setState(ViewState.Busy);
    try {
      var _areInstructionsSent =
          await _usersApi.sendResetPasswordInstructions(email);

      if (_areInstructionsSent) {
        setState(ViewState.Success);
      } else {
        setState(ViewState.Error);
        setErrorMessage("Instructions couldn't be sent!");
      }
    } on Failure catch (f) {
      setState(ViewState.Error);
      setErrorMessage(f.message);
    }
  }
}
