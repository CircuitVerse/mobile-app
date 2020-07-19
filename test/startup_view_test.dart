import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/startup_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks.dart';

void main() {
  NavigatorObserver mockObserver;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await setupLocator();
  });

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Future<void> _pumpStartUpView(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        onGenerateRoute: Router.generateRoute,
        navigatorObservers: [mockObserver],
        home: StartUpView(),
      ),
    );

    /// The tester.pumpWidget() call above just built our app widget
    /// and triggered the pushObserver method on the mockObserver once.
    verify(mockObserver.didPush(any, any));
  }

  testWidgets('finds CircuitVerse on startup view',
      (WidgetTester tester) async {
    await _pumpStartUpView(tester);

    expect(find.text('CircuitVerse'), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));
  });

  testWidgets('HomeView is pushed over StartUpView',
      (WidgetTester tester) async {
    await _pumpStartUpView(tester);
    await tester.pumpAndSettle(Duration(seconds: 1));

    verify(mockObserver.didPush(any, any));
    expect(find.byType(HomeView), findsOneWidget);
  });
}
