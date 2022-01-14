import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/authentication/login_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('LoginViewModelTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    group('login -', () {
      test('When called & service returns token response', () async {
        var _usersApiMock = getAndRegisterUsersApiMock();

        when(_usersApiMock.login('test@test.com', 'password'))
            .thenAnswer((_) => Future.value('token'));

        var _model = LoginViewModel();
        when(_usersApiMock.fetchCurrentUser()).thenAnswer((_) => null);
        await _model.login('test@test.com', 'password');

        // should call login with expected variables
        verify(_usersApiMock.login('test@test.com', 'password'));
        expect(_model.stateFor(_model.LOGIN), ViewState.Success);
      });

      test('When called & service throws error', () async {
        var _mockUsersApi = getAndRegisterUsersApiMock();

        when(_mockUsersApi.login('test@test.com', 'password'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = LoginViewModel();
        await _model.login('test@test.com', 'password');

        // should call login with expected variables
        verify(_mockUsersApi.login('test@test.com', 'password'));
        expect(_model.stateFor(_model.LOGIN), ViewState.Error);
      });
    });
  });
}
