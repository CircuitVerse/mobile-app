import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/home/components/feature_card.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('HomeViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpHomeView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: HomeView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds HomeView Widgets', (WidgetTester tester) async {
      await _pumpHomeView(tester);
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset.zero);
      await gesture.moveBy(const Offset(0, -1000));

      await tester.pumpAndSettle();

      expect(find.text('Dive into the world of Logic Circuits for free!'),
          findsOneWidget);
      expect(find.byType(CVSubheader), findsNWidgets(2));
      expect(find.byType(CVOutlineButton), findsNWidgets(3));
      expect(find.byType(FeatureCard), findsNWidgets(5));
    });
  });
}
