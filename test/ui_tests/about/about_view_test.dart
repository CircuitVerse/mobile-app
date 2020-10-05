import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/about/components/contributor_avatar.dart';
import 'package:mobile_app/utils/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_contributors.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('AboutViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpAboutView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: AboutView(),
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
          var _mockContributorsApi = getAndRegisterContributorsApiMock();
          when(_mockContributorsApi.fetchContributors()).thenAnswer(
            (_) => Future.value(
              mockContributors
                  .map((e) => CircuitVerseContributor.fromJson(e))
                  .toList(),
            ),
          );

          await _pumpAboutView(tester);
          await tester.pumpAndSettle();

          expect(find.byType(ContributorAvatar), findsNWidgets(3));
        });
      });
    });
  });
}
