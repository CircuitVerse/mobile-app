import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/components/cv_typeahead_field.dart';
import 'package:mobile_app/ui/views/profile/edit_profile_view.dart';
import 'package:mobile_app/utils/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('EditProfileViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpEditProfileView(WidgetTester tester) async {
      // Mock Local Storage
      var _localStorageService = getAndRegisterLocalStorageServiceMock();

      var user = User.fromJson(mockUser);
      when(_localStorageService.currentUser).thenReturn(user);
      when(_localStorageService.isLoggedIn).thenReturn(true);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: EditProfileView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic EditProfileView widgets',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        await _pumpEditProfileView(tester);
        await tester.pumpAndSettle();

        // Finds Name, Country, Educational Institute
        expect(find.byWidgetPredicate((widget) {
          return (widget is CVTextField && widget.label == 'Name') ||
              (widget is CVTypeAheadField &&
                  (widget.label == 'Country' ||
                      widget.label == 'Educational Institute'));
        }), findsNWidgets(3));

        // Finds Subscribe to mail checkbox
        expect(find.byType(CheckboxListTile), findsOneWidget);

        // Finds Save Details button
        expect(find.widgetWithText(CVPrimaryButton, 'Save Details'),
            findsOneWidget);
      });
    });

    testWidgets('on Save Details is Tapped', (WidgetTester tester) async {
      // Mock Dialog Service
      var _dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(_dialogService);

      when(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));
      when(_dialogService.popDialog()).thenReturn(null);

      // Mock Edit Profile View Model
      var _editProfileViewModel = MockEditProfileViewModel();
      locator.registerSingleton<EditProfileViewModel>(_editProfileViewModel);

      when(_editProfileViewModel.updateProfile(any, any, any, any))
          .thenReturn(null);
      when(_editProfileViewModel
              .isSuccess(_editProfileViewModel.UPDATE_PROFILE))
          .thenReturn(true);

      // Pump Edit Profile View
      await _pumpEditProfileView(tester);
      await tester.pumpAndSettle();

      // Tap Save Details Button
      await tester.tap(find.widgetWithText(CVPrimaryButton, 'Save Details'));
      await tester.pumpAndSettle();

      await tester.pump(Duration(seconds: 5));

      // Verify Dialog Service is called to show Dialog of Updating
      verify(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .called(1);
    });
  });
}
