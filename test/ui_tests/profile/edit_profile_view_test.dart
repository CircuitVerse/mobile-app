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
import '../../setup/test_helpers.mocks.dart';
import '../../utils_tests/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('EditProfileViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpEditProfileView(WidgetTester tester) async {
      // Mock Edit Profile View Model
      var _editProfileViewModel = MockEditProfileViewModel();
      locator.registerSingleton<EditProfileViewModel>(_editProfileViewModel);

      when(_editProfileViewModel.UPDATE_PROFILE)
          .thenAnswer((_) => 'update_profile');
      when(_editProfileViewModel.imageUpdated).thenAnswer((_) => false);
      when(_editProfileViewModel.updateProfile(any, any, any, any))
          .thenReturn(null);
      when(_editProfileViewModel.isSuccess(any)).thenReturn(true);
      when(_editProfileViewModel.updatedUser).thenAnswer((_) => null);
      // Mock Local Storage
      var _localStorageService = getAndRegisterLocalStorageServiceMock();

      var user = User.fromJson(mockUser);
      when(_localStorageService.currentUser).thenReturn(user);
      when(_localStorageService.isLoggedIn).thenReturn(true);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const EditProfileView(),
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

    testWidgets('pick profile picture', (WidgetTester tester) async {
      // Pump Edit Profile View
      await _pumpEditProfileView(tester);
      await tester.pumpAndSettle();

      final _profilePictureWidget = find.byKey(const Key('profile_image'));
      expect(_profilePictureWidget, findsOneWidget);

      await tester.tap(_profilePictureWidget);
      await tester.pumpAndSettle();

      // Bottom sheet is opened
      verify(mockObserver.didPush(any, any));

      final _galleryPickerIcon = find.byIcon(Icons.collections);
      expect(_galleryPickerIcon, findsOneWidget);

      await tester.tap(_galleryPickerIcon);
      await tester.pumpAndSettle();

      verify(mockObserver.didPop(any, any));
    });

    testWidgets('remove picked profile picture', (WidgetTester tester) async {
      // Pump Edit Profile View
      await _pumpEditProfileView(tester);
      await tester.pumpAndSettle();

      final _editProfileViewModel = locator<EditProfileViewModel>();

      final _profilePictureWidget = find.byKey(const Key('profile_image'));
      expect(_profilePictureWidget, findsOneWidget);

      await tester.tap(_profilePictureWidget);
      await tester.pumpAndSettle();

      // Bottom sheet is opened
      verify(mockObserver.didPush(any, any));

      final _deleteImageWidget = find.byIcon(Icons.delete);
      expect(_deleteImageWidget, findsOneWidget);

      await tester.tap(_deleteImageWidget);
      await tester.pumpAndSettle();

      // Set the selected image to null
      when(_editProfileViewModel.updatedImage).thenAnswer((_) => null);

      // Bottom Sheet is closed
      verify(mockObserver.didPop(any, any));
      expect(_editProfileViewModel.updatedImage, isNull);
    });

    testWidgets('on Save Details is Tapped', (WidgetTester tester) async {
      // Mock Dialog Service
      var _dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(_dialogService);

      when(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));
      when(_dialogService.popDialog()).thenReturn(null);

      // Pump Edit Profile View
      await _pumpEditProfileView(tester);
      await tester.pumpAndSettle();

      // Tap Save Details Button
      await tester.tap(find.widgetWithText(CVPrimaryButton, 'Save Details'));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 5));

      // Verify Dialog Service is called to show Dialog of Updating
      verify(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .called(1);
    });
  });
}
