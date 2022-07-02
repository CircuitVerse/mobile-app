import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('EditProfileViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _user = User.fromJson(mockUser);

    group('updateProfile -', () {
      test('When called & service returns success response', () async {
        var _mockLocalStorageService = getAndRegisterLocalStorageServiceMock();
        var _mockUsersApi = getAndRegisterUsersApiMock();
        when(_mockUsersApi.updateProfile(
                'Test User', 'Gurukul', 'India', true, null, false))
            .thenAnswer((_) => Future.value(_user));

        var _model = EditProfileViewModel();
        await _model.updateProfile('Test User', 'Gurukul', 'India', true);

        // verify API call is made..
        verify(_mockUsersApi.updateProfile(
            'Test User', 'Gurukul', 'India', true, null, false));

        // verify _user is stored in localStorage..
        verify(_mockLocalStorageService.currentUser = _user);
        expect(_model.stateFor(_model.UPDATE_PROFILE), ViewState.Success);

        // verify profile is updated..
        expect(_model.updatedUser, _user);
      });

      test('When called & service returns error', () async {
        var _mockLocalStorageService = getAndRegisterLocalStorageServiceMock();
        var _mockUsersApi = getAndRegisterUsersApiMock();
        when(_mockUsersApi.updateProfile(
                'Test User', 'Gurukul', 'India', true, null, false))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = EditProfileViewModel();
        await _model.updateProfile('Test User', 'Gurukul', 'India', true);

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.UPDATE_PROFILE), ViewState.Error);
        expect(_model.errorMessageFor(_model.UPDATE_PROFILE),
            'Some Error Occurred!');

        // verify user is not populated on failure
        expect(_model.updatedUser, null);

        // verify null _user is never stored in localStorage..
        verifyNever(_mockLocalStorageService.currentUser = _user);
      });
    });
  });
}
