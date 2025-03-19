import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/authentication/forgot_password_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('ForgotPasswordViewModelTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    group('onForgotPassword -', () {
      test('When called & service returns response true', () async {
        var _usersApiMock = getAndRegisterUsersApiMock();

        when(
          _usersApiMock.sendResetPasswordInstructions('test@test.com'),
        ).thenAnswer((_) => Future.value(true));

        var _model = ForgotPasswordViewModel();
        await _model.onForgotPassword('test@test.com');

        // should call login with expected variables
        verify(_usersApiMock.sendResetPasswordInstructions('test@test.com'));
        expect(
          _model.stateFor(_model.SEND_RESET_INSTRUCTIONS),
          ViewState.Success,
        );
      });

      test('When called & service returns response false', () async {
        var _usersApiMock = getAndRegisterUsersApiMock();

        when(
          _usersApiMock.sendResetPasswordInstructions('test@test.com'),
        ).thenAnswer((_) => Future.value(false));

        var _model = ForgotPasswordViewModel();
        await _model.onForgotPassword('test@test.com');

        // should call login with expected variables
        verify(_usersApiMock.sendResetPasswordInstructions('test@test.com'));
        expect(
          _model.stateFor(_model.SEND_RESET_INSTRUCTIONS),
          ViewState.Error,
        );
        expect(
          _model.errorMessageFor(_model.SEND_RESET_INSTRUCTIONS),
          "Instructions couldn't be sent!",
        );
      });

      test('When called & service throws failure', () async {
        var _usersApiMock = getAndRegisterUsersApiMock();

        when(
          _usersApiMock.sendResetPasswordInstructions('test@test.com'),
        ).thenThrow(Failure('Some Error Occurred!'));

        var _model = ForgotPasswordViewModel();
        await _model.onForgotPassword('test@test.com');

        // should call login with expected variables
        verify(_usersApiMock.sendResetPasswordInstructions('test@test.com'));
        expect(
          _model.stateFor(_model.SEND_RESET_INSTRUCTIONS),
          ViewState.Error,
        );
      });
    });
  });
}
