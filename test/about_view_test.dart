import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/mock_data/contributors_mock_data.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/about/components/contributor_avatar.dart';
import 'package:mobile_app/utils/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks.dart';

void main() {
  NavigatorObserver mockObserver;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await setupLocator();
    locator.allowReassignment = true;
  });

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<void> _pumpAboutView(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        onGenerateRoute: Router.generateRoute,
        navigatorObservers: [mockObserver],
        home: AboutView(),
      ),
    );

    /// The tester.pumpWidget() call above just built our app widget
    /// and triggered the pushObserver method on the mockObserver once.
    verify(mockObserver.didPush(any, any));
  }

  group('tests about view widgets and different API states', () {
    testWidgets('About View Static Widgets and error response',
        (WidgetTester tester) async {
      await _pumpAboutView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(CVHeader), findsOneWidget);
      expect(find.byType(CVSubheader), findsOneWidget);

      // returning no response from API should throw generic failure
      expect(find.text(Constants.GENERIC_FAILURE), findsOneWidget);
    });
  });

  testWidgets('API success response and renders contributor avatar',
      (WidgetTester tester) async {
    await provideMockedNetworkImages(() async {
      var _mockContributorsApi = MockContributorsApi();
      when(_mockContributorsApi.fetchContributors()).thenAnswer(
        (_) => Future.value(
          contributorsMockData
              .map((e) => CircuitVerseContributors.fromJson(e))
              .toList(),
        ),
      );
      locator.registerSingleton<ContributorsApi>(_mockContributorsApi);

      await _pumpAboutView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ContributorAvatar), findsNWidgets(3));
    });
  });
}
