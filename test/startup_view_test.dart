import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/ui/views/home_view.dart';
import 'package:mobile_app/ui/views/login_view.dart';
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
      MaterialApp(
        navigatorKey: locator<NavigationService>().navigatorKey,
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

    expect(find.text("CircuitVerse"), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 1));
  });

  testWidgets('HomeView is pushed over StartUpView if is_logged_in = true',
      (WidgetTester tester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_logged_in", true);

    await _pumpStartUpView(tester);
    await tester.pumpAndSettle(Duration(seconds: 1));

    verify(mockObserver.didPush(any, any));
    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets('LoginView is pushed over StartUpView if is_logged_in = false',
      (WidgetTester tester) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_logged_in", false);

    await _pumpStartUpView(tester);
    await tester.pumpAndSettle(Duration(seconds: 1));

    verify(mockObserver.didPush(any, any));
    expect(find.byType(LoginView), findsOneWidget);
  });
}
