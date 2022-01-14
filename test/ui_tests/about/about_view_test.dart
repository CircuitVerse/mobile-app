import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/about/about_privacy_policy_view.dart';
import 'package:mobile_app/ui/views/about/about_tos_view.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
// import 'package:mobile_app/ui/views/about/components/contributor_avatar.dart';
import '../../utils_tests/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../setup/test_data/mock_contributors.dart';
import '../../setup/test_helpers.mocks.dart';

void main() {
  group('AboutViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpAboutView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale('en'),
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const AboutView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic AboutView widgets', (WidgetTester tester) async {
      await _pumpAboutView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(CVHeader), findsOneWidget);
      expect(find.byType(CVSubheader), findsOneWidget);
    });

    group('AboutView widgets for different API states -', () {
      testWidgets('when error response, finds GENERIC_FAILURE',
          (WidgetTester tester) async {
        await _pumpAboutView(tester);
        await tester.pumpAndSettle();

        // returning no response from API should throw generic failure
        expect(find.text(Constants.GENERIC_FAILURE), findsOneWidget);
      });

      testWidgets('when success response, finds contributor avatars',
          (WidgetTester tester) async {
        await provideMockedNetworkImages(() async {
          // var _mockContributorsApi = getAndRegisterContributorsApiMock();
          var _mockContributorsApi = MockContributorsApi();
          when(_mockContributorsApi.fetchContributors()).thenAnswer(
            (_) => Future.value(
              mockContributors
                  .map((e) => CircuitVerseContributor.fromJson(e))
                  .toList(),
            ),
          );

          await _pumpAboutView(tester);
          await tester.pumpAndSettle();

          // expect(find.byType(ContributorAvatar), findsNWidgets(3));
        });
      });
    });

    testWidgets('Terms of Service Page is Pushed onTap',
        (WidgetTester tester) async {
      await _pumpAboutView(tester);

      expect(find.widgetWithText(CVPrimaryButton, 'Terms Of Service'),
          findsOneWidget);
      await tester
          .tap(find.widgetWithText(CVPrimaryButton, 'Terms Of Service'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(AboutTosView), findsOneWidget);
    });

    testWidgets('Policy Page is Pushed onTap', (WidgetTester tester) async {
      await _pumpAboutView(tester);

      expect(find.widgetWithText(CVPrimaryButton, 'Privacy Policy'),
          findsOneWidget);
      await tester.tap(find.widgetWithText(CVPrimaryButton, 'Privacy Policy'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(AboutPrivacyPolicyView), findsOneWidget);
    });
  });
}
