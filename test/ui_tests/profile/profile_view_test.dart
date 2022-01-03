import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import '../../utils_tests/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_user.dart';
// import '../../setup/test_helpers.dart';
import 'profile_view_test.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>(returnNullOnMissingStub: true),
    MockSpec<LocalStorageService>(returnNullOnMissingStub: true),
    MockSpec<ProfileViewModel>(returnNullOnMissingStub: true),
    MockSpec<UserProjectsViewModel>(returnNullOnMissingStub: true),
  ],
)
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
      // Mock Local Storage
      var _localStorageService = MockLocalStorageService();
      var isRegistered = locator.isRegistered<LocalStorageService>();
      if (isRegistered) {
        locator.unregister<LocalStorageService>();
      }
      locator.registerSingleton<LocalStorageService>(_localStorageService);

      var user = User.fromJson(mockUser);
      when(_localStorageService.currentUser).thenReturn(user);
      when(_localStorageService.isLoggedIn).thenReturn(true);

      // Mock Profile ViewModel
      var _profileViewModel = MockProfileViewModel();
      locator.registerSingleton<ProfileViewModel>(_profileViewModel);

      when(_profileViewModel.FETCH_USER_PROFILE)
          .thenAnswer((_) => 'fetch_user_profile');

      when(_profileViewModel.fetchUserProfile(any)).thenReturn(null);

      when(_profileViewModel.isSuccess(_profileViewModel.FETCH_USER_PROFILE))
          .thenReturn(true);
      when(_profileViewModel.user).thenReturn(user);

      // Mock User Projects ViewModel
      var _userProjectsViewModel = MockUserProjectsViewModel();
      locator.registerSingleton<UserProjectsViewModel>(_userProjectsViewModel);

      when(_userProjectsViewModel.FETCH_USER_PROJECTS)
          .thenAnswer((_) => 'fetch_user_projects');
      when(_userProjectsViewModel.fetchUserProjects()).thenReturn(null);
      when(_userProjectsViewModel.isSuccess(any)).thenReturn(false);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const ProfileView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic ProfileView widgets',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        await _pumpProfileView(tester);
        await tester.pumpAndSettle();

        // Finds Profile Image
        expect(find.byType(Image), findsOneWidget);

        // Finds Username
        expect(find.text('Test User'), findsOneWidget);

        // Finds Joined, Country, Institute, Subscription
        expect(find.byWidgetPredicate((widget) {
          return widget is RichText &&
              (widget.text.toPlainText().contains('Joined : ') ||
                  widget.text.toPlainText() == 'Country : India' ||
                  widget.text.toPlainText() ==
                      'Educational Institute : Gurukul' ||
                  widget.text.toPlainText() == 'Subscribed to mails : true');
        }), findsNWidgets(4));

        // Finds Tabs of Circuits, Favorites
        expect(find.widgetWithText(Tab, 'Circuits'), findsOneWidget);
        expect(find.widgetWithText(Tab, 'Favourites'), findsOneWidget);
      });
    });
  });
}
