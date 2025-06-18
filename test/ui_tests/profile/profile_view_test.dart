import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import '../../setup/test_helpers.mocks.dart';
import '../../utils_tests/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('ProfileViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpProfileView(WidgetTester tester) async {
      var _localStorageService = getAndRegisterLocalStorageServiceMock();

      var user = User.fromJson(mockUser);
      when(_localStorageService.currentUser).thenReturn(user);
      when(_localStorageService.isLoggedIn).thenReturn(true);

      var _profileViewModel = MockProfileViewModel();
      locator.registerSingleton<ProfileViewModel>(_profileViewModel);

      when(_profileViewModel.userId).thenAnswer((_) => 'userId');
      when(_profileViewModel.isLoggedIn).thenAnswer((_) => true);
      when(_profileViewModel.isPersonalProfile).thenAnswer((_) => true);
      when(
        _profileViewModel.FETCH_USER_PROFILE,
      ).thenAnswer((_) => 'fetch_user_profile');

      when(_profileViewModel.fetchUserProfile()).thenReturn(null);

      when(
        _profileViewModel.isSuccess(_profileViewModel.FETCH_USER_PROFILE),
      ).thenReturn(true);
      when(_profileViewModel.user).thenReturn(user);

      var _userProjectsViewModel = MockUserProjectsViewModel();
      locator.registerSingleton<UserProjectsViewModel>(_userProjectsViewModel);

      when(
        _userProjectsViewModel.FETCH_USER_PROJECTS,
      ).thenAnswer((_) => 'fetch_user_projects');
      when(
        _userProjectsViewModel.fetchUserProjects(userId: anyNamed('userId')),
      ).thenReturn(null);
      when(_userProjectsViewModel.isSuccess(any)).thenReturn(false);
      when(
        _userProjectsViewModel.previousUserProjectsBatch,
      ).thenAnswer((_) => null);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          localizationsDelegates: [AppLocalizations.delegate],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProfileView(),
        ),
      );

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic ProfileView widgets', (
      WidgetTester tester,
    ) async {
      await provideMockedNetworkImages(() async {
        await _pumpProfileView(tester);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_image')), findsOneWidget);

        expect(find.text('Test User'), findsOneWidget);

        expect(find.byType(RichText), findsAtLeastNWidgets(4));

        expect(find.byType(Tab), findsNWidgets(2));
      });
    });
  });
}
