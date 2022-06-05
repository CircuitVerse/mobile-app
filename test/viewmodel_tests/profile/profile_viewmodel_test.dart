import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('ProfileViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _user = User.fromJson(mockUser);

    group('fetchUserProfile -', () {
      test('When called & service returns success response', () async {
        var _mockUsersApi = getAndRegisterUsersApiMock();
        when(_mockUsersApi.fetchUser('1'))
            .thenAnswer((_) => Future.value(_user));

        var _model = ProfileViewModel();
        _model.userId = '1';
        await _model.fetchUserProfile();

        // verify API call is made..
        verify(_mockUsersApi.fetchUser('1'));
        expect(_model.stateFor(_model.FETCH_USER_PROFILE), ViewState.Success);

        // verify profile/user is populated..
        expect(_model.user, _user);
      });

      test('When called & service returns error', () async {
        var _mockUsersApi = getAndRegisterUsersApiMock();
        when(_mockUsersApi.fetchUser('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProfileViewModel();
        _model.userId = '1';
        await _model.fetchUserProfile();

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.FETCH_USER_PROFILE), ViewState.Error);
        expect(_model.errorMessageFor(_model.FETCH_USER_PROFILE),
            'Some Error Occurred!');

        // verify user is not populated on failure
        expect(_model.user, null);
      });
    });
  });
}
