import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/viewmodels/authentication/signup_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('SignupViewModelTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    group('signup -', () {
      test('When called & service returns token response', () async {
        var _usersApiMock = getAndRegisterUsersApiMock();

        when(_usersApiMock.signup('test', 'test@test.com', 'password'))
            .thenAnswer((_) => Future.value('token'));

        var _model = SignupViewModel();
        when(_usersApiMock.fetchCurrentUser()).thenAnswer((_) => null);
        await _model.signup('test', 'test@test.com', 'password');

        // should call login with expected variables
        verify(_usersApiMock.signup('test', 'test@test.com', 'password'));
        expect(_model.stateFor(_model.SIGNUP), ViewState.Success);
      });

      test('When called & service throws error', () async {
        var _mockUsersApi = getAndRegisterUsersApiMock();

        when(_mockUsersApi.signup('test', 'test@test.com', 'password'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = SignupViewModel();
        await _model.signup('test', 'test@test.com', 'password');

        // should call login with expected variables
        verify(_mockUsersApi.signup('test', 'test@test.com', 'password'));
        expect(_model.stateFor(_model.SIGNUP), ViewState.Error);
      });
    });
  });
}
